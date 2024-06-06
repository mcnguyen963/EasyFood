//
//  RecipeStorage.swift
//  EasyFood
//
//  Created by Nick Nguyen on 26/5/2024.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation
import UIKit

let DEFAULT_TEAM_NAME = UserDefaults.standard.data(forKey: "userID")
var listeners = MulticastDelegate<DatabaseListener>()

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
        if !isStoredRecipes(recipe: recipe, forKey: key) {
            recipe.isSaved = true
            recipesTemp.append(recipe)
            saveRecipes(recipesTemp, forKey: key)
        }
    }

    static func removeRecipe(_ recipe: ShortRecipeData, forKey key: String) {
        var recipes = loadRecipes(forKey: key) ?? []

        if let deleteIndex = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes.remove(at: deleteIndex)
        }

        saveRecipes(recipes, forKey: key)
    }

    static func isStoredRecipes(recipe: ShortRecipeData, forKey key: String) -> Bool {
        var recipesTemp: [ShortRecipeData] = loadRecipes(forKey: key) ?? []
        for temp in recipesTemp {
            if temp.id == recipe.id {
                return true
            }
        }
        return false
    }

    static func removeAllSaved() {
        saveRecipes([], forKey: "PLANNER_RECIPES")
    }

    static func savePlannerRecipes(_ recipes: [DetailRecipeData]) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(recipes)
            UserDefaults.standard.set(encodedData, forKey: "PLANNER_RECIPES")
        } catch {
            print("Failed to encode recipes: \(error)")
        }
    }

    static func loadPlannerRecipes() -> [DetailRecipeData]? {
        guard let savedData = UserDefaults.standard.data(forKey: "PLANNER_RECIPES") else {
            return nil
        }

        let decoder = JSONDecoder()
        do {
            let loadedRecipes = try decoder.decode([DetailRecipeData].self, from: savedData)
            return loadedRecipes
        } catch {
            print("Failed to decode recipes: \(error)")
            return nil
        }
    }

    static func addPlannerRecipe(recipe: DetailRecipeData) {
        var recipesTemp: [DetailRecipeData] = loadPlannerRecipes() ?? []
        if !isInPlannerRecipes(recipe: recipe) {
            recipe.isInPlanner = true
            recipesTemp.append(recipe)
            savePlannerRecipes(recipesTemp)
            for ingredient in recipe.extendedIngredients {
                RecipeStorage.addPlannerIngredient(recipe: ingredient)
            }
        }
    }

    static func removePlannerRecipe(_ recipe: DetailRecipeData) {
        var recipes = loadPlannerRecipes() ?? []

        if let deleteIndex = recipes.firstIndex(where: { $0.id == recipe.id }) {
            for ingredient in recipe.extendedIngredients {
                RecipeStorage.removePlannerIngredient(ingredient)
            }
            recipe.isInPlanner = false
            recipes.remove(at: deleteIndex)
        }

        savePlannerRecipes(recipes)
    }

    static func isInPlannerRecipes(recipe: DetailRecipeData) -> Bool {
        let recipesTemp: [DetailRecipeData] = loadPlannerRecipes() ?? []
        for temp in recipesTemp {
            if temp.id == recipe.id {
                return true
            }
        }
        return false
    }

    static func savePlannerIngredient(_ recipes: [IngredientData]) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(recipes)
            UserDefaults.standard.set(encodedData, forKey: "PLANNER_INGREDIENTS")
        } catch {
            print("Failed to encode recipes: \(error)")
        }
    }

    static func loadPlannerIngredient() -> [IngredientData]? {
        guard let savedData = UserDefaults.standard.data(forKey: "PLANNER_INGREDIENTS") else {
            return nil
        }

        let decoder = JSONDecoder()
        do {
            let loadedRecipes = try decoder.decode([IngredientData].self, from: savedData)
            return loadedRecipes
        } catch {
            print("Failed to decode recipes: \(error)")
            return nil
        }
    }

    static func addPlannerIngredient(recipe: IngredientData) {
        var recipesTemp: [IngredientData] = loadPlannerIngredient() ?? []
        if !isInPlannerIngredient(recipe: recipe) {
            recipesTemp.append(recipe)
        } else {
            var recipes = loadPlannerIngredient() ?? []
            if let indexTemp = recipes.firstIndex(where: { $0.id == recipe.id }) {
                recipes[indexTemp].amount += recipe.amount
            }
        }
        savePlannerIngredient(recipesTemp)
    }

    static func removePlannerIngredient(_ recipe: IngredientData) {
        var recipes = loadPlannerIngredient() ?? []

        if let deleteIndex = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes.remove(at: deleteIndex)
        }

        savePlannerIngredient(recipes)
    }

    static func isInPlannerIngredient(recipe: IngredientData) -> Bool {
        let recipesTemp: [IngredientData] = loadPlannerIngredient() ?? []
        for temp in recipesTemp {
            if temp.id == recipe.id {
                return true
            }
        }
        return false
    }

    static func saveUserInformationToFirebase(userId: String, userInfo: [String: Any], plannedRecipes: [DetailRecipeData], savedRecipes: [ShortRecipeData]) {
        let db = Firestore.firestore()

        // Save user information
        db.collection("users").document(userId).setData(userInfo) { error in
            if let error = error {
                print("Error saving user information: \(error)")
            } else {
                print("User information successfully saved!")
            }
        }

        // Save planned recipes
        for recipe in plannedRecipes {
            do {
                try db.collection("users").document(userId).collection("plannedRecipes").addDocument(from: recipe)
            } catch {
                print("Error saving planned recipe: \(error)")
            }
        }

        // Save saved recipes
        for recipe in savedRecipes {
            do {
                try db.collection("users").document(userId).collection("savedRecipes").addDocument(from: recipe)
            } catch {
                print("Error saving saved recipe: \(error)")
            }
        }
    }

    static func loadPlannedRecipesFromFirebase(userId: String, completion: @escaping ([DetailRecipeData]?, Error?) -> Void) {
        let db = Firestore.firestore()

        db.collection("users").document(userId).collection("plannedRecipes").getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                do {
                    let recipes = try querySnapshot.documents.compactMap { try $0.data(as: DetailRecipeData.self) }
                    completion(recipes, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }

    static func loadSavedRecipesFromFirebase(userId: String, completion: @escaping ([ShortRecipeData]?, Error?) -> Void) {
        let db = Firestore.firestore()

        db.collection("users").document(userId).collection("savedRecipes").getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                do {
                    let recipes = try querySnapshot.documents.compactMap { try $0.data(as: ShortRecipeData.self) }
                    completion(recipes, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }

    static func saveUserInformationToFirebase(userId: String, plannedRecipes: [DetailRecipeData], savedRecipes: [ShortRecipeData]) {
        let db = Firestore.firestore()

        for recipe in plannedRecipes {
            do {
                try db.collection("users").document(userId).collection("plannedRecipes").addDocument(from: recipe)
            } catch {
                print("Error saving planned recipe: \(error)")
            }
        }

        // Save saved recipes
        for recipe in savedRecipes {
            do {
                try db.collection("users").document(userId).collection("savedRecipes").addDocument(from: recipe)
            } catch {
                print("Error saving saved recipe: \(error)")
            }
        }
    }

    static func storeSearchKeyword(_ keyword: String) {
        var keywords = UserDefaults.standard.array(forKey: "searchKeywords") as? [String] ?? []
        keywords.insert(keyword, at: 0)
        if keywords.count > 3 {
            keywords = Array(keywords.prefix(3))
        }
        UserDefaults.standard.set(keywords, forKey: "searchKeywords")
    }

    static func getSearchKeywords() -> [String] {
        UserDefaults.standard.array(forKey: "searchKeywords") as? [String] ?? []
    }
}
