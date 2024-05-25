//
//  RecipeStorage.swift
//  EasyFood
//
//  Created by Nick Nguyen on 26/5/2024.
//

import Foundation
import UIKit

class RecipeStorage: NSObject {
    static func saveRecipes(_ recipes: [ShortRecipeData], forKey key: String) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(recipes)
            UserDefaults.standard.set(encodedData, forKey: key)
        } catch {
            print("Failed to encode recipes: \(error)")
        }
    }

    static func loadRecipes(forKey key: String) -> [ShortRecipeData]? {
        guard let savedData = UserDefaults.standard.data(forKey: key) else {
            return nil
        }

        let decoder = JSONDecoder()
        do {
            let loadedRecipes = try decoder.decode([ShortRecipeData].self, from: savedData)
            return loadedRecipes
        } catch {
            print("Failed to decode recipes: \(error)")
            return nil
        }
    }

    static func addRecipe(recipe: ShortRecipeData, forKey key: String) {
        var recipesTemp: [ShortRecipeData] = loadRecipes(forKey: key) ?? []
        if isStoredRecipes(recipe: recipe, forKey: key) {
            recipesTemp.append(recipe)
            saveRecipes(recipesTemp, forKey: key)
        }
    }

    static func removeRecipe(_ recipe: ShortRecipeData, forKey key: String) {
        var recipes = loadRecipes(forKey: key) ?? []
        if let index = recipes.firstIndex(of: recipe) {
            recipes.remove(at: index)
            saveRecipes(recipes, forKey: key)
        }
    }

    static func isStoredRecipes(recipe: ShortRecipeData, forKey key: String) -> Bool {
        var recipesTemp: [ShortRecipeData] = loadRecipes(forKey: key) ?? []
        if recipesTemp != [] {
            if recipesTemp.contains(recipe) {
                return true
            }
        }
        return false
    }
}
