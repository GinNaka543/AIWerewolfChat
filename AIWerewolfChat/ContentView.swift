import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .font(.system(size: 22))
                        Text("Home")
                            .font(.system(size: 10))
                    }
                }
                .tag(0)
            
            CharacterView()
                .tabItem {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == 1 ? "person.2.fill" : "person.2")
                            .font(.system(size: 22))
                        Text("Character")
                            .font(.system(size: 10))
                    }
                }
                .tag(1)
            
            GameLobbyView()
                .tabItem {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == 2 ? "gamecontroller.fill" : "gamecontroller")
                            .font(.system(size: 22))
                        Text("Game")
                            .font(.system(size: 10))
                    }
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}