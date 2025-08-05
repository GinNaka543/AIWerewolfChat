import SwiftUI

struct CharacterView: View {
    @State private var searchText = ""
    @State private var selectedCharacter: Character?
    
    let characters = Character.sampleCharacters
    
    var filteredCharacters: [Character] {
        if searchText.isEmpty {
            return characters
        } else {
            return characters.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) 
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(filteredCharacters) { character in
                        CharacterCard(character: character) {
                            selectedCharacter = character
                        }
                    }
                    
                    AddCharacterCard()
                }
                .padding()
            }
            .navigationTitle("キャラクター")
            .searchable(text: $searchText, prompt: "キャラクターを検索")
            .sheet(item: $selectedCharacter) { character in
                CharacterDetailView(character: character)
            }
        }
    }
}

struct CharacterCard: View {
    let character: Character
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(character.color)
                        .frame(width: 80, height: 80)
                    
                    Text(character.emoji)
                        .font(.system(size: 40))
                }
                
                Text(character.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(character.personality)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

struct AddCharacterCard: View {
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                        .foregroundColor(.secondary)
                }
                
                Text("追加")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("カスタム")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}