//
//  DetailViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 16/5/2024.
//

import UIKit

class DetailViewController: UIViewController {
    var recipesID: Int?
    var recipesData: DetailRecipeData?
    var indicator = UIActivityIndicatorView()

    @IBOutlet var briefInforText: UITextView!
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var descriptionTextField: UITextView!
    @IBOutlet var recipeName: UITextView!

    @IBOutlet var ingredientsTextField: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

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

    func updatinData() {
        if recipesData != nil {
            recipeName.text = recipesData?.title ?? ""
            briefInforText.text = "Price per Services: $\(recipesData?.pricePerServing ?? 0) || Est \(recipesData?.readyInMinutes ?? 0) Minutes ||\(recipesData?.servings ?? 0) Servings || Healthy Score:\(recipesData?.healthScore ?? 0)"
            descriptionTextField.text = recipesData?.summary ?? ""
            print("he")
        }
//        if let Recipedata = recipesData {
//            recipeName.text = Recipedata.title
//            briefInforText.text = "Price per Services: $\(Recipedata.pricePerServing) || Est \(Recipedata.readyInMinutes) Minutes ||\(Recipedata.servings) Servings || Healthy Score:\(Recipedata.healthScore)"
//            descriptionTextField.text = Recipedata.summary
//            var igredientList = ""
//            for ingre in Recipedata.extendedIngredients {
//                igredientList = "\(igredientList)\(ingre.name) \n"
//            }
//            ingredientsTextField.text = igredientList
//        }
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
}
