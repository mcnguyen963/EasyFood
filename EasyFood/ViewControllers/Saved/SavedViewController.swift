//
//  SavedViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 27/5/2024.
//

import UIKit

class SavedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionViewField: UICollectionView!

    var recipes = [ShortRecipeData]()
    var onSelectID: Int?
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewField.delegate = self
        collectionViewField.dataSource = self
        getRecipesTest()

        collectionViewField.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }

    @objc private func refreshData(_ sender: Any) {
        getRecipesTest()
        refreshControl.endRefreshing()
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
        performSegue(withIdentifier: "toDetailSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailSegue" {
            let destination = segue.destination as! DetailViewController
            destination.recipesID = onSelectID
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewField.dequeueReusableCell(withReuseIdentifier: "saveViewCell", for: indexPath) as! SaveCollectionViewCell

        if recipes.contains(recipes[indexPath.row]) {
            recipes[indexPath.row].isSaved = true
        }
        cell.setup(with: recipes[indexPath.row])

        return cell
    }

    func getRecipesTest() {
        recipes = RecipeStorage.loadRecipes(forKey: "SAVED_RECIPES_KEY") ?? []
        var totalHeight = CGFloat(50.0 * Double(recipes.count))
        setCollectionViewLayout(collectionView: collectionViewField, height: totalHeight, factionWidth: 1.0)
        collectionViewField.reloadData()
    }

    func didTapSaveButton(recipes: ShortRecipeData) {
        if let index = self.recipes.firstIndex(where: { $0.id == recipes.id }) {
            if !self.recipes[index].isSaved {
                self.recipes[index].isSaved = true
                RecipeStorage.addRecipe(recipe: recipes, forKey: "SAVED_RECIPES_KEY")
                self.recipes.append(self.recipes[index])
            } else {
                RecipeStorage.removeRecipe(recipes, forKey: "SAVED_RECIPES_KEY")

                self.recipes[index].isSaved = false
                if let savedIndex = self.recipes.firstIndex(where: { $0.id == recipes.id }) {
                    self.recipes.remove(at: savedIndex)
                }
            }
        }
    }

    @IBAction func saveItem(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: collectionViewField)
        if let indexPath = collectionViewField.indexPathForItem(at: buttonPosition) {
            let recipe = recipes[indexPath.row]
            didTapSaveButton(recipes: recipe)
            collectionViewField.reloadData()
        }
    }
}

class SaveCollectionViewCell: UICollectionViewCell {
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var cellTitle: UILabel!
    private var currentRecipe: ShortRecipeData?

    func setup(with shortRecipeData: ShortRecipeData) {
        currentRecipe = shortRecipeData
        if let imageURL = URL(string: shortRecipeData.image) {
            URLQueryItem(name: "apiKey", value: "baee3d6b25894651a9d3904b9fed4428")

            getImage(from: imageURL)
        } else {
            print("Invalid image URL: \(shortRecipeData.image)")
        }
        cellTitle.text = shortRecipeData.title
        if shortRecipeData.isSaved {
            saveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            saveButton.setImage(UIImage(systemName: "heart"), for: .normal)
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
                    self.cellImageView.image = image
                }
            }
        }

        // Resume the task
        task.resume()
    }
}
