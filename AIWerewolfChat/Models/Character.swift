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
    
    static let sampleCharacters = [
        Character(
            name: "五条悟",
            personality: "最強で自信家",
            speechStyle: "軽いノリで飄々とした口調",
            catchPhrases: ["僕、最強だから", "大丈夫、なんとかなるって"],
            emoji: "😎",
            color: .blue,
            description: "呪術高専の教師。最強の呪術師として知られ、生徒思いだが飄々とした態度を取る。"
        ),
        Character(
            name: "優しいお姉さん",
            personality: "優しくて包容力がある",
            speechStyle: "丁寧で温かい口調",
            catchPhrases: ["大丈夫よ", "頑張ってるね"],
            emoji: "🌸",
            color: .pink,
            description: "いつも優しく話を聞いてくれる、包容力のあるお姉さんキャラクター。"
        ),
        Character(
            name: "元気な後輩",
            personality: "明るくて元気",
            speechStyle: "元気でハキハキした口調",
            catchPhrases: ["先輩！", "やったー！"],
            emoji: "✨",
            color: .orange,
            description: "いつも元気いっぱいで、周りを明るくしてくれる後輩キャラクター。"
        ),
        Character(
            name: "クールな探偵",
            personality: "冷静で論理的",
            speechStyle: "冷静で論理的な口調",
            catchPhrases: ["真実はいつも一つ", "論理的に考えると"],
            emoji: "🔍",
            color: .gray,
            description: "鋭い洞察力を持つ、クールで論理的な探偵キャラクター。"
        ),
        Character(
            name: "天然系メイド",
            personality: "天然でドジっ子",
            speechStyle: "丁寧だけど天然な口調",
            catchPhrases: ["ご主人様～", "あわわ..."],
            emoji: "🎀",
            color: .purple,
            description: "一生懸命だけどドジをしてしまう、愛らしいメイドキャラクター。"
        ),
        Character(
            name: "熱血教師",
            personality: "情熱的で熱い",
            speechStyle: "熱く語る口調",
            catchPhrases: ["諦めるな！", "青春だ！"],
            emoji: "🔥",
            color: .red,
            description: "生徒のことを第一に考える、情熱的な熱血教師キャラクター。"
        )
    ]
}