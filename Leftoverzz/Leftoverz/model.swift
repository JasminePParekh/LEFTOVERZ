//
//  model.swift
//  GroupTest
//
//  Created by Jasmine Parekh on 4/25/23.
//

import Foundation
import Alamofire
import SwiftyJSON


class SearchObject: ObservableObject{
    @Published var recipes: [RecipeView]
    @Published var searchIngredients: [String]
    var noImageAvailableIcon = "https://t4.ftcdn.net/jpg/04/00/24/31/360_F_400243185_BOxON3h9avMUX10RsDkt3pJ8iQx72kS3.jpg"
    
    init () {
        recipes = [RecipeView]()
        searchIngredients = [String]()
    }
    
    
    func getUrl(request: String){
        let searchIngredients = request.components(separatedBy: ", ")
        print(searchIngredients)
        var url = "https://api.edamam.com/search?q="
        for i in searchIngredients {
            let ingredient = i.lowercased().replacingOccurrences(of: " ", with: "")
            url += ingredient
            url += ","
        }
        url = String(url.dropLast())
        
        url += "&app_id=e3d29ce5&app_key=c7f6c824aef88b770cedbf1254c27cd6&from=0&to=10"

        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_, value) in json["hits"] {
                    let recipe = value["recipe"]
                    var ingredients = [String]()
                    for (_, ingredient) in recipe["ingredientLines"] {
                        ingredients.append(ingredient.rawString()!)
                    }
                    self.recipes.append(RecipeView(recipe:Recipe(name: recipe["label"].rawString() ?? "Recipe Name Unavailable", imageUrl: recipe["image"].rawString() ?? self.noImageAvailableIcon, sourceUrl: recipe["url"].rawString() ?? "Recipe not available at this time", ingredients: ingredients, isLiked: false)))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}

struct Recipe: Codable, Equatable{
    var name: String
    var imageUrl: String
    var sourceUrl: String
    var ingredients: [String]
    var isLiked: Bool
    
    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
        return (lhs.name == rhs.name) && (lhs.ingredients == rhs.ingredients)
    }
}

class ResourcesModel: ObservableObject {
    @Published var favoriteRecipes: [Recipe]
    init() {
        if let data = UserDefaults.standard.data(forKey: "data") {
            print("Loading HOES")
            favoriteRecipes = try! PropertyListDecoder().decode([Recipe].self, from: data)
//            print(favoriteRecipes)
        }
        else {
            favoriteRecipes = [Recipe]()
        }
    }
    func contains(recipe: Recipe) -> Bool{
        for favRecipe in favoriteRecipes {
            if recipe == favRecipe{
                print("YESSIR")
                return true
            }
        }
        return false
    }
    func toggleFav (recipe: Recipe){
        if let index = favoriteRecipes.firstIndex(of: recipe) {
          favoriteRecipes.remove(at: index)
        }
        else {
            favoriteRecipes.append(recipe)
        }
        save()
    }
    func save (){
        if let data = try? PropertyListEncoder().encode(favoriteRecipes) {
            print("HELLO")
            UserDefaults.standard.set(data, forKey: "data")
        }
    }
    func reset() {
        UserDefaults.standard.removeObject(forKey: "data")
    }
}


