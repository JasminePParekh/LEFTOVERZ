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
            TextField("Title", text: $item.title).foregroundColor(backgroundColor(selected: item.expiresIn))
            
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

struct ManualView: View {
    @Binding var items: [TodoItem]
    @State var mvText: String = ""
    @State private var selection = "Ready to Eat"
    let options = ["Ready to Eat", "1 week", "2 weeks", "3 weeks"]
    
    var body: some View {
        VStack {
            HStack {
                TextField(" Manually Add Items", text:$mvText)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 4)
                    )
                    .padding()
                Button(action: {
                    items.append(TodoItem(id: UUID(), title: mvText, expiresIn: selection, expireDate: setExpirationDate(selected: selection)))
                }) {
                    Image(systemName: "arrow.up")
                }
                .padding()
            }
        }
    }
}


struct PictureView: View {
    @Binding var isPresenting: Bool
    @Binding var uiImage: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType
    @ObservedObject var classifier: ImageClassifier
    @Binding var items: [TodoItem]
    @State private var selection = "Ready to Eat"
    
    var body: some View {
        HStack {
            Button(action: {
                print("CAMERA TAPPED")
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
                Image(systemName: "arrow.up")
            }
            .padding()
        }
    }
}

struct LibraryView: View {
    @Binding var isPresenting: Bool
    @Binding var uiImage: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType
    @ObservedObject var classifier: ImageClassifier
    @Binding var items: [TodoItem]
    @State private var selection = "Ready to Eat"
    
    var body: some View {
        HStack {
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
//                Image(systemName: "checkmark")
//                    .foregroundColor(.green)
                Image(systemName: "arrow.up")
            }
            .padding()
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
    @State private var selectedItems = Set<UUID>()
    @Binding var itemsToSearch: [String]
    @State var entryType: String = "manual"
    @Binding var tabSelection: Int
//    @Binding var searchItems: [String]
    
    func prepItems() {
        itemsToSearch = []
        for i in selectedItems {
            for j in items {
                if i == j.id {
                    print("Selected", j.title)
                    for k in j.title.split(separator: ", ") {
                        itemsToSearch.append(String(k))
                    }
                }
            }
        }
        print(itemsToSearch)
    }
    
    var body: some View {
        VStack{
            VStack {
                HStack {
                    Spacer()
                    Button(action:{
                        prepItems()
                        self.tabSelection = 2
                    }){
                        Text("Add Selected to Search")
                    }
                }
                NavigationView {
                    VStack {
                        List(selection: $selectedItems) {
                            ForEach($items)  { $i in
                                ItemView(item: i, selectedItems: $selectedItems)
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
                    VStack {
//                        Text("Expires In:")
                        Picker("Time until item expires", selection: $selection) {
                            ForEach(options, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    Spacer()
                    Picker(selection: $entryType, label: Text("Entry Type:")) {
                        Text("Manual").tag("manual")
                        Text("Picture").tag("picture")
                        Text("Photo Library").tag("library")
                    }
                }
                if entryType == "manual" {
                    ManualView(items: $items)
                } else if entryType == "picture" {
                    PictureView(isPresenting: $isPresenting, uiImage: $uiImage, sourceType: $sourceType, classifier: classifier, items: $items)
                } else {
                    LibraryView(isPresenting: $isPresenting, uiImage: $uiImage, sourceType: $sourceType, classifier: classifier, items: $items)
                }
            }
            Spacer()
            
        }
        .sheet(isPresented: $isPresenting){
            ImagePicker(uiImage: $uiImage, isPresenting: $isPresenting, sourceType: $sourceType)
                .onDisappear{
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                    }
                }

        }
        .padding()
    }
}

func backgroundColor(selected: String) -> Color {
    var expireDate = setExpirationDate(selected: selected)
    
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

struct RecipeSearchView: View {
    @EnvironmentObject var searchObj: SearchObject
    @EnvironmentObject var rm: ResourcesModel
    @State var showRecipeDetails = false
    @State var ingredients = ""
    @State var recipeNumber = 0
    @Binding var itemsToSearch: [String]
    
    func entryUpdate() {
        var str:String = ""
        if itemsToSearch.count > 0 {
            for i in 0..<itemsToSearch.count-1 {
                str += itemsToSearch[i] + ", "
            }
            ingredients = str + itemsToSearch[itemsToSearch.count-1]
        }
    }
    
    var body: some View {
        VStack {
            Text("Search Manually for a Recipe?")
            HStack{
                if itemsToSearch.count == 0 {
                    TextField("Seperate Ingredients with ', '", text: $ingredients)
                } else {
                    TextField("Seperate Ingredients with ', '", text: $ingredients)
                }
                Button(action: {
                    searchObj.recipes = [RecipeView]()
                    searchObj.getUrl(request: ingredients)}){
                    Text("Go!")
                }
            }
            if searchObj.recipes.count != 0 {
                List(0...searchObj.recipes.count-1,id:\.self) {
                    i in searchObj.recipes[i].onTapGesture{
                        showRecipeDetails = true
                        recipeNumber = i
                    }
                }
            }
        }
        .sheet(isPresented: $showRecipeDetails) {
            let currRecipe = searchObj.recipes[recipeNumber].recipe
            VStack{
                AsyncImage(
                    url: URL(string: currRecipe.imageUrl),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                HStack {
                    Text(currRecipe.name)
                    Image(systemName: rm.favoriteRecipes.contains(currRecipe) ? "heart.fill" : "heart")
                        .foregroundColor(Color.red)
                        .onTapGesture {
                            rm.toggleFav(recipe: currRecipe)
                        }
                }
                if currRecipe.ingredients.count != 0 {
                    List(0...currRecipe.ingredients.count-1,id:\.self) {
                        i in Text(currRecipe.ingredients[i])
                    }
                }
                Link("View Recipe from Source", destination: URL(string: currRecipe.sourceUrl)!)
            }
        }
        .onAppear {
            entryUpdate()
        }
    }
}

struct RecipeView: View {
    @EnvironmentObject var rm: ResourcesModel
    
    var recipe = Recipe(name: "", imageUrl: "", sourceUrl: "", ingredients: [], isLiked: false)
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        HStack{
            AsyncImage(
                url: URL(string: recipe.imageUrl),
                content: { image in
                    image.resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 100, maxHeight: 100)
                },
                placeholder: {
                    ProgressView()
                }
            )
            Text(recipe.name)
            Spacer()
            Image(systemName: rm.favoriteRecipes.contains(recipe) ? "heart.fill" : "heart")
                .foregroundColor(Color.red)
                .onTapGesture {
                    rm.toggleFav(recipe: recipe)
                }
        }
    }
}

struct FavoritesView: View {
    @EnvironmentObject var rm: ResourcesModel
    @EnvironmentObject var searchObj: SearchObject
    
    @State var showRecipeDetails = false
    @State var favoriteRecipeViews = [RecipeView]()
    @State var recipeNumber = 0
    
    func addView(){
        var views = [RecipeView]()
        print("IN HERE HOERS")
        for recipe in rm.favoriteRecipes{
            print("Hello ")
            views.append(RecipeView(recipe: recipe))
        }
        favoriteRecipeViews = views
        print(rm.favoriteRecipes)
        print(favoriteRecipeViews)
    }
    var body: some View {
        VStack {
            Text("Your Saved Favorites")
            if favoriteRecipeViews.count != 0 {
                List(0...favoriteRecipeViews.count-1,id:\.self) {
                    i in favoriteRecipeViews[i].onTapGesture{
                        showRecipeDetails = true
                        recipeNumber = i
                    }
                }
            }
        }
        .onAppear{addView()}
        .sheet(isPresented: $showRecipeDetails) {
            let currRecipe = favoriteRecipeViews[recipeNumber].recipe
            VStack{
                AsyncImage(
                    url: URL(string: currRecipe.imageUrl),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                HStack {
                    Text(currRecipe.name)
                    Image(systemName: rm.favoriteRecipes.contains(currRecipe) ? "heart.fill" : "heart")
                        .foregroundColor(Color.red)
                        .onTapGesture {
                            rm.toggleFav(recipe: currRecipe)
                        }
                }
                if currRecipe.ingredients.count != 0 {
                    List(0...currRecipe.ingredients.count-1,id:\.self) {
                        i in Text(currRecipe.ingredients[i])
                    }
                }
                Link("View Recipe from Source", destination: URL(string: currRecipe.sourceUrl)!)
            }
        }
    }
}
