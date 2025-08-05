import SwiftUI

struct HomeView: View {
    @State private var showGameSelection = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("AI人狼チャット")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Text("1人でも楽しめるAIパーティーゲーム")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(spacing: 16) {
                    GameCard(
                        title: "人狼ゲーム",
                        description: "村人と人狼の心理戦",
                        icon: "moon.fill",
                        color: .purple
                    ) {
                        showGameSelection = true
                    }
                    
                    GameCard(
                        title: "サンレンタン",
                        description: "価値観を当てるゲーム",
                        icon: "list.number",
                        color: .orange
                    ) {
                        showGameSelection = true
                    }
                    
                    GameCard(
                        title: "ito（イト）",
                        description: "数字を言葉で表現",
                        icon: "textformat.123",
                        color: .blue
                    ) {
                        showGameSelection = true
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("ホーム")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showGameSelection) {
                GameSelectionView()
            }
        }
    }
}

struct GameCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
    }
}