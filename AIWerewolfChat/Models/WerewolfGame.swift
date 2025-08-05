import Foundation

// 人狼ゲームの役職
enum WerewolfRole: String, CaseIterable {
    case villager = "村人"
    case werewolf = "人狼"
    case seer = "占い師"
    case medium = "霊媒師"
    case bodyguard = "騎士"
    case madman = "狂人"
    
    var team: Team {
        switch self {
        case .villager, .seer, .medium, .bodyguard:
            return .village
        case .werewolf, .madman:
            return .werewolf
        }
    }
    
    var description: String {
        switch self {
        case .villager:
            return "特別な能力を持たない一般の村人。議論と推理で人狼を見つけ出すことが役目。"
        case .werewolf:
            return "夜に村人を襲撃する。昼は村人のふりをして生き残ることが目標。"
        case .seer:
            return "夜に一人を占い、その人が人狼かどうかを知ることができる。"
        case .medium:
            return "処刑された人が人狼だったかどうかを知ることができる。"
        case .bodyguard:
            return "夜に一人を守ることができる。守った人は人狼に襲撃されても死なない。"
        case .madman:
            return "人間だが人狼陣営。占いでは人間と判定される。人狼の勝利が自分の勝利。"
        }
    }
}

// チーム
enum Team {
    case village    // 村人陣営
    case werewolf   // 人狼陣営
}

// ゲームフェーズ
enum GamePhase {
    case waiting           // 待機中
    case firstNight       // 初日夜
    case dayDiscussion    // 昼の議論
    case dayVoting        // 昼の投票
    case nightAction      // 夜の行動
    case gameEnd          // ゲーム終了
}

// プレイヤーの状態
enum PlayerStatus {
    case alive     // 生存
    case dead      // 死亡
    case executed  // 処刑された
    case attacked  // 襲撃された
}

// ゲーム内のプレイヤー
struct WerewolfPlayer {
    let id: UUID
    let character: Character
    let personality: CharacterPersonality
    var role: WerewolfRole
    var status: PlayerStatus = .alive
    var isUser: Bool
    
    // ゲーム内での行動履歴
    var votingHistory: [VoteRecord] = []
    var claimHistory: [RoleClaim] = []
    var suspicionHistory: [SuspicionRecord] = []
}

// 投票記録
struct VoteRecord {
    let day: Int
    let voter: UUID
    let target: UUID
    let reason: String?
}

// 役職カミングアウト記録
struct RoleClaim {
    let day: Int
    let playerId: UUID
    let claimedRole: WerewolfRole
    let results: [DivinationResult]? // 占い師の場合の結果
}

// 占い結果
struct DivinationResult {
    let day: Int
    let target: UUID
    let result: DivinationResultType
}

enum DivinationResultType {
    case human    // 人間（白）
    case werewolf // 人狼（黒）
}

// 疑い記録
struct SuspicionRecord {
    let day: Int
    let suspector: UUID
    let suspect: UUID
    let reason: String
    let strength: Int // 1-10
}

// ゲーム状態
class WerewolfGameState: ObservableObject {
    @Published var players: [WerewolfPlayer] = []
    @Published var phase: GamePhase = .waiting
    @Published var day: Int = 0
    @Published var timeOfDay: TimeOfDay = .night
    
    // 夜の行動
    @Published var nightActions: NightActions = NightActions()
    
    // 昼の投票
    @Published var votes: [UUID: UUID] = [:] // voter: target
    
    // ゲームログ
    @Published var gameLog: [GameEvent] = []
    
    // 生存者を取得
    var alivePlayers: [WerewolfPlayer] {
        players.filter { $0.status == .alive }
    }
    
    // 役職別のプレイヤーを取得
    func players(withRole role: WerewolfRole) -> [WerewolfPlayer] {
        players.filter { $0.role == role && $0.status == .alive }
    }
    
    // チーム別の生存者数
    func aliveCount(for team: Team) -> Int {
        alivePlayers.filter { $0.role.team == team }.count
    }
    
    // ゲーム終了判定
    var gameResult: GameResult? {
        let villageCount = aliveCount(for: .village)
        let werewolfCount = aliveCount(for: .werewolf)
        
        if werewolfCount == 0 {
            return .villageWin
        } else if werewolfCount >= villageCount {
            return .werewolfWin
        }
        return nil
    }
}

// 時間帯
enum TimeOfDay {
    case day
    case night
}

// 夜の行動
struct NightActions {
    var werewolfTarget: UUID?        // 人狼の襲撃対象
    var seerTarget: UUID?            // 占い師の占い対象
    var bodyguardTarget: UUID?       // 騎士の護衛対象
    var executedPlayerRole: WerewolfRole? // 霊媒師が知る処刑者の役職
}

// ゲームイベント
enum GameEvent {
    case gameStart
    case roleAssignment(playerId: UUID, role: WerewolfRole)
    case nightStart(day: Int)
    case werewolfAttack(targetId: UUID, success: Bool)
    case seerDivination(seerId: UUID, targetId: UUID, result: DivinationResultType)
    case bodyguardProtection(bodyguardId: UUID, targetId: UUID)
    case dayStart(day: Int)
    case playerStatement(playerId: UUID, message: String)
    case roleClaim(playerId: UUID, role: WerewolfRole)
    case votingStart
    case vote(voterId: UUID, targetId: UUID)
    case execution(playerId: UUID, voteCount: Int)
    case mediumResult(mediumId: UUID, executedRole: WerewolfRole)
    case gameEnd(result: GameResult)
    
    var description: String {
        switch self {
        case .gameStart:
            return "ゲームが開始されました"
        case .roleAssignment(let playerId, let role):
            return "プレイヤー \(playerId) に役職 \(role.rawValue) が割り当てられました"
        case .nightStart(let day):
            return "\(day)日目の夜が始まりました"
        case .werewolfAttack(let targetId, let success):
            return success ? "人狼が \(targetId) を襲撃しました" : "人狼の襲撃は失敗しました"
        case .seerDivination(let seerId, let targetId, let result):
            return "占い師 \(seerId) が \(targetId) を占いました（結果: \(result)）"
        case .bodyguardProtection(let bodyguardId, let targetId):
            return "騎士 \(bodyguardId) が \(targetId) を護衛しました"
        case .dayStart(let day):
            return "\(day)日目の昼が始まりました"
        case .playerStatement(let playerId, let message):
            return "プレイヤー \(playerId): \(message)"
        case .roleClaim(let playerId, let role):
            return "プレイヤー \(playerId) が \(role.rawValue) をカミングアウトしました"
        case .votingStart:
            return "投票が開始されました"
        case .vote(let voterId, let targetId):
            return "プレイヤー \(voterId) が \(targetId) に投票しました"
        case .execution(let playerId, let voteCount):
            return "プレイヤー \(playerId) が処刑されました（\(voteCount)票）"
        case .mediumResult(let mediumId, let executedRole):
            return "霊媒師 \(mediumId) の結果: 処刑された人は \(executedRole.rawValue) でした"
        case .gameEnd(let result):
            return "ゲーム終了: \(result.description)"
        }
    }
}

// ゲーム結果
enum GameResult {
    case villageWin
    case werewolfWin
    
    var description: String {
        switch self {
        case .villageWin:
            return "村人陣営の勝利！"
        case .werewolfWin:
            return "人狼陣営の勝利！"
        }
    }
}