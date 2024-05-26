//
//  DetailViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 16/5/2024.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var recipesID: Int?
    var recipesData: DetailRecipeData?
    var indicator = UIActivityIndicatorView()
    var scrollView: UIScrollView!
    @IBOutlet var detailCollectionViewField: UICollectionView!

    @IBOutlet var imageViewField: UIImageView!

    @IBOutlet var cookingStepCollectionView: UICollectionView!
    @IBOutlet var briefInforText: UITextView!
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var descriptionTextField: UITextView!
    @IBOutlet var recipeName: UITextView!

    @IBOutlet var detailCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        detailCollectionViewField.delegate = self
        detailCollectionViewField.dataSource = self
//        cookingStepCollectionView.delegate = self
//        cookingStepCollectionView.dataSource = self

        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerYAnchor),
        ])
        indicator.startAnimating()

        if recipesID != nil {
            Task {
                await getReceiptData(id: recipesID ?? 0)
                updatinData()
            }
        }

        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width
        let height = view.frame.size.width * 1 / 40 // ratio
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipesData?.extendedIngredients.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == detailCollectionViewField {
//            let cell = detailCollectionViewField.dequeueReusableCell(withReuseIdentifier: "ingredientCollectionCell", for: indexPath) as! DetailCollectionViewCell
//            cell.setup(ingredientData: recipesData?.extendedIngredients[indexPath.row])
//            return cell
//        }
        ////        if collectionView == cookingStepCollectionView {
        ////            let cell = cookingStepCollectionView.dequeueReusableCell(withReuseIdentifier: "cookingStepViewCell", for: indexPath) as! CookingStepCollectionViewCell
        ////            cell.setup(stepData: recipesData.analyzedInstructions.steps[indexPath.row])
        ////            return cell
        ////        }
//        return UICollectionViewCell()
        let cell = detailCollectionViewField.dequeueReusableCell(withReuseIdentifier: "ingredientCollectionCell", for: indexPath) as! DetailCollectionViewCell
        cell.setup(ingredientData: recipesData?.extendedIngredients[indexPath.row])
        return cell
    }

    func updatinData() {
        if recipesData != nil {
            recipeName.text = recipesData?.title ?? ""
            briefInforText.text = "Price per Services: $\(recipesData?.pricePerServing ?? 0) || Est \(recipesData?.readyInMinutes ?? 0) Minutes ||\(recipesData?.servings ?? 0) Servings || Healthy Score:\(recipesData?.healthScore ?? 0)"
            descriptionTextField.text = recipesData?.summary ?? ""
            cookingStepCollectionView.reloadData()
            print("he")
        }
    }

    func getReceiptData(id: Int) async {
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "api.spoonacular.com"
        searchURLComponents.path = "/recipes/\(String(recipesID ?? 0))/information"
        searchURLComponents.queryItems = [
            URLQueryItem(name: "apiKey", value: "baee3d6b25894651a9d3904b9fed4428"),
        ]
        guard let requestURL = searchURLComponents.url else {
            print("Invalid URL.")
            return
        }

        let urlRequest = URLRequest(url: requestURL)
        print(urlRequest)
        do {
            let (data, _) =
                try await URLSession.shared.data(for: urlRequest)
            indicator.stopAnimating()
            do {
                let decoder = JSONDecoder()

                let cookingData = try decoder.decode(DetailRecipeData.self, from: data)
                recipesData = cookingData
                loadImage()
            } catch {
                print(error)
            }

        } catch {
            print(error)
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
    func loadImage() {
        if let imageURL = URL(string: recipesData?.image ?? "") {
            URLQueryItem(name: "apiKey", value: "baee3d6b25894651a9d3904b9fed4428")

            getImage(from: imageURL)
        } else {
            print("Invalid image URL: \(recipesData?.image ?? "")")
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

class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameField: UILabel!

    @IBOutlet var unitField: UILabel!
    func setup(ingredientData: IngredientData?) {
        if let a = ingredientData {
            nameField.text = a.name
            unitField.text = "\(a.amount) \(a.unit ?? "")"
        }
    }
}

class CookingStepCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    func setup(stepData: Step?) {
        if let temp = stepData {
            label.text = "\(temp.number): \(temp.step)"
        }
    }
}
