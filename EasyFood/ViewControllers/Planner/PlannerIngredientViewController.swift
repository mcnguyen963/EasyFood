//
//  PlannerIngredientViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 5/6/2024.
//

import UIKit

class PlannerIngredientViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var ingredientCollectionView: UICollectionView!
    var ingredientList: [IngredientData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientCollectionView.delegate = self
        self.ingredientCollectionView.dataSource = self
        self.updateData()
        // Add swipe gesture recognizer
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        swipeGestureRecognizer.direction = .left
        self.ingredientCollectionView.addGestureRecognizer(swipeGestureRecognizer)
    }

    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        let point = gesture.location(in: self.ingredientCollectionView)
        if let indexPath = self.ingredientCollectionView.indexPathForItem(at: point) {
            self.ingredientCollectionView.performBatchUpdates({
                // Delete the data from your data source
                RecipeStorage.removePlannerIngredient(self.ingredientList[indexPath.row])
                self.ingredientList.remove(at: indexPath.row)
                // Delete the cell from the collection view
                self.ingredientCollectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
    func setCollectionViewLayout(collectionView: UICollectionView, height: CGFloat, factionWidth: CGFloat) {
        let layout = UICollectionViewCompositionalLayout { (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(factionWidth), heightDimension: .estimated(height))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        collectionView.collectionViewLayout = layout
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.ingredientCollectionView {
            let cell = self.ingredientCollectionView.dequeueReusableCell(withReuseIdentifier: "ingredientPlannerCell", for: indexPath) as! IngredientPlannerCell

            cell.setup(stepData: self.ingredientList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.ingredientCollectionView {
            return self.ingredientList.count
        }
        return 0
    }

    func updateData() {
        self.ingredientList = RecipeStorage.loadPlannerIngredient() ?? []
        var totalHeight = CGFloat(100.0 * Double(self.ingredientList.count))
        self.setCollectionViewLayout(collectionView: self.ingredientCollectionView, height: totalHeight, factionWidth: 1.0)

        self.ingredientCollectionView.reloadData()
    }
}

class IngredientPlannerCell: UICollectionViewCell {
    @IBOutlet var imageViewField: UIImageView!

    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    func setup(stepData: IngredientData?) {
        if let temp = stepData {
            var searchURLComponents = URLComponents()
            searchURLComponents.scheme = "https"
            searchURLComponents.host = "img.spoonacular.com"
            searchURLComponents.path = "/ingredients_100x100/\(String(stepData?.image ?? "pineapple.jpg"))"

            guard let requestURL = searchURLComponents.url else {
                print("Invalid URL.")
                return
            }

            self.getImage(from: requestURL)

            self.amountLabel.text = "\(temp.amount) \(temp.unit ?? "")"
            self.titleLabel.text = temp.name
        }
    }

    func getImage(from url: URL) {
        let session = URLSession.shared

        let task = session.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                print("Error downloading image: \(error)")
                return
            }

            // Ensure there's data
            guard let imageData = data else {
                print("No image data")
                return
            }

            // Convert data to UIImage
            if let image = UIImage(data: imageData) {
                // Update UI on the main thread
                DispatchQueue.main.async {
                    // Set the downloaded image to the image view
                    self.imageViewField.image = image
                }
            }
        }

        // Resume the task
        task.resume()
    }
}
