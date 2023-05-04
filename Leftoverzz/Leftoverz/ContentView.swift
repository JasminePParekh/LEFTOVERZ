import SwiftUI


struct ContentView: View {
    @EnvironmentObject var searchObj: SearchObject
    @EnvironmentObject var rm: ResourcesModel
    @State private var tabSelection = 1
    @State var itemsToSearch: [String] = []
    
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Views(classifier: ImageClassifier(), itemsToSearch: $itemsToSearch, tabSelection: $tabSelection)
                .tabItem {
                    Label("Fridge", systemImage: "cabinet")
                }
                .tag(1)
            RecipeSearchView(itemsToSearch: $itemsToSearch)
                .tabItem {
                    Label("Recipe Search", systemImage: "magnifyingglass")
                }
                .tag(2)
            FavoritesView()
                .tabItem {
                    Label("Favorite", systemImage: "heart")
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SearchObject()).environmentObject(ResourcesModel())
    }
}
