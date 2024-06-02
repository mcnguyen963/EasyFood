//
//  NutritionDetail.swift
//  EasyFood
//
//  Created by Nick Nguyen on 2/6/2024.
//

import UIKit

struct Nutrition: Decodable {
    var name: String
    var amount: Float
    var unit: String
    var percentOfDailyNeeds: Float
}

struct Property: Decodable {
    var name: String
    var amount: Float
    var unit: String
}

struct CaloricBreakdown: Decodable {
    var percentProtein: Float
    var percentFat: Float
    var percentCarbs: Float
}

struct WeightPerServing: Decodable {
    var amount: Float
    var unit: String
}

class NutritionDetail: NSObject, Decodable {
    var nutrients: [Nutrition]
    var properties: [Property]
    var caloricBreakdown: CaloricBreakdown
    var weightPerServing: WeightPerServing
    private enum NutritionDetailKey: String, CodingKey {
        case nutrients
        case properties
        case caloricBreakdown
        case weightPerServing
    }

    required init(from decoder: Decoder) throws {
        let nuitritionContainer = try decoder.container(keyedBy: NutritionDetailKey.self)
        nutrients = try nuitritionContainer.decode([Nutrition].self, forKey: .nutrients)
        properties = try nuitritionContainer.decode([Property].self, forKey: .properties)
        caloricBreakdown = try nuitritionContainer.decode(CaloricBreakdown.self, forKey: .caloricBreakdown)
        weightPerServing = try nuitritionContainer.decode(WeightPerServing.self, forKey: .weightPerServing)
    }
}
