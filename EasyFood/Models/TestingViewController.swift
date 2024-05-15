////
////  TestingViewController.swift
////  EasyFood
////
////  Created by Nick Nguyen on 11/5/2024.
////
//
// import UIKit
//
// class TestingViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
//    @IBOutlet var colletionView: UICollectionView!
//
//    let REQUEST_STRING = "https://api.spoonacular.com/recipes/random"
//    let MAX_ITEMS_PER_REQUEST = 40
//    let MAX_REQUESTS = 10
//    var currentRequestIndex: Int = 0
//
//    var recipes = [ShortRecipeData]()
//    var indicator = UIActivityIndicatorView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        colletionView.dataSource = self
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar.delegate = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search"
//        searchController.searchBar.showsCancelButton = false
//        navigationItem.searchController = searchController
//        // Ensure the search bar is always visible.
//        navigationItem.hidesSearchBarWhenScrolling = false
//        // Add a loading indicator view
//        indicator.style = UIActivityIndicatorView.Style.large
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(indicator)
//        NSLayoutConstraint.activate([
//            indicator.centerXAnchor.constraint(equalTo:
//                view.safeAreaLayoutGuide.centerXAnchor),
//            indicator.centerYAnchor.constraint(equalTo:
//                view.safeAreaLayoutGuide.centerYAnchor),
//        ])
//        Task {
//            currentRequestIndex = 0
//            await requestRecipeNamed("Chicken")
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return recipes.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestingCollectionViewCell", for: indexPath) as! TestingCollectionViewCell
//        cell.setup(with: recipes[indexPath.row])
//        return cell
//    }
//
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         // Get the new view controller using segue.destination.
//         // Pass the selected object to the new view controller.
//     }
//     */
//    func requestRecipeNamed(_ recipeName: String) async {
//        var searchURLComponents = URLComponents()
//        searchURLComponents.scheme = "https"
//        searchURLComponents.host = "api.spoonacular.com"
//        searchURLComponents.path = "/recipes/complexSearch"
//        searchURLComponents.queryItems = [
//            URLQueryItem(name: "maxResults", value: "\(MAX_ITEMS_PER_REQUEST)"),
//            URLQueryItem(name: "startIndex", value: "\(currentRequestIndex * MAX_ITEMS_PER_REQUEST)"),
//            URLQueryItem(name: "apiKey", value: "baee3d6b25894651a9d3904b9fed4428"),
//
//            URLQueryItem(name: "query", value: recipeName),
//        ]
//        guard let requestURL = searchURLComponents.url else {
//            print("Invalid URL.")
//            return
//        }
//
//        let urlRequest = URLRequest(url: requestURL)
//
//        do {
//            let (data, response) =
//                try await URLSession.shared.data(for: urlRequest)
//            indicator.stopAnimating()
//            do {
//                let decoder = JSONDecoder()
//
//                let cookingData = try decoder.decode(CookingData.self, from: data)
//
//                if let recipe = cookingData.results {
//                    recipes.append(contentsOf: recipe)
//                    colletionView.reloadData()
//                    if recipes.count == MAX_ITEMS_PER_REQUEST,
//                       currentRequestIndex + 1 < MAX_REQUESTS
//                    {
//                        currentRequestIndex += 1
//                        await requestRecipeNamed(recipeName)
//                    }
//                }
//            } catch {
//                print(error)
//            }
//
//        } catch {
//            print(error)
//        }
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        guard let searchText = searchBar.searchTextField.text else {
//            return
//        }
//
//        recipes.removeAll()
//        colletionView.reloadData()
//
//        navigationItem.searchController?.dismiss(animated: true)
//        indicator.startAnimating()
//        Task {
//            URLSession.shared.invalidateAndCancel()
//            currentRequestIndex = 0
//            await requestRecipeNamed(searchText)
//        }
//    }
// }
