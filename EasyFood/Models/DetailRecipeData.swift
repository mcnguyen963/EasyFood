//
//  DetailRecipeData.swift
//  EasyFood
//
//  Created by Nick Nguyen on 12/5/2024.
//

import UIKit

struct Equipment: Codable {
    var id: Int
    var name: String
    var image: String
}

struct ShortIngredient: Codable {
    var id: Int
    var name: String
    var image: String
}

struct Step: Codable {
    var number: Int
    var step: String
    var ingredients: [ShortIngredient]
    var equipment: [Equipment]
}

struct AnalyzedInstructions: Codable {
    var name: String?
    var steps: [Step]
}

class DetailRecipeData: NSObject, Decodable, Encodable {
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
    var isInPlanner: Bool

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
        case isInPlanner
    }

    required init(from decoder: Decoder) throws {
        let recipeContainer = try decoder.container(keyedBy: ShortRecipeKey.self)

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
        isInPlanner = false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ShortRecipeKey.self)
        try container.encode(title, forKey: .title)
        try container.encode(id, forKey: .id)
        try container.encode(image, forKey: .image)
        try container.encode(vegetarian, forKey: .vegetarian)
        try container.encode(healthScore, forKey: .healthScore)
        try container.encode(pricePerServing, forKey: .pricePerServing)
        try container.encode(readyInMinutes, forKey: .readyInMinutes)
        try container.encode(servings, forKey: .servings)
        try container.encode(summary, forKey: .summary)
        try container.encode(diets, forKey: .diets)
        try container.encode(analyzedInstructions, forKey: .analyzedInstructions)
        try container.encode(extendedIngredients, forKey: .extendedIngredients)
        try container.encode(isInPlanner, forKey: .isInPlanner)
    }
}
