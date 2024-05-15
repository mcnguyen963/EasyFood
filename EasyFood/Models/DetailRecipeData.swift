//
//  DetailRecipeData.swift
//  EasyFood
//
//  Created by Nick Nguyen on 12/5/2024.
//

import UIKit

struct Equipment: Decodable {
    var id: Int
    var name: String
    var image: String
}

struct ShortIngredient: Decodable {
    var id: Int
    var name: String
    var image: String
}

struct CookingStep: Decodable {
    var number: Int
    var step: String
    var ingredient: [ShortIngredient]
    var equipments: [Equipment]
}

class DetailRecipeData: NSObject, Decodable {
    var title: String
    var image: String
    var id: Int
    var vegetarian: Bool
    var healthScore: Int
    var pricePerServing: Float
    var extendedIngredients: [IngredientData]
    var readyInMinutes: Int
    var servings: Int
    var summary: String
    var analyzedInstructions: [CookingStep]

    private enum ShortRecipeKey: String, CodingKey {
        case title
        case image
        case id
        case vegetarian
        case healthScore
        case pricePerServing
        case extendedIngredients
        case readyInMinutes
        case servings
        case summary
        case analyzedInstructions
    }

    required init(from decoder: Decoder) throws {
        let recipeContainer = try decoder.container(keyedBy: ShortRecipeKey.self)

        // Get the book info
        title = try recipeContainer.decode(String.self, forKey: .title)
        id = try recipeContainer.decode(Int.self, forKey: .id)
        image = try recipeContainer.decode(String.self, forKey: .image)
        vegetarian = try recipeContainer.decode(Bool.self, forKey: .vegetarian)
        healthScore = try recipeContainer.decode(Int.self, forKey: .healthScore)
        pricePerServing = try recipeContainer.decode(Float.self, forKey: .pricePerServing)
        extendedIngredients = try recipeContainer.decode([IngredientData].self, forKey: .extendedIngredients)
        readyInMinutes = try recipeContainer.decode(Int.self, forKey: .readyInMinutes)
        servings = try recipeContainer.decode(Int.self, forKey: .servings)
        summary = try recipeContainer.decode(String.self, forKey: .summary)
        analyzedInstructions = try recipeContainer.decode([CookingStep].self, forKey: .analyzedInstructions)

//        {
//            // Loop through array and find the ISBN13
//            for step in steps {
//                if step.type == "ISBN_13" {
//                    isbn13 = code.identifier
//                }
//            }
//        }
    }
}
