//
//  DetailViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 16/5/2024.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var recipesID: Int?
    var recipesData: DetailRecipeData?
    var indicator = UIActivityIndicatorView()
    var scrollView: UIScrollView!

    @IBOutlet var detailCollectionViewField: UICollectionView!
    @IBOutlet var briefInforText: UITextView!
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var descriptionTextField: UITextView!
    @IBOutlet var recipeName: UITextView!

    @IBOutlet var detailCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        detailCollectionViewField.delegate = self
        detailCollectionViewField.dataSource = self
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
        let noOfCellsInRow = 1

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipesData?.extendedIngredients.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailCollectionViewField.dequeueReusableCell(withReuseIdentifier: "ingredientCollectionCell", for: indexPath) as! DetailCollectionViewCell
        cell.setup(ingredientData: recipesData?.extendedIngredients[indexPath.row])
        return cell
    }

    func updatinData() {
        if recipesData != nil {
            recipeName.text = recipesData?.title ?? ""
            briefInforText.text = "Price per Services: $\(recipesData?.pricePerServing ?? 0) || Est \(recipesData?.readyInMinutes ?? 0) Minutes ||\(recipesData?.servings ?? 0) Servings || Healthy Score:\(recipesData?.healthScore ?? 0)"
            descriptionTextField.text = recipesData?.summary ?? ""
            detailCollectionViewField.reloadData()
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

class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameTextField: UILabel!
    @IBOutlet var quantityTextField: UILabel!

    @IBOutlet var unitTextField: UILabel!

    func setup(ingredientData: IngredientData?) {
        if let a = ingredientData {
            nameTextField.text = a.name
            quantityTextField.text = String(a.amount)
            unitTextField.text = a.unit
        }
    }
}
