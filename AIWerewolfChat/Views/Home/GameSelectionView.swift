import SwiftUI

struct GameSelectionView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("ゲーム選択画面")
                    .font(.title)
                    .padding()
                
                Text("この画面はゲームロビーから遷移します")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("ゲーム選択")
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