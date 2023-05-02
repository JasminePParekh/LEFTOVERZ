//
//  Views.swift
//  Leftoverz
//
//  Created by Johann Antisseril on 5/2/23.
//

import Foundation
import SwiftUI

struct TodoItem: Identifiable {
    let id: UUID
    var title: String
    var expiresIn: String
    var expireDate: Date
}

struct ItemView : View {
    @State var item: TodoItem
    @Binding var selectedItems: Set<UUID>
    var selected: Bool {
        selectedItems.contains(item.id)
    }
    
    var body: some View {
        HStack {
            TextField("Title", text: $item.title).foregroundColor(backgroundColor(expireDate: item.expireDate))
            
            Spacer()
            
            if selected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .onTapGesture {
            if selected {
                selectedItems.remove(item.id)
            } else {
                selectedItems.insert(item.id)
            }
        }
    }
}

struct Views: View {
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var item: String = ""
    @State var mvText: String = ""
    @State var items = [TodoItem(id: UUID(), title: "test1", expiresIn: "Ready to Eat", expireDate: Date()), TodoItem(id: UUID(), title: "test2", expiresIn: "1 week", expireDate: Date()), TodoItem(id: UUID(), title: "test3", expiresIn: "2 weeks", expireDate: Date())]
    let options = ["Ready to Eat", "1 week", "2 weeks", "3 weeks"]
    @State private var selection = "Ready to Eat"
    @ObservedObject var classifier: ImageClassifier
    @State private var multiSelection = Set<UUID>()
    
    var body: some View {
        VStack{
            VStack {
                NavigationView {
                    VStack {
                        List(selection: $multiSelection) {
                            ForEach($items)  { $i in
                                ItemView(item: i, selectedItems: $multiSelection)
                            }
                            .onDelete {
                                (indexSet) in
                                items.remove(atOffsets: indexSet)
                            }
                            .listStyle(.inset)
                        }
                        
                    }
                    .navigationTitle("Current Items")
                }
                HStack {
                    TextField(" Manually Add Items", text:$mvText)
                        .padding(5)
//                        .frame(width: 350, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 4)
                        )
                        .padding()
                    VStack {
                        Text("Expires In:")
                        Picker("Time until item expires", selection: $selection) {
                            ForEach(options, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    Button(action: {
                        items.append(TodoItem(id: UUID(), title: mvText, expiresIn: selection, expireDate: setExpirationDate(selected: selection)))
                    }) {
                        Image(systemName: "arrow.up")
//                        Image(systemName: "plus") // Figure which to use
                    }
                    .padding()
                }
                Spacer()
            }
            Spacer()
            HStack {
                Button(action: {
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                    }
                }) {
                    Image(systemName: "camera")
                        .onTapGesture {
                            isPresenting = true
                            sourceType = .camera
                        }
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .padding()
                Button(action: {
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                    }
                }) {
                    Image(systemName: "photo")
                        .onTapGesture {
                            isPresenting = true
                            sourceType = .photoLibrary
                        }
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .padding()
                Spacer()
                VStack {
                    Group {
                        if let imageClass = classifier.imageClass {
                            HStack{
                                Text("Image categories:")
                                    .font(.caption)
                                Text(imageClass)
                                    .bold()
                            }
                        } else {
                            HStack{
                                Text("Image categories: N/A")
                                    .font(.caption)
                            }
                        }
                    }
                    .font(.subheadline)
                    .padding()
                }
                Spacer()
                Button(action: {
                    if let imageClass2 = classifier.imageClass {
                        items.append(TodoItem(id: UUID(), title: imageClass2, expiresIn: selection, expireDate: setExpirationDate(selected: selection)))
                    }
                }) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
                .padding()
            }
        }
        
        .sheet(isPresented: $isPresenting){
            ImagePicker(uiImage: $uiImage, isPresenting:  $isPresenting, sourceType: $sourceType)
                .onDisappear{
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                    }
                }

        }
        .padding()
    }
}

func backgroundColor(expireDate:Date) -> Color {
    //dividing by number of seconds in a day
    let daysTilExpire = Date().distance(to: expireDate)/86400
    switch (daysTilExpire) {
    case 7...14: return .green
    case 3...7: return .orange
    case 14...: return .blue
    default:
        return .red
    }
}

func setExpirationDate(selected: String) -> Date {
    let currDate = Date()
    var dateComp = DateComponents()
    dateComp.month = 0
    dateComp.year = 0
    
    switch (selected) {
    case "Ready to Eat": dateComp.day = 3
    case "1 week": dateComp.day = 7
    case "2 weeks": dateComp.day = 14
    default: dateComp.day = 21
    }
    
    let expiresDate = Calendar.current.date(byAdding: dateComp, to: currDate)
    return expiresDate!
}


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

struct FavoriteView: View {
    @State var showRecipe: Bool = false
    @State var history: [String] = ["Example1", "Example2", "Example3"] // Temp. Take examples out
    @ObservedObject var recipes : Recipes = Recipes()
    @State var madeHist = false

    
    var body: some View {
        NavigationStack {
            Text("Favorite Recipes")
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

struct Views_Previews: PreviewProvider {
    static var previews: some View {
        Views(classifier: ImageClassifier())
//        FavoriteView().environmentObject(Recipes())
    }
}
