//
//  model.swift
//  Leftoverz
//
//  Created by Johann Antisseril on 4/24/23.
//

import Foundation

class Fridge: ObservableObject {
    struct Food {
        var name:String
        var expireDate:Date
        //var image
        
    }
    @Published var fridgeList:[Food] = [Food(name:"Apple", expireDate: Date()), Food(name:"Banana", expireDate: Date())]
    func addItem(itemName:String, dateExpire:Date) {
        fridgeList.append( Food(name: itemName, expireDate: dateExpire) )
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
        let items:[String] = [] //have to add ingredients here
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
