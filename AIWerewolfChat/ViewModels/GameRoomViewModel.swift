import SwiftUI
import Combine

class GameRoomViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var gameState: GameState = .waiting
    
    private var gameType: GameType?
    private var participants: [Character] = []
    private var werewolfEngine: WerewolfEngine?
    private var cancellables = Set<AnyCancellable>()
    
    enum GameState {
        case waiting
        case playing
        case ended
    }
    
    func startGame(type: GameType) {
        self.gameType = type
        self.gameState = .playing
        
        switch type {
        case .werewolf:
            startWerewolfGame()
        case .sanRentan:
            startSanRentanGame()
        case .ito:
            startItoGame()
        }
    }
    
    private func startWerewolfGame() {
        // 人狼エンジンを初期化
        werewolfEngine = WerewolfEngine()
        
        // エンジンのメッセージを購読
        werewolfEngine?.$messages
            .sink { [weak self] messages in
                self?.messages = messages
            }
            .store(in: &cancellables)
        
        // キャラクターを選択（デモ用にランダム選択）
        let allCharacters = Character.sampleCharacters
        let selectedCharacters = Array(allCharacters.shuffled().prefix(7))
        let userCharacter = allCharacters.randomElement()!
        
        // ゲーム開始
        werewolfEngine?.startGame(with: selectedCharacters, userCharacter: userCharacter)
    }
    
    private func startSanRentanGame() {
        // サンレンタンゲーム開始のメッセージ
        let systemMessage = Message(
            content: "サンレンタンゲームを開始します！\n順番に言葉をつないでいきましょう。",
            character: nil,
            isUser: false
        )
        messages.append(systemMessage)
        
        // TODO: サンレンタンゲームの実装
    }
    
    private func startItoGame() {
        // itoゲーム開始のメッセージ
        let systemMessage = Message(
            content: "itoゲームを開始します！\n数字を当てずに順番を当てましょう。",
            character: nil,
            isUser: false
        )
        messages.append(systemMessage)
        
        // TODO: itoゲームの実装
    }
    
    func sendMessage(_ text: String) {
        if gameType == .werewolf, let engine = werewolfEngine {
            // 人狼ゲームの場合はエンジンに委譲
            engine.userSendMessage(text)
        } else {
            // その他のゲームの場合は従来の処理
            let userMessage = Message(content: text, isUser: true)
            messages.append(userMessage)
            simulateAIResponse(to: text)
        }
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