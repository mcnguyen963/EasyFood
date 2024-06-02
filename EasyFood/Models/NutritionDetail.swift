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
    func amountInGrams() -> Float {
        switch unit {
        case "mg":
            return amount / 1000
        case "kg":
            return amount*1000
        case "g", "gram", "grams":
            return amount
        case "kcal":
            return amount*0.129598
        case "cal":
            return amount*0.129598*0.001
        case "µg":
            return amount / 1000000
        case "IU":
            return amount*0.67 / 1000
        default:
            return amount
        }
    }
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
