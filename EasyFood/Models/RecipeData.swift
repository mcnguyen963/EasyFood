////
////  RecipeData.swift
////  EasyFood
////
////  Created by Nick Nguyen on 10/5/2024.
////
//
// import UIKit
//
// class RecipeData: NSObject, Decodable {
//    var title: String
//    var image: String
//    var servings: Int
//    var readyInMinutes: Int
//    var healthScore: Float
//    var spoonacularScore: Float
//    var pricePerServing: Float
//    var cheap: Bool
//    var vegan: Bool
//    var veryHealthy: Bool
//    var veryPopular: Bool
//    var extendedIngredients: [IngredientData]
//    var summary: String
//
//    private enum RootKeys: String, CodingKey {
//        case recipes = "results"
//    }
//
//    private enum RecipeKey: String, CodingKey {
//        case title
//        case image
//        case servings
//        case readyInMinutes
//        case healthScore
//        case spoonacularScore
//        case pricePerServing
//        case cheap
//        case vegan
//        case veryHealthy
//        case extendedIngredients
//        case summary
//        case veryPopular
//    }
//
//    private enum ImageKeys: String, CodingKey {
//        case smallThumbnail
//    }
//
//    required init(from decoder: Decoder) throws {
//        // Get the root container first
//        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
//        // Get the book container for most info
//        let recipeContainer = try rootContainer.nestedContainer(keyedBy:
//            RecipeKey.self, forKey: .recipes)
//        // Get the image links container for the thumbnail
//        let imageContainer = try recipeContainer.nestedContainer(keyedBy:
//            ImageKeys.self, forKey: .image)
//
//        // Get the book info
//        title = try recipeContainer.decode(String.self, forKey: .title)
//        servings = try recipeContainer.decode(Int.self, forKey: .servings)
//
//        readyInMinutes = try recipeContainer.decode(Int.self, forKey: .readyInMinutes)
//        healthScore = try recipeContainer.decode(Float.self, forKey: .healthScore)
//        spoonacularScore = try recipeContainer.decode(Float.self, forKey: .spoonacularScore)
//        pricePerServing = try recipeContainer.decode(Float.self, forKey: .pricePerServing)
//
//        cheap = try recipeContainer.decode(Bool.self, forKey: .cheap)
//        vegan = try recipeContainer.decode(Bool.self, forKey: .vegan)
//        veryHealthy = try recipeContainer.decode(Bool.self, forKey: .veryHealthy)
//        veryPopular = try recipeContainer.decode(Bool.self, forKey: .veryPopular)
//
//        summary = try recipeContainer.decode(String.self, forKey: .summary)
//
//        servings = try recipeContainer.decode(Int.self, forKey: .servings)
//
//        image = try imageContainer.decode(String.self, forKey: .smallThumbnail)
//
//        extendedIngredients = try recipeContainer.decode([IngredientData].self, forKey: .extendedIngredients)
//    }
// }
