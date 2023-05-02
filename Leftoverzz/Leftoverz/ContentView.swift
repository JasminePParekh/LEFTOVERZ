import SwiftUI


struct ContentView: View {
    @EnvironmentObject var searchObj: SearchObject
    @EnvironmentObject var rm: ResourcesModel
    
    
    var body: some View {
        TabView {
            Views(classifier: ImageClassifier()).tabItem {
                Label("Fridge", systemImage: "home")
            }
            RecipeSearchView().tabItem {
                Label("Recipe Search", systemImage: "magnifyingglass")
            }
            FavoritesView().tabItem {
                Label("Favorite", systemImage: "heart")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SearchObject()).environmentObject(ResourcesModel())
    }
}
