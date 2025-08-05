import SwiftUI

struct CharacterView: View {
    @State private var searchText = ""
    @State private var selectedCharacter: Character?
    @State private var selectedCategory = "全て"
    
    let categories = ["全て", "人気", "新規", "カスタム"]
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
            VStack(spacing: 0) {
                // カテゴリタブ
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(categories, id: \.self) { category in
                            CategoryTab(
                                title: category,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color(.systemBackground))
                
                // キャラクターリスト
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredCharacters) { character in
                            CharacterListRow(character: character) {
                                selectedCharacter = character
                            }
                            
                            Divider()
                                .padding(.leading, 88)
                        }
                        
                        // カスタムキャラクター追加ボタン
                        AddCharacterRow()
                            .padding(.top, 8)
                    }
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("キャラクター")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "キャラクターを検索")
            .sheet(item: $selectedCharacter) { character in
                CharacterDetailView(character: character)
            }
        }
    }
}

struct CategoryTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .primary : .secondary)
                
                Rectangle()
                    .fill(isSelected ? Color.green : Color.clear)
                    .frame(height: 2)
            }
        }
    }
}

struct CharacterListRow: View {
    let character: Character
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // キャラクターアイコン
                ZStack {
                    Circle()
                        .fill(character.color.opacity(0.2))
                        .frame(width: 64, height: 64)
                    
                    Circle()
                        .fill(character.color)
                        .frame(width: 56, height: 56)
                    
                    Text(character.emoji)
                        .font(.system(size: 32))
                }
                
                // キャラクター情報
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(character.name)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        // 人気度インジケーター
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < character.rating ? "star.fill" : "star")
                                    .font(.system(size: 10))
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    
                    Text(character.personality)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    // タグ
                    HStack(spacing: 6) {
                        ForEach(character.tags.prefix(2), id: \.self) { tag in
                            CharacterTag(text: tag.rawValue, color: tag.color)
                        }
                    }
                }
                
                Spacer()
                
                // 矢印アイコン
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.tertiaryLabel)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CharacterTag: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .cornerRadius(10)
    }
}

struct AddCharacterRow: View {
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("カスタムキャラクターを追加")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text("あなたの好きなキャラクターでプレイ")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.tertiaryLabel)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
}