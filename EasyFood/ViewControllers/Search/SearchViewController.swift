//
//  SearchViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 15/5/2024.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate {
    let REQUEST_STRING = "https://api.spoonacular.com/recipes/random"
    let MAX_ITEMS_PER_REQUEST = 40
    let MAX_REQUESTS = 10
    var currentRequestIndex: Int = 0
    var recipes = [ShortRecipeData]()
    var indicator = UIActivityIndicatorView()

    @IBOutlet var thirdSuggestion: UIButton!
    @IBOutlet var secondSuggestion: UIButton!
    @IBOutlet var firstSuggestion: UIButton!
    @IBOutlet var searchCollectionView: UICollectionView!

    var onSelectID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController

        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerYAnchor),
        ])
        Task {
            currentRequestIndex = 0
        }
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: "searchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        cell.setup(with: recipes[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectID = recipes[indexPath.row].id
        performSegue(withIdentifier: "toDetailSegue", sender: self)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func requestRecipeNamed(_ recipeName: String) async {
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "api.spoonacular.com"
        searchURLComponents.path = "/recipes/complexSearch"
        searchURLComponents.queryItems = [
            URLQueryItem(name: "maxResults", value: "\(MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "startIndex", value: "\(currentRequestIndex * MAX_ITEMS_PER_REQUEST)"),
            URLQueryItem(name: "apiKey", value: "baee3d6b25894651a9d3904b9fed4428"),

            URLQueryItem(name: "query", value: recipeName),
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

                let cookingData = try decoder.decode(CookingData.self, from: data)
                updateSuggestion(newSearch: recipeName)
                if let recipe = cookingData.results {
                    recipes.append(contentsOf: recipe)
                    searchCollectionView.reloadData()
                    if recipes.count == MAX_ITEMS_PER_REQUEST,
                       currentRequestIndex + 1 < MAX_REQUESTS
                    {
                        currentRequestIndex += 1
                        await requestRecipeNamed(recipeName)
                    }
                }
            } catch {
                print(error)
            }

        } catch {
            print(error)
        }
    }

    func updateSuggestion(newSearch: String) {
        thirdSuggestion.setTitle(secondSuggestion.titleLabel?.text ?? "...", for: .normal)
        secondSuggestion.setTitle(firstSuggestion.titleLabel?.text ?? "...", for: .normal)
        firstSuggestion.setTitle(newSearch, for: .normal)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.searchTextField.text else {
            return
        }

        recipes.removeAll()
        searchCollectionView.reloadData()

        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()
        Task {
            URLSession.shared.invalidateAndCancel()
            currentRequestIndex = 0
            await requestRecipeNamed(searchText)
        }
    }

    @IBAction func firstButtonSearch(_ sender: Any) {
        recipes.removeAll()
        searchCollectionView.reloadData()
        indicator.startAnimating()
        Task {
            currentRequestIndex = 0
            await requestRecipeNamed(firstSuggestion.titleLabel?.text ?? "")
        }
    }

    @IBAction func secondButtonSearch(_ sender: Any) {
        recipes.removeAll()
        searchCollectionView.reloadData()
        indicator.startAnimating()
        Task {
            currentRequestIndex = 0

            await requestRecipeNamed(secondSuggestion.titleLabel?.text ?? "")
        }
    }

    @IBAction func thirdButtonSearch(_ sender: Any) {
        recipes.removeAll()
        searchCollectionView.reloadData()
        indicator.startAnimating()
        Task {
            currentRequestIndex = 0

            await requestRecipeNamed(thirdSuggestion.titleLabel?.text ?? "")
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetailSegue" {
            let destination = segue.destination as! DetailViewController
            destination.recipesID = onSelectID
        }
    }
}
