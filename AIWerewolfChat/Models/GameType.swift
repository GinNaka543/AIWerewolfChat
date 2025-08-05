import Foundation

enum GameType: String, CaseIterable, Identifiable {
    case werewolf = "werewolf"
    case sanRentan = "sanrentan"
    case ito = "ito"
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .werewolf:
            return "人狼ゲーム"
        case .sanRentan:
            return "サンレンタン"
        case .ito:
            return "ito（イト）"
        }
    }
    
    var description: String {
        switch self {
        case .werewolf:
            return "村人と人狼に分かれて戦う心理戦ゲーム。議論と推理で人狼を見つけ出そう！"
        case .sanRentan:
            return "お題に対する価値観の1〜3位を当てるゲーム。相手の価値観を理解しよう！"
        case .ito:
            return "数字を言葉で表現して、協力して順番に出すゲーム。価値観のズレが楽しい！"
        }
    }
    
    var minPlayers: Int {
        switch self {
        case .werewolf:
            return 4
        case .sanRentan:
            return 2
        case .ito:
            return 2
        }
    }
    
    var maxPlayers: Int {
        switch self {
        case .werewolf:
            return 8
        case .sanRentan:
            return 6
        case .ito:
            return 10
        }
    }
    
    var estimatedTime: Int {
        switch self {
        case .werewolf:
            return 30
        case .sanRentan:
            return 15
        case .ito:
            return 20
        }
    }
}