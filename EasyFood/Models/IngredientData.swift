//
//  IngredientData.swift
//  EasyFood
//
//  Created by Nick Nguyen on 10/5/2024.
//

import UIKit

class IngredientData: NSObject, Codable {
    var id: Int
    var aisle: String
    var name: String
    var amount: Float
    var image: String
    var unit: String?

    private enum IngredientKey: String, CodingKey {
        case id
        case aisle
        case name
        case amount
        case image
        case unit
    }

    required init(from decoder: Decoder) throws {
        let ingredientContainer = try decoder.container(keyedBy: IngredientKey.self)

        // Get the book info
        name = try ingredientContainer.decode(String.self, forKey: .name)
        id = try ingredientContainer.decode(Int.self, forKey: .id)
        aisle = try ingredientContainer.decode(String.self, forKey: .aisle)
        amount = try ingredientContainer.decode(Float.self, forKey: .amount)
        image = try ingredientContainer.decode(String.self, forKey: .image)
        unit = try ingredientContainer.decode(String.self, forKey: .unit)
        image = try ingredientContainer.decode(String.self, forKey: .image)
    }
}
