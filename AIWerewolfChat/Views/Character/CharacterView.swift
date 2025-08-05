import SwiftUI

struct CharacterView: View {
    @State private var selectedCharacter: Character?
    
    let characters = Character.sampleCharacters
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 上部のヘッダー
                    HStack {
                        // ハンバーガーメニュー
                        Button(action: {}) {
                            VStack(spacing: 4) {
                                ForEach(0..<3) { _ in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.black)
                                        .frame(width: 30, height: 3)
                                }
                            }
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        // Add Characterボタン
                        Button(action: {}) {
                            Text("Add Character")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.purple)
                                .cornerRadius(25)
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                    // キャラクターリスト
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(characters) { character in
                                CharacterRow(character: character) {
                                    selectedCharacter = character
                                }
                                
                                if character.id != characters.last?.id {
                                    Divider()
                                        .padding(.leading, 90)
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
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
    
    // 仮の日付データ（実際はキャラクターごとに設定）
    var dateText: String {
        let dates = ["Jun 5", "Mar 9", "Jun 17", "Sep 26", "Jul 29", "Dec 22", "Aug 23"]
        let index = abs(character.name.hashValue) % dates.count
        return dates[index]
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // キャラクターアイコン
                ZStack {
                    // 外側の円（グラデーション風）
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    character.color.opacity(0.3),
                                    character.color.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    // 内側の円
                    Circle()
                        .fill(character.color.opacity(0.8))
                        .frame(width: 50, height: 50)
                    
                    // キャラクターアイコン（将来的にはImageに置き換え）
                    Text(character.emoji)
                        .font(.system(size: 28))
                }
                .padding(.leading, 16)
                
                // キャラクター情報
                VStack(alignment: .leading, spacing: 2) {
                    Text(character.name)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.black)
                    
                    Text("#\(character.personality)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 日付
                Text(dateText)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.trailing, 16)
            }
            .padding(.vertical, 12)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
}