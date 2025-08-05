import SwiftUI

struct AnimeCharacterIcon: View {
    let character: Character
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // アニメキャラクター風の背景グラデーション
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: character.color.opacity(0.8), location: 0.0),
                            .init(color: character.color.opacity(0.6), location: 0.5),
                            .init(color: character.color.opacity(0.4), location: 1.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
            
            // 内側の円（光沢効果）
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.0)
                        ]),
                        center: .init(x: 0.3, y: 0.3),
                        startRadius: 0,
                        endRadius: size * 0.5
                    )
                )
                .frame(width: size * 0.9, height: size * 0.9)
            
            // キャラクターの絵文字（将来的には画像に置き換え）
            Text(character.emoji)
                .font(.system(size: size * 0.5))
            
            // 外枠
            Circle()
                .stroke(character.color.opacity(0.3), lineWidth: 1)
                .frame(width: size, height: size)
        }
    }
}