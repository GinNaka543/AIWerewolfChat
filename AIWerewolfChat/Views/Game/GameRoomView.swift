import SwiftUI

struct GameRoomView: View {
    let gameType: GameType
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = GameRoomViewModel()
    
    var body: some View {
        NavigationStack {
            ChatView(messages: viewModel.messages, onSendMessage: viewModel.sendMessage)
                .navigationTitle(gameType.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("終了") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                        }
                    }
                }
        }
        .onAppear {
            viewModel.startGame(type: gameType)
        }
    }
}