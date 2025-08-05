import SwiftUI

struct GameLobbyView: View {
    @State private var selectedGame: GameType?
    @State private var showGameRoom = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if selectedGame == nil {
                    GameTypeSelectionView(selectedGame: $selectedGame)
                } else {
                    GroupSelectionView(
                        gameType: selectedGame!,
                        onStartGame: {
                            showGameRoom = true
                        }
                    )
                }
            }
            .navigationTitle("ゲーム")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if selectedGame != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("戻る") {
                            selectedGame = nil
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showGameRoom) {
                if let game = selectedGame {
                    GameRoomView(gameType: game)
                }
            }
        }
    }
}

struct GameTypeSelectionView: View {
    @Binding var selectedGame: GameType?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ゲームを選択")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            ForEach(GameType.allCases) { game in
                Button(action: {
                    selectedGame = game
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(game.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(game.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                            
                            HStack {
                                Image(systemName: "person.2.fill")
                                Text("\(game.minPlayers)〜\(game.maxPlayers)人")
                                    .font(.caption2)
                                
                                Image(systemName: "clock.fill")
                                Text("\(game.estimatedTime)分")
                                    .font(.caption2)
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

struct GroupSelectionView: View {
    let gameType: GameType
    let onStartGame: () -> Void
    @State private var selectedCharacters: Set<Character> = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("参加メンバーを選択")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("\(gameType.minPlayers)〜\(gameType.maxPlayers)人を選択してください")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(Character.sampleCharacters) { character in
                        CharacterSelectionCard(
                            character: character,
                            isSelected: selectedCharacters.contains(character)
                        ) {
                            if selectedCharacters.contains(character) {
                                selectedCharacters.remove(character)
                            } else if selectedCharacters.count < gameType.maxPlayers {
                                selectedCharacters.insert(character)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Button(action: onStartGame) {
                Text("ゲーム開始")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        selectedCharacters.count >= gameType.minPlayers
                            ? Color.green
                            : Color.gray
                    )
                    .cornerRadius(12)
            }
            .disabled(selectedCharacters.count < gameType.minPlayers)
            .padding()
        }
    }
}

struct CharacterSelectionCard: View {
    let character: Character
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? character.color : Color(.systemGray5))
                        .frame(width: 60, height: 60)
                    
                    if isSelected {
                        Circle()
                            .stroke(Color.green, lineWidth: 3)
                            .frame(width: 64, height: 64)
                    }
                    
                    Text(character.emoji)
                        .font(.system(size: 30))
                }
                
                Text(character.name)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
    }
}