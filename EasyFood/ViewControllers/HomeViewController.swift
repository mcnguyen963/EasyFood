//
//  HomeViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 15/5/2024.
//

import UIKit

let SAVED_RECIPES_KEY = "SAVED_RECIPES_KEY"
class HomeViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate {
    @IBOutlet var homeCollectionView: UICollectionView!
    let REQUEST_STRING = "https://api.spoonacular.com/recipes/random"
    let MAX_ITEMS_PER_REQUEST = 40
    let MAX_REQUESTS = 10
    var currentRequestIndex: Int = 0
    var recipes = [ShortRecipeData]()
    var indicator = UIActivityIndicatorView()
    var onSelectID: Int?
    var savedRecipes: [ShortRecipeData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        RecipeStorage.removeAllSaved()
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerYAnchor),
        ])
        savedRecipes = RecipeStorage.loadRecipes(forKey: "SAVED_RECIPES_KEY") ?? []
        
        Task {
            currentRequestIndex = 0
            await requestRecipeNamed("Chicken")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectID = recipes[indexPath.row].id
        performSegue(withIdentifier: "toDetailSegue", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "homepageCollectionCell", for: indexPath) as! HomepageCollectionViewCell
        if savedRecipes.contains(recipes[indexPath.row]) {
            recipes[indexPath.row].isSaved = true
        }
        cell.setup(with: recipes[indexPath.row])

        return cell
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
                
                if let recipe = cookingData.results {
                    recipes.append(contentsOf: recipe)
                    
                    homeCollectionView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetailSegue" {
            let destination = segue.destination as! DetailViewController
            destination.recipesID = onSelectID
        }
    }
    
    func getRecipesTest() {
        recipes = RecipeStorage.loadRecipes(forKey: SAVED_RECIPES_KEY) ?? []
    }
    
    func didTapSaveButton(recipes: ShortRecipeData) {
        if !recipes.isSaved {
            recipes.isSaved = true
            RecipeStorage.addRecipe(recipe: recipes, forKey: "SAVED_RECIPES_KEY")
        } else {
            recipes.isSaved = false
            RecipeStorage.removeRecipe(recipes, forKey: "SAVED_RECIPES_KEY")
        }
    }
    
    @IBAction func saveRecipe(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: homeCollectionView)
        if let indexPath = homeCollectionView.indexPathForItem(at: buttonPosition) {
            let recipe = recipes[indexPath.row]
            didTapSaveButton(recipes: recipe)
            homeCollectionView.reloadItems(at: [indexPath])
        }
    }
}
