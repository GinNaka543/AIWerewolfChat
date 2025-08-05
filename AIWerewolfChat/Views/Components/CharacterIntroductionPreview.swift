import SwiftUI

// カスタムシェイプ（上部のみ角丸）
struct TopRoundedRectangle: Shape {
    var cornerRadius: CGFloat = 12
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 左上の角丸から開始
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        
        // 上辺
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        
        // 右上の角丸
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        
        // 右辺
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        // 下辺（角丸なし）
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // 左辺
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        
        return path
    }
}

struct CharacterIntroductionPreview: View {
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // プレビューがタップされた時のアクション
        }) {
            ZStack {
            // カスタムシェイプ（上部のみ角丸）
            TopRoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            VStack(spacing: 0) {
                // サンプル画像エリア
                ZStack {
                    // プレースホルダー背景画像
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(height: 180)
                        .clipped()
                    
                    // グラデーションオーバーレイ
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.0),
                            Color.black.opacity(0.0),
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.7)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    // テキストコンテンツ
                    VStack {
                        Spacer()
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("キャラクター紹介")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("AIと楽しむ人狼ゲーム - 個性豊かなキャラクターたち")
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.8))
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
                .frame(height: 180)
                .clipped()
            }
        }
        }
        .frame(height: 180)
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onLongPressGesture(minimumDuration: 0.1, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }) {
            // タップ完了時
        }
    }
}