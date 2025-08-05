import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // キャラクターアイコン
                    ZStack {
                        Circle()
                            .fill(character.color)
                            .frame(width: 120, height: 120)
                        
                        Text(character.emoji)
                            .font(.system(size: 60))
                    }
                    .padding(.top)
                    
                    // キャラクター名
                    Text(character.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // 性格
                    VStack(alignment: .leading, spacing: 12) {
                        DetailSection(title: "性格", content: character.personality)
                        DetailSection(title: "話し方", content: character.speechStyle)
                        DetailSection(title: "説明", content: character.description)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("口癖")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            ForEach(character.catchPhrases, id: \.self) { phrase in
                                HStack {
                                    Image(systemName: "quote.bubble.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text(phrase)
                                        .font(.body)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("キャラクター詳細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DetailSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(content)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}