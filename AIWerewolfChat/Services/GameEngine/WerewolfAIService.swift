import Foundation

// 人狼ゲームのAI行動を管理するサービス
class WerewolfAIService {
    
    // 人狼の襲撃対象を選択
    func selectWerewolfTarget(gameState: WerewolfGameState) -> UUID? {
        let potentialTargets = gameState.alivePlayers.filter { player in
            player.role != .werewolf
        }
        
        // 優先度計算
        let targetScores = potentialTargets.map { player -> (player: WerewolfPlayer, score: Int) in
            var score = 0
            
            // 役職者を優先的に狙う
            switch player.role {
            case .seer:
                score += 100  // 占い師は最優先
            case .bodyguard:
                score += 80   // 騎士も高優先
            case .medium:
                score += 60   // 霊媒師も重要
            default:
                score += 20
            }
            
            // カミングアウトしている人を狙う
            if !player.claimHistory.isEmpty {
                score += 50
            }
            
            // 疑われていない人を狙う（村人視点で白い人）
            let suspicionCount = gameState.players.flatMap { $0.suspicionHistory }
                .filter { $0.suspect == player.id }.count
            score -= suspicionCount * 10
            
            return (player, score)
        }
        
        // 最高スコアのターゲットを選択（ランダム性も加味）
        let maxScore = targetScores.map { $0.score }.max() ?? 0
        let topTargets = targetScores.filter { $0.score >= maxScore - 20 }
        
        return topTargets.randomElement()?.player.id
    }
    
    // 占い師の占い対象を選択
    func selectSeerTarget(gameState: WerewolfGameState, seer: WerewolfPlayer) -> UUID? {
        let potentialTargets = gameState.alivePlayers.filter { player in
            player.id != seer.id && !hasBeenDivined(player: player, by: seer)
        }
        
        // 優先度計算
        let targetScores = potentialTargets.map { player -> (player: WerewolfPlayer, score: Int) in
            var score = 0
            
            // 疑わしい人を占う
            let suspicionCount = seer.suspicionHistory.filter { $0.suspect == player.id }.count
            score += suspicionCount * 30
            
            // 発言が少ない人
            // TODO: 発言カウントの実装
            
            // カミングアウトしている人は占わない（既に役職が分かっているため）
            if !player.claimHistory.isEmpty {
                score -= 50
            }
            
            return (player, score)
        }
        
        let maxScore = targetScores.map { $0.score }.max() ?? 0
        let topTargets = targetScores.filter { $0.score >= maxScore - 10 }
        
        return topTargets.randomElement()?.player.id
    }
    
    // 騎士の護衛対象を選択
    func selectBodyguardTarget(gameState: WerewolfGameState, bodyguard: WerewolfPlayer) -> UUID? {
        let potentialTargets = gameState.alivePlayers
        
        // 優先度計算
        let targetScores = potentialTargets.map { player -> (player: WerewolfPlayer, score: Int) in
            var score = 0
            
            // 自分は守らない（通常）
            if player.id == bodyguard.id {
                score -= 100
            }
            
            // 占い師COしている人を優先的に守る
            if player.claimHistory.contains(where: { $0.claimedRole == .seer }) {
                score += 80
            }
            
            // 霊媒師COしている人も守る
            if player.claimHistory.contains(where: { $0.claimedRole == .medium }) {
                score += 60
            }
            
            // 白確定（占い結果が人間）の人
            // TODO: 占い結果の追跡
            
            return (player, score)
        }
        
        let maxScore = targetScores.map { $0.score }.max() ?? 0
        let topTargets = targetScores.filter { $0.score >= maxScore - 10 }
        
        return topTargets.randomElement()?.player.id
    }
    
    // AIプレイヤーの発言生成
    func generateStatement(player: WerewolfPlayer, gameState: WerewolfGameState) -> String {
        let personality = player.personality
        let role = player.role
        
        // 基本的な発言パターン
        var statementOptions: [String] = []
        
        // 役職に応じた発言
        switch role {
        case .werewolf:
            // 村人のふりをする
            statementOptions.append(contentsOf: generateVillagerStatement(player: player, gameState: gameState))
            
        case .seer:
            // 占い結果を共有するか検討
            if shouldClaimRole(player: player, gameState: gameState) {
                statementOptions.append(generateSeerClaim(player: player, gameState: gameState))
            } else {
                statementOptions.append(contentsOf: generateVillagerStatement(player: player, gameState: gameState))
            }
            
        case .madman:
            // 占い師を騙るか検討
            if shouldFakeClaim(player: player, gameState: gameState) {
                statementOptions.append(generateFakeSeerClaim(player: player, gameState: gameState))
            } else {
                statementOptions.append(contentsOf: generateVillagerStatement(player: player, gameState: gameState))
            }
            
        default:
            statementOptions.append(contentsOf: generateVillagerStatement(player: player, gameState: gameState))
        }
        
        // キャラクターの性格に応じて発言を調整
        let statement = statementOptions.randomElement() ?? "うーん、難しいね..."
        return applyPersonality(statement: statement, personality: personality)
    }
    
    // 村人としての発言生成
    private func generateVillagerStatement(player: WerewolfPlayer, gameState: WerewolfGameState) -> [String] {
        var statements: [String] = []
        
        // 誰かを疑う
        if let suspiciousPlayer = findSuspiciousPlayer(from: player.id, gameState: gameState) {
            statements.append("\(suspiciousPlayer.character.name)が少し怪しいと思うんだけど...")
        }
        
        // 情報整理
        statements.append("今までの情報を整理すると...")
        
        // 自己弁護
        if isBeingSuspected(player: player, gameState: gameState) {
            statements.append("私は村人です。信じてください。")
        }
        
        return statements
    }
    
    // 占い師のカミングアウト
    private func generateSeerClaim(player: WerewolfPlayer, gameState: WerewolfGameState) -> String {
        return "私は占い師です。占い結果を報告します。"
    }
    
    // 偽占い師のカミングアウト
    private func generateFakeSeerClaim(player: WerewolfPlayer, gameState: WerewolfGameState) -> String {
        return "実は私が本物の占い師です。"
    }
    
    // メッセージへの返答生成
    func generateResponse(player: WerewolfPlayer, toMessage: String, from: WerewolfPlayer, gameState: WerewolfGameState) -> String {
        let personality = player.personality
        
        // メッセージの内容を分析
        let isSuspected = toMessage.contains(player.character.name) && 
                         (toMessage.contains("怪しい") || toMessage.contains("人狼") || toMessage.contains("黒"))
        
        let isQuestioned = toMessage.contains("？") || toMessage.contains("どう思")
        
        var response = ""
        
        if isSuspected {
            // 疑われた時の反応
            response = personality.whenSuspected.randomElement() ?? "違うよ..."
        } else if isQuestioned {
            // 質問された時の反応
            response = generateOpinion(player: player, about: from, gameState: gameState)
        } else {
            // 通常の反応
            response = generateGeneralResponse(player: player, gameState: gameState)
        }
        
        return applyPersonality(statement: response, personality: personality)
    }
    
    // 意見の生成
    private func generateOpinion(player: WerewolfPlayer, about: WerewolfPlayer, gameState: WerewolfGameState) -> String {
        // プレイヤーの立場に応じた意見を生成
        if player.role == .werewolf && about.role != .werewolf {
            // 人狼は村人を疑う傾向
            return "\(about.character.name)は少し気になるかな..."
        } else {
            return "まだ判断が難しいね..."
        }
    }
    
    // 一般的な返答
    private func generateGeneralResponse(player: WerewolfPlayer, gameState: WerewolfGameState) -> String {
        let responses = [
            "なるほどね",
            "そう思う？",
            "確かにそうかも",
            "うーん、どうだろう",
            "その可能性もあるね"
        ]
        return responses.randomElement()!
    }
    
    // 性格を反映した発言に変換
    private func applyPersonality(statement: String, personality: CharacterPersonality) -> String {
        var result = statement
        
        // 一人称の置換
        result = result.replacingOccurrences(of: "私", with: personality.firstPerson.randomElement() ?? "私")
        
        // 語尾の追加
        if !personality.sentenceEndings.isEmpty {
            let ending = personality.sentenceEndings.randomElement()!
            if !result.hasSuffix("。") && !result.hasSuffix("！") && !result.hasSuffix("？") {
                result += ending
            }
        }
        
        // 口癖の挿入（たまに）
        if Int.random(in: 1...10) <= 3, let catchPhrase = personality.catchPhrases.randomElement() {
            result = "\(catchPhrase) \(result)"
        }
        
        // 話し方のスタイルを適用
        switch personality.speechStyle {
        case .polite:
            result = makePolite(result)
        case .casual:
            result = makeCasual(result)
        case .rough:
            result = makeRough(result)
        default:
            break
        }
        
        return result
    }
    
    // 丁寧な話し方に変換
    private func makePolite(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: "だ。", with: "です。")
        result = result.replacingOccurrences(of: "だよ", with: "ですよ")
        result = result.replacingOccurrences(of: "だね", with: "ですね")
        return result
    }
    
    // カジュアルな話し方に変換
    private func makeCasual(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: "です。", with: "だよ。")
        result = result.replacingOccurrences(of: "ます。", with: "るよ。")
        return result
    }
    
    // 粗野な話し方に変換
    private func makeRough(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: "です。", with: "だ。")
        result = result.replacingOccurrences(of: "ます。", with: "る。")
        return result
    }
    
    // ヘルパー関数
    private func hasBeenDivined(player: WerewolfPlayer, by seer: WerewolfPlayer) -> Bool {
        // TODO: 占い履歴の確認
        return false
    }
    
    private func shouldClaimRole(player: WerewolfPlayer, gameState: WerewolfGameState) -> Bool {
        // 2日目以降でカミングアウト
        return gameState.day >= 2 && player.claimHistory.isEmpty
    }
    
    private func shouldFakeClaim(player: WerewolfPlayer, gameState: WerewolfGameState) -> Bool {
        // 他に占い師COがいない場合
        let seerClaims = gameState.players.flatMap { $0.claimHistory }
            .filter { $0.claimedRole == .seer }.count
        return seerClaims == 0 && gameState.day >= 2
    }
    
    private func findSuspiciousPlayer(from: UUID, gameState: WerewolfGameState) -> WerewolfPlayer? {
        // ランダムに怪しい人を選ぶ（自分以外）
        return gameState.alivePlayers.filter { $0.id != from }.randomElement()
    }
    
    private func isBeingSuspected(player: WerewolfPlayer, gameState: WerewolfGameState) -> Bool {
        let recentSuspicions = gameState.players.flatMap { $0.suspicionHistory }
            .filter { $0.suspect == player.id && $0.day == gameState.day }
        return !recentSuspicions.isEmpty
    }
}