//
//  SearchCollectionViewCell.swift
//  EasyFood
//
//  Created by Nick Nguyen on 15/5/2024.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var title: UILabel!

    func setup(with shortRecipeData: ShortRecipeData) {
        if let imageURL = URL(string: shortRecipeData.image) {
            URLQueryItem(name: "apiKey", value: "baee3d6b25894651a9d3904b9fed4428")

            getImage(from: imageURL)
        } else {
            print("Invalid image URL: \(shortRecipeData.image)")
        }
        title.text = shortRecipeData.title
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
                    self.imageView.image = image
                }
            }
        }

        // Resume the task
        task.resume()
    }
}
