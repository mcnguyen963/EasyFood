//
//  ShortRecipeData.swift
//  EasyFood
//
//  Created by Nick Nguyen on 10/5/2024.
//

import Foundation
import UIKit

class ShortRecipeData: NSObject, Decodable, Encodable {
    var title: String
    var image: String
    var id: Int
    var isSaved: Bool
    private enum ShortRecipeKey: String, CodingKey {
        case title
        case image
        case id
    }

    required init(from decoder: Decoder) throws {
        let recipeContainer = try decoder.container(keyedBy: ShortRecipeKey.self)

        // Get the book info
        title = try recipeContainer.decode(String.self, forKey: .title)
        id = try recipeContainer.decode(Int.self, forKey: .id)
        image = try recipeContainer.decode(String.self, forKey: .image)
        isSaved = false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ShortRecipeKey.self)
        try container.encode(title, forKey: .title)
        try container.encode(id, forKey: .id)
        try container.encode(image, forKey: .image)
    }
}

extension UserDefaults {
    func saveRecipes(_ recipes: [ShortRecipeData], forKey key: String) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(recipes) {
            set(encodedData, forKey: key)
        }
    }

    func loadRecipes(forKey key: String) -> [ShortRecipeData]? {
        if let savedData = data(forKey: key) {
            let decoder = JSONDecoder()
            if let loadedRecipes = try? decoder.decode([ShortRecipeData].self, from: savedData) {
                return loadedRecipes
            }
        }
        return nil
    }
}
