import SwiftUI

struct CharacterView: View {
    @State private var selectedCharacter: Character?
    
    let characters = Character.sampleCharacters
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 真っ白な背景
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 上部のヘッダー
                    HStack {
                        // ハンバーガーメニュー
                        Button(action: {}) {
                            VStack(spacing: 3) {
                                ForEach(0..<3) { _ in
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: 24, height: 2.5)
                                }
                            }
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        // Add Characterボタン
                        Button(action: {}) {
                            Text("Add Character")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color(red: 0.6, green: 0.4, blue: 0.8))
                                .cornerRadius(20)
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    .background(Color.white)
                    
                    // キャラクター紹介プレビュー
                    CharacterIntroductionPreview()
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    
                    // キャラクターリスト（線なし、連続したリスト）
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(characters) { character in
                                CharacterRow(character: character) {
                                    selectedCharacter = character
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedCharacter) { character in
                CharacterDetailView(character: character)
            }
        }
    }
}

struct CharacterRow: View {
    let character: Character
    let action: () -> Void
    
    // 仮の日付データ
    var dateText: String {
        let dates = ["Jun 5", "Mar 9", "Jun 17", "Sep 26", "Jul 29", "Dec 22", "Aug 23"]
        let index = abs(character.name.hashValue) % dates.count
        return dates[index]
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // キャラクターアイコン（小さめ）
                AnimeCharacterIcon(character: character, size: 44)
                    .padding(.leading, 16)
                
                // キャラクター情報
                VStack(alignment: .leading, spacing: 2) {
                    Text(character.name)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                    
                    Text("#\(character.personality)")
                        .font(.system(size: 13))
                        .foregroundColor(Color(white: 0.6))
                }
                
                Spacer()
                
                // 日付
                Text(dateText)
                    .font(.system(size: 13))
                    .foregroundColor(Color(white: 0.6))
                    .padding(.trailing, 16)
            }
            .padding(.vertical, 12)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
}