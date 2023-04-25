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
    
    var body: some View {
        VStack {
            Text("\(recipeName)")
        }.onAppear {
            List {
                ForEach(recipes.getFile(name: recipeName).ingredients, id: \.self) { ingredient in
                    Text(ingredient)
                }
            }
        }
    }
}

class Recipes : ObservableObject {
    
    func getAllFiles() -> [String] {
        let url: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let items: [String] = try! FileManager.default.contentsOfDirectory(atPath: url!.path)
        return items
    }
    
    func deleteFile() {
        let url: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let items: [String] = try! FileManager.default.contentsOfDirectory(atPath: url!.path)
        do {
            for i in items {
                try FileManager.default.removeItem(at: url!.appendingPathComponent(i))
            }
        } catch {
            print("Failed")
        }
    }
    
    func getFile(name:String) -> Recipe {
        var recipe : Recipe = Recipe(name: "dummy", ingredients: ["string"])
        let url: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let decoder = JSONDecoder.init()
        let file = url?.appendingPathComponent(name)
        if let data = FileManager.default.contents(atPath: file!.path) {
            if let ddata = try? decoder.decode(Recipe.self, from: data) {
                recipe = ddata
            }
        }
        return recipe
    }
    
    func createRecipe() -> Recipe {
        var items:[String] = [] //have to add ingredients here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yy   hh:mm"
        let date = dateFormatter.string(from: Date())
        
        return Recipe(name: "Recipe on " + date, ingredients: items)
    }
    
    func createFile() {
        let url: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let currentPath = createRecipe()
        if let file = url?.appendingPathComponent(currentPath.name) {
            let encoder = JSONEncoder.init()
            let data: Data? = try? encoder.encode(currentPath)
            FileManager.default.createFile(
                atPath: file.path,
                contents: data,
                attributes: nil
            )
        }
    }

}


struct HistoryView: View {
    @State var showRecipe: Bool = false
    @State var history: [String] = []
    @ObservedObject var recipes : Recipes = Recipes()
    @State var madeHist = false

    
    var body: some View {
        NavigationStack {
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
