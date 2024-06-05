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

    @IBOutlet var addtoPlannerButton: UIButton!
    var isInPlanner: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        detailCollectionViewField.delegate = self
        detailCollectionViewField.dataSource = self

        cookingStepCollectionView.delegate = self
        cookingStepCollectionView.dataSource = self

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
        setCollectionViewLayout(collectionView: detailCollectionViewField, height: 300.0, factionWidth: 1.0)
        setCollectionViewLayout(collectionView: cookingStepCollectionView, height: 300.0, factionWidth: 1.0)
        cookingStepCollectionView.isScrollEnabled = false
        detailCollectionViewField.isScrollEnabled = false
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == detailCollectionViewField {
            return CGSize(width: collectionView.frame.width, height: 50)
        } else if collectionView == cookingStepCollectionView {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == detailCollectionViewField {
            return recipesData?.extendedIngredients.count ?? 0
        } else {
            return recipesData?.analyzedInstructions[0].steps.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cookingStepCollectionView {
            let cell = cookingStepCollectionView.dequeueReusableCell(withReuseIdentifier: "cookingStepViewCell", for: indexPath) as! CookingStepCollectionViewCell
            cell.setup(stepData: recipesData?.analyzedInstructions[0].steps[indexPath.row])
            return cell
        } else {
            let cell = detailCollectionViewField.dequeueReusableCell(withReuseIdentifier: "ingredientCollectionCell", for: indexPath) as! DetailCollectionViewCell
            cell.setup(ingredientData: recipesData?.extendedIngredients[indexPath.row])
            return cell
        }
    }

    func updatinData() {
        if recipesData != nil {
            recipeName.text = recipesData?.title ?? ""
            briefInforText.text = "Price per Services: $\(recipesData?.pricePerServing ?? 0) || Est \(recipesData?.readyInMinutes ?? 0) Minutes ||\(recipesData?.servings ?? 0) Servings || Healthy Score:\(recipesData?.healthScore ?? 0)"
            descriptionTextField.text = recipesData?.summary ?? ""
            cookingStepCollectionView.reloadData()
            detailCollectionViewField.reloadData()
            if let temp: DetailRecipeData = recipesData {
                if RecipeStorage.isInPlannerRecipes(recipe: temp) {
                    isInPlanner = true
                    addtoPlannerButton.setTitle("Remove from Planner", for: .normal)
                } else {
                    isInPlanner = false
                    addtoPlannerButton.setTitle("Add To Planner", for: .normal)
                }
            }
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
        do {
            let (data, _) =
                try await URLSession.shared.data(for: urlRequest)
            indicator.stopAnimating()
            do {
                let decoder = JSONDecoder()
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print("Failed to convert data to string.")
                }

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

    func loadImage() {
        if let imageURL = URL(string: recipesData?.image ?? "") {
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toIngredientDetailSegue" {
            let destination = segue.destination as! IngredientsDetailViewController
            destination.numberOfServing = recipesData?.servings ?? 0
            destination.ingredientList = recipesData?.extendedIngredients
        }
        if segue.identifier == "toInstructionDetailSegue" {
            let destination = segue.destination as! InstructionViewController
            destination.instructionList = recipesData?.analyzedInstructions[0].steps
        }
        if segue.identifier == "toNuitritionDetailSegue" {
            let destination = segue.destination as! NuitritionViewController
            destination.recipeID = recipesID
        }
    }

    @IBAction func addRecipeToPlanner(_ sender: Any) {
        if isInPlanner {
            if let temp = recipesData {
                RecipeStorage.removePlannerRecipe(temp)
                isInPlanner = false
                let alertController = UIAlertController(title: "Success", message: "Recipe removed successfully!", preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })

                present(alertController, animated: true, completion: nil)
            }
        } else {
            if let temp = recipesData {
                RecipeStorage.addPlannerRecipe(recipe: temp)
                isInPlanner = true

                let alertController = UIAlertController(title: "Success", message: "Recipe added successfully!", preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })

                present(alertController, animated: true, completion: nil)
            }
        }
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
