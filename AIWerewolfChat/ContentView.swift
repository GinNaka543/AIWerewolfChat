import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("ホーム", systemImage: "house.fill")
                }
                .tag(0)
            
            CharacterView()
                .tabItem {
                    Label("キャラ", systemImage: "person.3.fill")
                }
                .tag(1)
            
            GameLobbyView()
                .tabItem {
                    Label("ゲーム", systemImage: "gamecontroller.fill")
                }
                .tag(2)
        }
        .accentColor(.green)
    }
}