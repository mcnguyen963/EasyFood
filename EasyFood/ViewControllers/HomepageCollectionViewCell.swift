//
//  HomepageCollectionViewCell.swift
//  EasyFood
//
//  Created by Nick Nguyen on 15/5/2024.
//

import UIKit

class HomepageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var saveButton: UIButton!
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

    @IBAction func saveRecipes(_ sender: Any) {
        if currentRecipe != nil {
            if currentRecipe!.isSaved {
                currentRecipe!.isSaved = true
                RecipeStorage.addRecipe(recipe: currentRecipe!, forKey: "SAVED_RECIPES_KEY")
            } else {
                currentRecipe!.isSaved = false
                RecipeStorage.removeRecipe(currentRecipe!, forKey: "SAVED_RECIPES_KEY")
            }
        }
    }
}
