import Foundation
import Combine

// 人狼ゲームのメインエンジン
class WerewolfEngine: ObservableObject {
    @Published var gameState: WerewolfGameState
    @Published var messages: [Message] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let aiService: WerewolfAIService
    
    init() {
        self.gameState = WerewolfGameState()
        self.aiService = WerewolfAIService()
    }
    
    // ゲーム開始
    func startGame(with characters: [Character], userCharacter: Character) {
        // 8人でのゲーム設定
        let roles: [WerewolfRole] = [
            .werewolf, .werewolf,     // 人狼2人
            .madman,                  // 狂人1人
            .seer,                    // 占い師1人
            .medium,                  // 霊媒師1人
            .bodyguard,               // 騎士1人
            .villager, .villager      // 村人2人
        ].shuffled()
        
        // プレイヤーの作成
        var players: [WerewolfPlayer] = []
        
        // ユーザープレイヤーを追加
        let userPlayer = WerewolfPlayer(
            id: UUID(),
            character: userCharacter,
            personality: userCharacter.detailedPersonality ?? CharacterPersonality.createGojo(),
            role: roles[0],
            isUser: true
        )
        players.append(userPlayer)
        
        // AIプレイヤーを追加
        for (index, character) in characters.prefix(7).enumerated() {
            let player = WerewolfPlayer(
                id: UUID(),
                character: character,
                personality: character.detailedPersonality ?? CharacterPersonality.createGojo(),
                role: roles[index + 1],
                isUser: false
            )
            players.append(player)
        }
        
        gameState.players = players
        gameState.phase = .firstNight
        gameState.day = 1
        
        // 役職配布メッセージ
        sendSystemMessage("人狼ゲームを開始します！")
        sendSystemMessage("参加者: \(players.map { $0.character.name }.joined(separator: ", "))")
        
        // ユーザーに役職を通知
        sendPrivateMessage("あなたの役職は【\(userPlayer.role.rawValue)】です。", to: userPlayer)
        
        // 人狼同士の認識
        if userPlayer.role == .werewolf {
            let otherWerewolves = gameState.players(withRole: .werewolf).filter { $0.id != userPlayer.id }
            if !otherWerewolves.isEmpty {
                let names = otherWerewolves.map { $0.character.name }.joined(separator: ", ")
                sendPrivateMessage("仲間の人狼は \(names) です。", to: userPlayer)
            }
        }
        
        // 初日夜の処理
        startNightPhase()
    }
    
    // 夜フェーズ開始
    private func startNightPhase() {
        gameState.phase = .nightAction
        gameState.timeOfDay = .night
        gameState.nightActions = NightActions()
        
        sendSystemMessage("\(gameState.day)日目の夜になりました。")
        
        // 役職ごとの夜行動を促す
        let userPlayer = gameState.players.first { $0.isUser }!
        
        switch userPlayer.role {
        case .werewolf:
            promptWerewolfAction()
        case .seer:
            promptSeerAction()
        case .bodyguard:
            promptBodyguardAction()
        default:
            sendSystemMessage("あなたは夜の行動はありません。他のプレイヤーの行動を待ちましょう。")
            // AIの行動を実行
            performAINightActions()
        }
    }
    
    // 人狼の行動促進
    private func promptWerewolfAction() {
        let alivePlayers = gameState.alivePlayers.filter { $0.role != .werewolf }
        sendSystemMessage("誰を襲撃しますか？")
        // TODO: 選択UIの表示
    }
    
    // 占い師の行動促進
    private func promptSeerAction() {
        let alivePlayers = gameState.alivePlayers.filter { !$0.isUser }
        sendSystemMessage("誰を占いますか？")
        // TODO: 選択UIの表示
    }
    
    // 騎士の行動促進
    private func promptBodyguardAction() {
        let alivePlayers = gameState.alivePlayers
        sendSystemMessage("誰を護衛しますか？")
        // TODO: 選択UIの表示
    }
    
    // AIの夜行動
    private func performAINightActions() {
        // AI人狼の襲撃決定
        let aiWerewolves = gameState.players(withRole: .werewolf).filter { !$0.isUser }
        if !aiWerewolves.isEmpty {
            let target = aiService.selectWerewolfTarget(gameState: gameState)
            gameState.nightActions.werewolfTarget = target
        }
        
        // AI占い師の占い
        if let aiSeer = gameState.players(withRole: .seer).first(where: { !$0.isUser }) {
            let target = aiService.selectSeerTarget(gameState: gameState, seer: aiSeer)
            gameState.nightActions.seerTarget = target
        }
        
        // AI騎士の護衛
        if let aiBodyguard = gameState.players(withRole: .bodyguard).first(where: { !$0.isUser }) {
            let target = aiService.selectBodyguardTarget(gameState: gameState, bodyguard: aiBodyguard)
            gameState.nightActions.bodyguardTarget = target
        }
    }
    
    // 昼フェーズ開始
    private func startDayPhase() {
        gameState.phase = .dayDiscussion
        gameState.timeOfDay = .day
        
        sendSystemMessage("\(gameState.day)日目の朝になりました。")
        
        // 夜の結果を処理
        processNightResults()
        
        // 議論開始
        startDiscussion()
    }
    
    // 夜の結果処理
    private func processNightResults() {
        // 襲撃結果
        if let targetId = gameState.nightActions.werewolfTarget {
            let wasProtected = targetId == gameState.nightActions.bodyguardTarget
            
            if !wasProtected {
                if let target = gameState.players.first(where: { $0.id == targetId }) {
                    sendSystemMessage("\(target.character.name)さんが無残な姿で発見されました...")
                    killPlayer(target, reason: .attacked)
                }
            } else {
                sendSystemMessage("昨夜は誰も死にませんでした。")
            }
        }
        
        // 占い結果（占い師にのみ通知）
        if let seerId = gameState.players(withRole: .seer).first?.id,
           let targetId = gameState.nightActions.seerTarget,
           let target = gameState.players.first(where: { $0.id == targetId }) {
            let result: DivinationResultType = target.role == .werewolf ? .werewolf : .human
            if let seer = gameState.players.first(where: { $0.id == seerId && $0.isUser }) {
                sendPrivateMessage("占い結果: \(target.character.name)は\(result == .werewolf ? "人狼" : "人間")です。", to: seer)
            }
        }
    }
    
    // 議論開始
    private func startDiscussion() {
        sendSystemMessage("議論を開始してください。")
        
        // AI プレイヤーの発言を生成
        generateAIDiscussion()
    }
    
    // AIの議論生成
    private func generateAIDiscussion() {
        let aiPlayers = gameState.alivePlayers.filter { !$0.isUser }
        
        for player in aiPlayers {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2...5)) { [weak self] in
                guard let self = self else { return }
                
                let statement = self.aiService.generateStatement(
                    player: player,
                    gameState: self.gameState
                )
                
                self.sendCharacterMessage(statement, from: player.character)
            }
        }
    }
    
    // プレイヤーを殺す
    private func killPlayer(_ player: WerewolfPlayer, reason: PlayerStatus) {
        if let index = gameState.players.firstIndex(where: { $0.id == player.id }) {
            gameState.players[index].status = reason
        }
        
        // ゲーム終了判定
        if let result = gameState.gameResult {
            endGame(result: result)
        }
    }
    
    // ゲーム終了
    private func endGame(result: GameResult) {
        gameState.phase = .gameEnd
        sendSystemMessage(result.description)
        
        // 役職公開
        sendSystemMessage("=== 役職公開 ===")
        for player in gameState.players {
            sendSystemMessage("\(player.character.name): \(player.role.rawValue)")
        }
    }
    
    // メッセージ送信関数
    private func sendSystemMessage(_ content: String) {
        let message = Message(content: "【システム】\(content)", character: nil, isUser: false)
        messages.append(message)
    }
    
    private func sendPrivateMessage(_ content: String, to player: WerewolfPlayer) {
        let message = Message(content: "【あなたへの通知】\(content)", character: nil, isUser: false)
        messages.append(message)
    }
    
    private func sendCharacterMessage(_ content: String, from character: Character) {
        let message = Message(content: content, character: character, isUser: false)
        messages.append(message)
    }
    
    // ユーザーアクション
    func userSendMessage(_ content: String) {
        if let userPlayer = gameState.players.first(where: { $0.isUser }) {
            let message = Message(content: content, character: userPlayer.character, isUser: true)
            messages.append(message)
            
            // フェーズに応じた処理
            switch gameState.phase {
            case .dayDiscussion:
                // AIの反応を生成
                generateAIResponse(to: content, from: userPlayer)
            default:
                break
            }
        }
    }
    
    // AIの反応生成
    private func generateAIResponse(to message: String, from sender: WerewolfPlayer) {
        let aiPlayers = gameState.alivePlayers.filter { !$0.isUser }
        
        // ランダムに1-2人のAIが反応
        let respondingPlayers = aiPlayers.shuffled().prefix(Int.random(in: 1...2))
        
        for player in respondingPlayers {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...3)) { [weak self] in
                guard let self = self else { return }
                
                let response = self.aiService.generateResponse(
                    player: player,
                    toMessage: message,
                    from: sender,
                    gameState: self.gameState
                )
                
                self.sendCharacterMessage(response, from: player.character)
            }
        }
    }
}