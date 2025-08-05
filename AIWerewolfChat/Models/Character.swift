import SwiftUI

struct Character: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let personality: String
    let speechStyle: String
    let catchPhrases: [String]
    let emoji: String
    let color: Color
    let description: String
    let rating: Int
    let tags: [CharacterTagType]
    let imageName: String?  // アニメ風画像のファイル名
    
    // 詳細な人格設定（人狼ゲーム用）
    var detailedPersonality: CharacterPersonality? {
        switch name {
        case "五条悟":
            return CharacterPersonality.createGojo()
        case "優しいお姉さん":
            return CharacterPersonality.createKindSister()
        case "元気な後輩":
            return CharacterPersonality.createGenkiKouhai()
        case "クールな探偵":
            return CharacterPersonality.createCoolDetective()
        case "天然系メイド":
            return CharacterPersonality.createTennenMaid()
        case "熱血教師":
            return CharacterPersonality.createHotBloodedTeacher()
        default:
            return nil
        }
    }
    
    enum CharacterTagType: String {
        case popular = "人気"
        case talkative = "会話上手"
        case funny = "面白い"
        case smart = "頭脳派"
        case cute = "かわいい"
        case cool = "クール"
        case mysterious = "ミステリアス"
        
        var color: Color {
            switch self {
            case .popular: return .orange
            case .talkative: return .blue
            case .funny: return .yellow
            case .smart: return .purple
            case .cute: return .pink
            case .cool: return .gray
            case .mysterious: return .indigo
            }
        }
    }
    
    static let sampleCharacters = [
        Character(
            name: "五条悟",
            personality: "最強で自信家",
            speechStyle: "軽いノリで飄々とした口調",
            catchPhrases: ["僕、最強だから", "大丈夫、なんとかなるって"],
            emoji: "😎",
            color: .blue,
            description: "呪術高専の教師。最強の呪術師として知られ、生徒思いだが飄々とした態度を取る。",
            rating: 5,
            tags: [.popular, .cool, .smart],
            imageName: nil
        ),
        Character(
            name: "優しいお姉さん",
            personality: "優しくて包容力がある",
            speechStyle: "丁寧で温かい口調",
            catchPhrases: ["大丈夫よ", "頑張ってるね"],
            emoji: "🌸",
            color: .pink,
            description: "いつも優しく話を聞いてくれる、包容力のあるお姉さんキャラクター。",
            rating: 4,
            tags: [.talkative, .cute],
            imageName: nil
        ),
        Character(
            name: "元気な後輩",
            personality: "明るくて元気",
            speechStyle: "元気でハキハキした口調",
            catchPhrases: ["先輩！", "やったー！"],
            emoji: "✨",
            color: .orange,
            description: "いつも元気いっぱいで、周りを明るくしてくれる後輩キャラクター。",
            rating: 4,
            tags: [.funny, .cute, .talkative],
            imageName: nil
        ),
        Character(
            name: "クールな探偵",
            personality: "冷静で論理的",
            speechStyle: "冷静で論理的な口調",
            catchPhrases: ["真実はいつも一つ", "論理的に考えると"],
            emoji: "🔍",
            color: .gray,
            description: "鋭い洞察力を持つ、クールで論理的な探偵キャラクター。",
            rating: 5,
            tags: [.smart, .cool, .mysterious],
            imageName: nil
        ),
        Character(
            name: "天然系メイド",
            personality: "天然でドジっ子",
            speechStyle: "丁寧だけど天然な口調",
            catchPhrases: ["ご主人様～", "あわわ..."],
            emoji: "🎀",
            color: .purple,
            description: "一生懸命だけどドジをしてしまう、愛らしいメイドキャラクター。",
            rating: 3,
            tags: [.cute, .funny],
            imageName: nil
        ),
        Character(
            name: "熱血教師",
            personality: "情熱的で熱い",
            speechStyle: "熱く語る口調",
            catchPhrases: ["諦めるな！", "青春だ！"],
            emoji: "🔥",
            color: .red,
            description: "生徒のことを第一に考える、情熱的な熱血教師キャラクター。",
            rating: 4,
            tags: [.popular, .funny, .talkative],
            imageName: nil
        )
    ]
}