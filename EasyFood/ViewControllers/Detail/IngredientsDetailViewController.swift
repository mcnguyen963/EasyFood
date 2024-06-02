//
//  IngredientsDetailViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 1/6/2024.
//

import UIKit

class IngredientsDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var numberOfServingTextField: UITextField!

    @IBOutlet var ingredientCollectionView: UICollectionView!
    var originNumberOfServing = 0
    var numberOfServing = 0
    var ingredientList: [IngredientData]?

    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientCollectionView.delegate = self
        self.ingredientCollectionView.dataSource = self

        self.indicator.style = UIActivityIndicatorView.Style.large
        self.indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.indicator)
        NSLayoutConstraint.activate([
            self.indicator.centerXAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerXAnchor),
            self.indicator.centerYAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerYAnchor),
        ])
        self.indicator.startAnimating()

        if self.ingredientList != nil {
            Task {
                self.updatinData()
                var totalHeight = CGFloat(50.0 * Double(self.ingredientList?.count ?? 1))
                self.setCollectionViewLayout(collectionView: self.ingredientCollectionView, height: totalHeight, factionWidth: 1.0)
            }
            self.indicator.stopAnimating()
        }
    }

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

    func updatinData() {
        if self.ingredientList != nil {
            self.numberOfServingTextField.text = String(self.numberOfServing)
            self.ingredientCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.ingredientCollectionView {
            return self.ingredientList?.count ?? 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.ingredientCollectionView {
            let cell = self.ingredientCollectionView.dequeueReusableCell(withReuseIdentifier: "ingredientsDetailCell", for: indexPath) as! IngredientsDetailCell

            if let ingredientList = self.ingredientList {
                cell.setup(stepData: ingredientList[indexPath.row])
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

class IngredientsDetailCell: UICollectionViewCell {
    @IBOutlet var imageViewField: UIImageView!

    @IBOutlet var TextInputField: UITextField!

    @IBOutlet var unitTextField: UILabel!

    @IBOutlet var unitLabel: UILabel!
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

            self.TextInputField.text = String(temp.amount)
            self.unitTextField.text = temp.name
            self.unitLabel.text = temp.unit
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
