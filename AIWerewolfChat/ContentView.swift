import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            CharacterView()
                .tabItem {
                    Label("Character", systemImage: "person.2")
                }
                .tag(1)
            
            GameLobbyView()
                .tabItem {
                    Label("Game", systemImage: "gamecontroller")
                }
                .tag(2)
        }
        .accentColor(.blue)
        .onAppear {
            // TabBarの背景を白に設定
            let appearance = UITabBar.appearance()
            appearance.backgroundColor = .white
            appearance.barTintColor = .white
        }
    }
}