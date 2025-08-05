import SwiftUI
import Combine

class GameRoomViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var gameState: GameState = .waiting
    
    private var gameType: GameType?
    private var participants: [Character] = []
    
    enum GameState {
        case waiting
        case playing
        case ended
    }
    
    func startGame(type: GameType) {
        self.gameType = type
        
        // ゲーム開始のメッセージ
        let systemMessage = Message(
            content: "ゲームを開始します！\n\(type.title)のルールに従って進行します。",
            character: nil,
            isUser: false
        )
        messages.append(systemMessage)
        
        // デモ用の初期メッセージ
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let welcomeMessage = Message(
                content: "みなさん、よろしくお願いします！",
                character: Character.sampleCharacters[0],
                isUser: false
            )
            self.messages.append(welcomeMessage)
        }
    }
    
    func sendMessage(_ text: String) {
        // ユーザーのメッセージを追加
        let userMessage = Message(content: text, isUser: true)
        messages.append(userMessage)
        
        // デモ用のAI応答
        simulateAIResponse(to: text)
    }
    
    private func simulateAIResponse(to userMessage: String) {
        // デモ用：ランダムなキャラクターから返信
        let randomCharacter = Character.sampleCharacters.randomElement()!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let response = self.generateResponse(
                for: randomCharacter,
                to: userMessage
            )
            
            let aiMessage = Message(
                content: response,
                character: randomCharacter,
                isUser: false
            )
            self.messages.append(aiMessage)
        }
    }
    
    private func generateResponse(for character: Character, to message: String) -> String {
        // デモ用の簡単な応答生成
        switch character.name {
        case "五条悟":
            return "そうだね〜、\(message)って感じかな。僕、最強だから大丈夫だよ！"
        case "優しいお姉さん":
            return "そうね、\(message)って素敵な考えだと思うわ。大丈夫よ。"
        case "元気な後輩":
            return "先輩！\(message)ですね！やったー！頑張ります！"
        default:
            return "なるほど、\(message)ということですね。"
        }
    }
}