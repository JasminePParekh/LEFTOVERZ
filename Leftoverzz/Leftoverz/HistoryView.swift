//
//  HistoryView.swift
//  Leftoverz
//
//  Created by Johann Antisseril on 4/25/23.
//

import Foundation
import SwiftUI

struct Recipe : Codable {
    var name: String
    var ingredients: [String]
}

struct RecipeView: View {
    @Binding var showRecipe: Bool
    @State var recipeName: String
    @ObservedObject var recipes : Recipes = Recipes()
    @State var ingredients: [String] = ["Ingredient1", "Ingredient2", "Ingredient3"]
    
    var body: some View {
        VStack {
            Text("\(recipeName)")
            List (ingredients, id: \.self) { ingredient in
                Text("\(ingredient)")
            }
        }.onAppear {
//            ingredients = recipes.getFile(name: recipeName).ingredients
            ingredients = ["Ingredient1", "Ingredient2", "Ingredient3"] // Temp. Take line out and uncomment line above
        }
    }
}

struct HistoryView: View {
    @State var showRecipe: Bool = false
    @State var history: [String] = ["Example1", "Example2", "Example3"] // Temp. Take examples out
    @ObservedObject var recipes : Recipes = Recipes()
    @State var madeHist = false

    
    var body: some View {
        NavigationStack {
            Text("History View")
            List(history, id: \.self){ file in
                NavigationLink {
                    RecipeView(showRecipe: $showRecipe, recipeName: file)
                } label: {
                    Text("\(file)")
                }
            }
        }.onAppear {
            if !madeHist {
                madeHist = true
                let recipeNames: [String] = recipes.getAllFiles()
                
                for r in recipeNames {
                    history.append(r)
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environmentObject(Recipes())
    }
}
