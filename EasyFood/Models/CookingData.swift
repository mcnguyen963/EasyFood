//
//  CookingData.swift
//  EasyFood
//
//  Created by Nick Nguyen on 10/5/2024.
//

import UIKit

class CookingData: NSObject, Decodable {
    var results: [ShortRecipeData]?

    private enum CodingKeys: String, CodingKey {
        case results
    }
}
