//
//  ShortRecipeData.swift
//  EasyFood
//
//  Created by Nick Nguyen on 10/5/2024.
//

import UIKit

class ShortRecipeData: NSObject, Decodable {
    var title: String
    var image: String
    var id: Int

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
    }
}
