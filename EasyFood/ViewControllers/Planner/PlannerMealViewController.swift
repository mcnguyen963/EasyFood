//
//  PlannerMealViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 5/6/2024.
//

import UIKit

class PlannerMealViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var plannedMealCollectionView: UICollectionView!
    var recipes = [DetailRecipeData]()
    var savedRecipes: [ShortRecipeData] = []
    var onSelectID: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        plannedMealCollectionView.dataSource = self
        plannedMealCollectionView.delegate = self
        updateData()
    }

    func updateData() {
        savedRecipes = RecipeStorage.loadRecipes(forKey: "SAVED_RECIPES_KEY") ?? []
        recipes = RecipeStorage.loadPlannerRecipes() ?? []
        var totalHeight = CGFloat(300)
        setCollectionViewLayout(collectionView: plannedMealCollectionView, height: totalHeight, factionWidth: 1.0)
        plannedMealCollectionView.reloadData()
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

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectID = recipes[indexPath.row].id
        performSegue(withIdentifier: "plannerToDetailSegue", sender: self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = plannedMealCollectionView.dequeueReusableCell(withReuseIdentifier: "plannerMealCollectionViewCell", for: indexPath) as! PlannerMealCollectionViewCell

        cell.setup(with: recipes[indexPath.row])

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "plannerToDetailSegue" {
            let destination = segue.destination as! DetailViewController
            destination.recipesID = onSelectID
        }
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

class PlannerMealCollectionViewCell: UICollectionViewCell {
    @IBOutlet var cellImageView: UIImageView!

    @IBOutlet var cellTitle: UILabel!

    private var currentRecipe: DetailRecipeData?
    func setup(with shortRecipeData: DetailRecipeData) {
        currentRecipe = shortRecipeData
        if let imageURL = URL(string: shortRecipeData.image) {
            URLQueryItem(name: "apiKey", value: "baee3d6b25894651a9d3904b9fed4428")

            getImage(from: imageURL)
        } else {
            print("Invalid image URL: \(shortRecipeData.image)")
        }
        cellTitle.text = shortRecipeData.title
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
                    self.cellImageView.image = image
                }
            }
        }

        // Resume the task
        task.resume()
    }
}
