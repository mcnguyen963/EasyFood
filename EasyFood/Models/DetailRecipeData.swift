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

struct Step: Decodable {
    var number: Int
    var step: String
    var ingredients: [ShortIngredient]
    var equipment: [Equipment]
}

struct AnalyzedInstructions: Decodable {
    var name: String?
    var steps: [Step]
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
    var analyzedInstructions: [AnalyzedInstructions]
    var diets: [String]

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
        case diets
    }

    required init(from decoder: Decoder) throws {
        let recipeContainer = try decoder.container(keyedBy: ShortRecipeKey.self)
//        let cookingStepContainer = try recipeContainer.nestedContainer(keyedBy:
//            CookingStepKey.self, forKey: .analyzedInstructions)

        title = try recipeContainer.decode(String.self, forKey: .title)
        id = try recipeContainer.decode(Int.self, forKey: .id)
        image = try recipeContainer.decode(String.self, forKey: .image)
        vegetarian = try recipeContainer.decode(Bool.self, forKey: .vegetarian)
        healthScore = try recipeContainer.decode(Int.self, forKey: .healthScore)
        pricePerServing = try recipeContainer.decode(Float.self, forKey: .pricePerServing)
        readyInMinutes = try recipeContainer.decode(Int.self, forKey: .readyInMinutes)
        servings = try recipeContainer.decode(Int.self, forKey: .servings)
        summary = try recipeContainer.decode(String.self, forKey: .summary)
        diets = try recipeContainer.decode([String].self, forKey: .diets)
        analyzedInstructions = try recipeContainer.decode([AnalyzedInstructions].self, forKey: .analyzedInstructions)
        extendedIngredients = try recipeContainer.decode([IngredientData].self, forKey: .extendedIngredients)
//        let instructions = try recipeContainer.decode([AnalyzedInstructions].self, forKey: .analyzedInstructions)

//        analyzedInstructions = try recipeContainer.decode([CookingStep].self, forKey: .steps)

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
