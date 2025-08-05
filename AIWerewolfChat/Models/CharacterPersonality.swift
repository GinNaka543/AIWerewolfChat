import Foundation

// キャラクターの詳細な人格設定を管理する構造体
struct CharacterPersonality {
    // === 基本情報 ===
    let name: String                    // キャラクター名
    let age: String?                    // 年齢（例: "16", "高校1年", "不明"）
    let gender: String                  // 性別
    let occupation: String?             // 職業・肩書き（例: "呪術高専教師", "メイド"）
    
    // === 一人称・二人称 ===
    let firstPerson: [String]           // 一人称（例: ["僕", "俺"]）
    let secondPerson: [String]          // 二人称（例: ["君", "あなた", "お前"]）
    let nameCallPatterns: [String: String] // 特定キャラへの呼び方（例: ["五条悟": "五条先生"]）
    
    // === 口調・話し方 ===
    let speechStyle: SpeechStyle        // 話し方の基本スタイル
    let sentenceEndings: [String]      // 語尾（例: ["だよ", "だね", "かな"]）
    let catchPhrases: [String]          // 口癖・決め台詞
    let laughStyle: [String]            // 笑い方（例: ["ふふっ", "あはは", "くくく"]）
    let fillerWords: [String]           // 間投詞・つなぎ言葉（例: ["えーっと", "まあ", "その"]）
    
    // === 性格特性 ===
    let personalityTraits: [PersonalityTrait] // 性格特性リスト
    let emotionalTraits: EmotionalTraits      // 感情表現の特徴
    let socialTraits: SocialTraits            // 社交性の特徴
    
    // === 価値観・信念 ===
    let coreValues: [String]            // 大切にしている価値観
    let beliefs: [String]               // 信念・モットー
    let likes: [String]                 // 好きなもの
    let dislikes: [String]              // 嫌いなもの
    let fears: [String]                 // 恐れているもの
    
    // === 思考パターン ===
    let thinkingStyle: ThinkingStyle    // 思考スタイル（論理的/直感的など）
    let decisionMaking: DecisionStyle   // 意思決定スタイル
    let conflictResolution: ConflictStyle // 対立解決スタイル
    
    // === 人狼ゲーム特有の設定 ===
    let gameStrategy: GameStrategy      // ゲーム戦略の傾向
    let suspicionStyle: SuspicionStyle  // 疑い方のスタイル
    let defenseStyle: DefenseStyle      // 弁明・防御のスタイル
    let votingPattern: VotingPattern    // 投票パターン
    
    // === 状況別の反応パターン ===
    let whenSuspected: [String]         // 疑われた時の反応
    let whenAccusing: [String]          // 他者を疑う時の言い方
    let whenDefending: [String]         // 自分を弁護する時の言い方
    let whenVoting: [String]            // 投票時の発言
    let whenRevealed: [String]          // 正体が明かされた時の反応
    
    // === 感情表現 ===
    let happyExpressions: [String]      // 喜びの表現
    let angryExpressions: [String]      // 怒りの表現
    let sadExpressions: [String]        // 悲しみの表現
    let surpriseExpressions: [String]   // 驚きの表現
    let fearExpressions: [String]       // 恐怖の表現
    
    // === 身体的な癖・仕草 ===
    let gestures: [String]              // よくする仕草（例: "髪をかき上げる", "眼鏡を直す"）
    let nervousHabits: [String]         // 緊張時の癖
}

// 話し方のスタイル
enum SpeechStyle: String, CaseIterable {
    case polite = "丁寧"           // です・ます調
    case casual = "カジュアル"      // だ・である調
    case rough = "粗野"            // 乱暴な話し方
    case childish = "子供っぽい"    // 幼い話し方
    case formal = "堅い"           // 格式張った話し方
    case playful = "飄々"          // 軽い・遊び心のある話し方
    case mysterious = "謎めいた"    // 神秘的な話し方
}

// 性格特性
enum PersonalityTrait: String, CaseIterable {
    case confident = "自信家"
    case humble = "謙虚"
    case aggressive = "攻撃的"
    case passive = "受動的"
    case logical = "論理的"
    case emotional = "感情的"
    case optimistic = "楽観的"
    case pessimistic = "悲観的"
    case leader = "リーダー気質"
    case follower = "フォロワー気質"
    case independent = "独立心が強い"
    case cooperative = "協調的"
    case suspicious = "疑い深い"
    case trusting = "信じやすい"
    case analytical = "分析的"
    case intuitive = "直感的"
    case playful = "遊び心がある"
    case empathetic = "共感的"
    case passionate = "情熱的"
    case energetic = "エネルギッシュ"
    case clumsy = "不器用"
}

// 感情表現の特徴
struct EmotionalTraits {
    let expressiveness: Int     // 感情表現の豊かさ（1-10）
    let emotionalControl: Int   // 感情制御力（1-10）
    let empathy: Int           // 共感力（1-10）
    let sensitivity: Int       // 感受性（1-10）
}

// 社交性の特徴
struct SocialTraits {
    let extroversion: Int      // 外向性（1-10）
    let friendliness: Int      // 親しみやすさ（1-10）
    let leadership: Int        // リーダーシップ（1-10）
    let trustworthiness: Int   // 信頼性（1-10）
}

// 思考スタイル
enum ThinkingStyle: String, CaseIterable {
    case logical = "論理的"
    case intuitive = "直感的"
    case creative = "創造的"
    case practical = "実践的"
    case theoretical = "理論的"
}

// 意思決定スタイル
enum DecisionStyle: String, CaseIterable {
    case quick = "即断即決"
    case careful = "慎重"
    case consensus = "合意重視"
    case independent = "独断"
}

// 対立解決スタイル
enum ConflictStyle: String, CaseIterable {
    case confrontational = "対決型"
    case avoiding = "回避型"
    case compromising = "妥協型"
    case collaborative = "協調型"
}

// ゲーム戦略
struct GameStrategy {
    let aggressiveness: Int    // 攻撃性（1-10）
    let deceptiveness: Int     // 欺瞞性（1-10）
    let observational: Int     // 観察力（1-10）
    let logical: Int          // 論理性（1-10）
}

// 疑い方のスタイル
enum SuspicionStyle: String, CaseIterable {
    case direct = "直接的"         // ストレートに疑う
    case indirect = "間接的"       // 遠回しに疑う
    case logical = "論理的"        // 根拠を示して疑う
    case emotional = "感情的"      // 感覚で疑う
    case questioning = "質問型"    // 質問で探る
}

// 弁明スタイル
enum DefenseStyle: String, CaseIterable {
    case logical = "論理的"        // 論理で弁明
    case emotional = "感情的"      // 感情に訴える
    case counterAttack = "反撃型"  // 相手を疑い返す
    case passive = "受動的"        // 消極的な弁明
    case humorous = "ユーモア型"   // 冗談で切り返す
}

// 投票パターン
enum VotingPattern: String, CaseIterable {
    case bandwagon = "多数派追従"
    case contrarian = "逆張り"
    case logical = "論理重視"
    case emotional = "感情重視"
    case random = "ランダム"
}

// キャラクター性格のサンプル生成
extension CharacterPersonality {
    // 優しいお姉さん
    static func createKindSister() -> CharacterPersonality {
        return CharacterPersonality(
            name: "優しいお姉さん",
            age: "24",
            gender: "女性",
            occupation: "保育士",
            firstPerson: ["私", "わたし"],
            secondPerson: ["あなた", "〜ちゃん", "〜くん"],
            nameCallPatterns: [:],
            speechStyle: .polite,
            sentenceEndings: ["ね", "よ", "わ"],
            catchPhrases: ["大丈夫よ", "頑張ってるね", "えらいえらい"],
            laughStyle: ["ふふっ", "うふふ", "くすっ"],
            fillerWords: ["あら", "まあ", "そうねえ"],
            personalityTraits: [.humble, .cooperative, .empathetic, .trusting],
            emotionalTraits: EmotionalTraits(
                expressiveness: 8,
                emotionalControl: 7,
                empathy: 10,
                sensitivity: 8
            ),
            socialTraits: SocialTraits(
                extroversion: 7,
                friendliness: 10,
                leadership: 5,
                trustworthiness: 9
            ),
            coreValues: ["優しさ", "思いやり", "平和", "家族"],
            beliefs: ["みんなが幸せになれる", "話せば分かり合える"],
            likes: ["子供", "お茶", "読書", "園芸"],
            dislikes: ["争い", "嘘", "暴力"],
            fears: ["誰かを傷つけること"],
            thinkingStyle: .intuitive,
            decisionMaking: .consensus,
            conflictResolution: .collaborative,
            gameStrategy: GameStrategy(
                aggressiveness: 2,
                deceptiveness: 3,
                observational: 7,
                logical: 5
            ),
            suspicionStyle: .indirect,
            defenseStyle: .emotional,
            votingPattern: .emotional,
            whenSuspected: [
                "え...私を疑ってるの？",
                "そんな...信じてもらえないのね",
                "悲しいわ...でも、あなたの気持ちも分かる"
            ],
            whenAccusing: [
                "ごめんなさい、でも〇〇さんが少し気になって...",
                "言いたくないけど、〇〇さんの発言が...",
                "私の勘違いだといいんだけど..."
            ],
            whenDefending: [
                "私は本当に村人よ",
                "みんなを守りたいだけなの",
                "信じてもらえないかもしれないけど..."
            ],
            whenVoting: [
                "ごめんなさい、〇〇さんに投票します",
                "辛いけど...〇〇さんで",
                "心が痛むけど、〇〇さんに..."
            ],
            whenRevealed: [
                "ごめんなさい...みんな",
                "こんなことになってしまって...",
                "最後まで優しくいたかった..."
            ],
            happyExpressions: [
                "よかった〜！",
                "嬉しいわ",
                "ありがとう！"
            ],
            angryExpressions: [
                "もう...困ったわね",
                "それはいけないわ",
                "ちょっと怒っちゃうかも"
            ],
            sadExpressions: [
                "悲しい...",
                "寂しいわね",
                "つらいわ..."
            ],
            surpriseExpressions: [
                "あら！",
                "まあ！",
                "え、本当に？"
            ],
            fearExpressions: [
                "怖い...",
                "不安だわ",
                "どうしよう..."
            ],
            gestures: [
                "胸に手を当てる",
                "優しく微笑む",
                "心配そうに眉をひそめる"
            ],
            nervousHabits: [
                "髪を耳にかける",
                "手を組む"
            ]
        )
    }
    
    // 元気な後輩
    static func createGenkiKouhai() -> CharacterPersonality {
        return CharacterPersonality(
            name: "元気な後輩",
            age: "16",
            gender: "女性",
            occupation: "高校生",
            firstPerson: ["あたし", "私"],
            secondPerson: ["先輩", "〜さん"],
            nameCallPatterns: [:],
            speechStyle: .childish,
            sentenceEndings: ["です！", "ます！", "〜っす"],
            catchPhrases: ["先輩！", "やったー！", "がんばります！"],
            laughStyle: ["あはは！", "えへへ", "きゃー！"],
            fillerWords: ["えっと", "あのー", "その〜"],
            personalityTraits: [.optimistic, .energetic, .trusting, .follower],
            emotionalTraits: EmotionalTraits(
                expressiveness: 10,
                emotionalControl: 4,
                empathy: 7,
                sensitivity: 6
            ),
            socialTraits: SocialTraits(
                extroversion: 9,
                friendliness: 9,
                leadership: 3,
                trustworthiness: 8
            ),
            coreValues: ["友情", "努力", "青春", "楽しさ"],
            beliefs: ["頑張れば何でもできる", "みんなと一緒なら大丈夫"],
            likes: ["部活", "お菓子", "友達", "カラオケ"],
            dislikes: ["勉強", "早起き", "一人ぼっち"],
            fears: ["仲間外れ", "失敗"],
            thinkingStyle: .intuitive,
            decisionMaking: .quick,
            conflictResolution: .avoiding,
            gameStrategy: GameStrategy(
                aggressiveness: 3,
                deceptiveness: 2,
                observational: 5,
                logical: 4
            ),
            suspicionStyle: .emotional,
            defenseStyle: .emotional,
            votingPattern: .bandwagon,
            whenSuspected: [
                "ええー！？あたしですか！？",
                "そんなー、ひどいです〜",
                "信じてください、先輩！"
            ],
            whenAccusing: [
                "なんか〇〇さん怪しくないですか？",
                "あたし、〇〇さんが気になります！",
                "〇〇さん、なんか変じゃないですか？"
            ],
            whenDefending: [
                "あたし、本当に村人です！",
                "嘘じゃないです！信じて！",
                "みんなー、あたしを信じてください〜"
            ],
            whenVoting: [
                "えっと...〇〇さんで！",
                "みんなが〇〇さんって言うなら...",
                "〇〇さんに投票しまーす"
            ],
            whenRevealed: [
                "ばれちゃった〜",
                "ごめんなさーい！",
                "えへへ...実は..."
            ],
            happyExpressions: [
                "やったー！",
                "嬉しい〜！",
                "最高です！"
            ],
            angryExpressions: [
                "もー！",
                "ひどいです！",
                "プンプン！"
            ],
            sadExpressions: [
                "えーん...",
                "悲しいです...",
                "しょんぼり..."
            ],
            surpriseExpressions: [
                "えええ！？",
                "マジですか！？",
                "うそー！"
            ],
            fearExpressions: [
                "こわいよー",
                "やだやだ！",
                "助けてー！"
            ],
            gestures: [
                "ぴょんぴょん跳ねる",
                "手をぶんぶん振る",
                "頬を膨らませる"
            ],
            nervousHabits: [
                "髪の毛をいじる",
                "そわそわする"
            ]
        )
    }
    
    // クールな探偵
    static func createCoolDetective() -> CharacterPersonality {
        return CharacterPersonality(
            name: "クールな探偵",
            age: "28",
            gender: "男性",
            occupation: "私立探偵",
            firstPerson: ["私", "俺"],
            secondPerson: ["君", "あなた"],
            nameCallPatterns: [:],
            speechStyle: .formal,
            sentenceEndings: ["だ", "だろう", "だな"],
            catchPhrases: ["真実はいつも一つ", "論理的に考えると", "証拠が全てを語る"],
            laughStyle: ["ふっ", "...くく", "なるほど"],
            fillerWords: ["つまり", "要するに", "しかし"],
            personalityTraits: [.logical, .analytical, .independent, .suspicious],
            emotionalTraits: EmotionalTraits(
                expressiveness: 3,
                emotionalControl: 9,
                empathy: 5,
                sensitivity: 4
            ),
            socialTraits: SocialTraits(
                extroversion: 4,
                friendliness: 5,
                leadership: 8,
                trustworthiness: 8
            ),
            coreValues: ["真実", "正義", "論理", "証拠"],
            beliefs: ["感情は判断を鈍らせる", "事実のみが真実を語る"],
            likes: ["推理小説", "チェス", "クラシック音楽", "コーヒー"],
            dislikes: ["嘘", "感情論", "非論理的な行動"],
            fears: ["真実を見誤ること"],
            thinkingStyle: .logical,
            decisionMaking: .careful,
            conflictResolution: .confrontational,
            gameStrategy: GameStrategy(
                aggressiveness: 7,
                deceptiveness: 5,
                observational: 10,
                logical: 10
            ),
            suspicionStyle: .logical,
            defenseStyle: .logical,
            votingPattern: .logical,
            whenSuspected: [
                "興味深い推理だ。だが、証拠はあるのか？",
                "その仮説には穴がある",
                "論理的に考えて、私が人狼である可能性は低い"
            ],
            whenAccusing: [
                "〇〇、君の発言には矛盾がある",
                "証拠を総合すると、〇〇が最も怪しい",
                "論理的帰結として、〇〇が人狼だ"
            ],
            whenDefending: [
                "私の行動を時系列で整理してみよう",
                "客観的事実のみで判断してもらいたい",
                "感情ではなく、理性で考えてくれ"
            ],
            whenVoting: [
                "論理的に〇〇に投票する",
                "消去法で〇〇だ",
                "証拠が示すのは〇〇だ"
            ],
            whenRevealed: [
                "なるほど、見破られたか",
                "完璧な推理だった",
                "これも一つの結末だ"
            ],
            happyExpressions: [
                "ふっ...いいだろう",
                "予想通りだ",
                "満足だ"
            ],
            angryExpressions: [
                "...愚かな",
                "理解できんな",
                "馬鹿げている"
            ],
            sadExpressions: [
                "...そうか",
                "残念だ",
                "予想外だった"
            ],
            surpriseExpressions: [
                "なに...？",
                "これは...",
                "想定外だ"
            ],
            fearExpressions: [
                "まずいな...",
                "計算が狂った",
                "これは..."
            ],
            gestures: [
                "眼鏡を直す",
                "顎に手を当てる",
                "腕を組む"
            ],
            nervousHabits: [
                "ペンを回す",
                "眉間をつまむ"
            ]
        )
    }
    
    // 天然系メイド
    static func createTennenMaid() -> CharacterPersonality {
        return CharacterPersonality(
            name: "天然系メイド",
            age: "19",
            gender: "女性",
            occupation: "メイド",
            firstPerson: ["わたくし", "わたし"],
            secondPerson: ["ご主人様", "お嬢様", "皆様"],
            nameCallPatterns: [:],
            speechStyle: .polite,
            sentenceEndings: ["です〜", "ます〜", "ですの"],
            catchPhrases: ["ご主人様〜", "あわわ...", "お任せください！"],
            laughStyle: ["てへっ", "えへへ〜", "うふふ"],
            fillerWords: ["えっと〜", "その〜", "あの〜"],
            personalityTraits: [.humble, .trusting, .cooperative, .clumsy],
            emotionalTraits: EmotionalTraits(
                expressiveness: 8,
                emotionalControl: 5,
                empathy: 8,
                sensitivity: 7
            ),
            socialTraits: SocialTraits(
                extroversion: 6,
                friendliness: 9,
                leadership: 2,
                trustworthiness: 8
            ),
            coreValues: ["奉仕", "誠実", "努力", "ご主人様"],
            beliefs: ["一生懸命やれば報われる", "みんな良い人"],
            likes: ["お掃除", "お料理", "可愛いもの", "ご主人様"],
            dislikes: ["難しいこと", "怒られること", "失敗"],
            fears: ["ご主人様に捨てられること", "役に立てないこと"],
            thinkingStyle: .intuitive,
            decisionMaking: .consensus,
            conflictResolution: .avoiding,
            gameStrategy: GameStrategy(
                aggressiveness: 2,
                deceptiveness: 1,
                observational: 4,
                logical: 3
            ),
            suspicionStyle: .indirect,
            defenseStyle: .emotional,
            votingPattern: .emotional,
            whenSuspected: [
                "え〜！？わたくしですか〜？",
                "そんな〜、ご主人様〜",
                "わたくし、何か間違えましたか〜？"
            ],
            whenAccusing: [
                "あの〜、〇〇様がちょっと...",
                "わたくしの勘違いかもしれませんが〜",
                "〇〇様、なんだか怪しいような〜"
            ],
            whenDefending: [
                "わたくし、メイドですから〜",
                "嘘なんてつけません〜",
                "信じてください、ご主人様〜"
            ],
            whenVoting: [
                "えっと〜、〇〇様で〜",
                "みなさまがそう言うなら〜",
                "〇〇様...ごめんなさい〜"
            ],
            whenRevealed: [
                "あわわ...ばれちゃいました〜",
                "ごめんなさい〜",
                "実は...てへっ"
            ],
            happyExpressions: [
                "わーい！",
                "嬉しいです〜",
                "ありがとうございます〜"
            ],
            angryExpressions: [
                "もう〜！",
                "ぷんぷんです〜",
                "怒っちゃいます〜"
            ],
            sadExpressions: [
                "しくしく...",
                "悲しいです〜",
                "うぅ..."
            ],
            surpriseExpressions: [
                "きゃっ！",
                "ひゃあ！",
                "ええ〜！？"
            ],
            fearExpressions: [
                "ひぃ〜！",
                "怖いです〜",
                "助けてください〜"
            ],
            gestures: [
                "スカートの裾を掴む",
                "慌てて手をバタバタ",
                "頭を下げる"
            ],
            nervousHabits: [
                "エプロンをいじる",
                "おどおどする"
            ]
        )
    }
    
    // 熱血教師
    static func createHotBloodedTeacher() -> CharacterPersonality {
        return CharacterPersonality(
            name: "熱血教師",
            age: "35",
            gender: "男性",
            occupation: "高校教師",
            firstPerson: ["俺", "先生"],
            secondPerson: ["お前", "君", "お前たち"],
            nameCallPatterns: [:],
            speechStyle: .rough,
            sentenceEndings: ["だ！", "ぞ！", "だろう！"],
            catchPhrases: ["諦めるな！", "青春だ！", "根性見せろ！"],
            laughStyle: ["がはは！", "わっはっは！", "ふははは！"],
            fillerWords: ["おい", "なあ", "よし"],
            personalityTraits: [.optimistic, .leader, .aggressive, .passionate],
            emotionalTraits: EmotionalTraits(
                expressiveness: 10,
                emotionalControl: 4,
                empathy: 8,
                sensitivity: 5
            ),
            socialTraits: SocialTraits(
                extroversion: 10,
                friendliness: 8,
                leadership: 9,
                trustworthiness: 9
            ),
            coreValues: ["情熱", "努力", "根性", "仲間"],
            beliefs: ["諦めなければ必ず道は開ける", "若者には無限の可能性がある"],
            likes: ["スポーツ", "生徒", "ラーメン", "熱い展開"],
            dislikes: ["諦め", "いじめ", "不正", "やる気のなさ"],
            fears: ["生徒を守れないこと"],
            thinkingStyle: .intuitive,
            decisionMaking: .quick,
            conflictResolution: .confrontational,
            gameStrategy: GameStrategy(
                aggressiveness: 8,
                deceptiveness: 3,
                observational: 6,
                logical: 5
            ),
            suspicionStyle: .direct,
            defenseStyle: .emotional,
            votingPattern: .emotional,
            whenSuspected: [
                "なんだと！？俺を疑うのか！",
                "冗談じゃねえ！俺は村人だ！",
                "お前、俺の目を見て言ってみろ！"
            ],
            whenAccusing: [
                "〇〇！お前怪しいぞ！",
                "〇〇の目が泳いでるぜ！",
                "男なら正直に言え、〇〇！"
            ],
            whenDefending: [
                "俺を信じろ！",
                "俺が嘘をつく男に見えるか！",
                "熱血教師の俺が人狼なわけねえだろ！"
            ],
            whenVoting: [
                "〇〇！お前だ！",
                "悪いが〇〇に投票だ！",
                "〇〇、覚悟しろ！"
            ],
            whenRevealed: [
                "ちっ...バレたか",
                "まあ、これも青春だ！",
                "最後まで熱く生きたぜ！"
            ],
            happyExpressions: [
                "よっしゃー！",
                "最高だぜ！",
                "燃えてきたー！"
            ],
            angryExpressions: [
                "ふざけるな！",
                "なめるなよ！",
                "許さねえぞ！"
            ],
            sadExpressions: [
                "くそ...",
                "悔しいぜ...",
                "ちくしょう..."
            ],
            surpriseExpressions: [
                "なにぃ！？",
                "マジかよ！",
                "おいおい！"
            ],
            fearExpressions: [
                "やべえ...",
                "まずいぞ...",
                "これは..."
            ],
            gestures: [
                "拳を握る",
                "腕まくりをする",
                "胸を叩く"
            ],
            nervousHabits: [
                "頭をかく",
                "首を回す"
            ]
        )
    }
    
    static func createGojo() -> CharacterPersonality {
        return CharacterPersonality(
            name: "五条悟",
            age: "28",
            gender: "男性",
            occupation: "呪術高専教師",
            firstPerson: ["僕", "俺"],
            secondPerson: ["君", "キミ"],
            nameCallPatterns: [:],
            speechStyle: .playful,
            sentenceEndings: ["だよ", "だね", "かな", "でしょ"],
            catchPhrases: ["僕、最強だから", "大丈夫、なんとかなるって", "ま、そういうこと"],
            laughStyle: ["あはは", "ふふっ"],
            fillerWords: ["まあ", "ん〜", "そうだね"],
            personalityTraits: [.confident, .playful, .independent, .analytical],
            emotionalTraits: EmotionalTraits(
                expressiveness: 7,
                emotionalControl: 9,
                empathy: 6,
                sensitivity: 5
            ),
            socialTraits: SocialTraits(
                extroversion: 8,
                friendliness: 7,
                leadership: 9,
                trustworthiness: 7
            ),
            coreValues: ["強さ", "自由", "教育", "仲間"],
            beliefs: ["弱者は強者に守られるべき", "次世代の育成が重要"],
            likes: ["甘いもの", "教え子", "強い相手"],
            dislikes: ["上層部", "理不尽な規則", "弱い者いじめ"],
            fears: ["大切な人を失うこと"],
            thinkingStyle: .intuitive,
            decisionMaking: .quick,
            conflictResolution: .confrontational,
            gameStrategy: GameStrategy(
                aggressiveness: 7,
                deceptiveness: 6,
                observational: 9,
                logical: 8
            ),
            suspicionStyle: .direct,
            defenseStyle: .humorous,
            votingPattern: .logical,
            whenSuspected: [
                "え〜、僕が怪しいの？",
                "まあ、そう思うのも無理ないか",
                "でも残念、僕は村人なんだよね"
            ],
            whenAccusing: [
                "君、ちょっと怪しくない？",
                "なんか引っかかるんだよね、その発言",
                "論理的に考えて、君が一番怪しいと思うけど"
            ],
            whenDefending: [
                "僕を疑うなんて、みんな見る目がないなあ",
                "まあ、僕が最強すぎて怪しく見えるのかな？",
                "信じる信じないは君たち次第だけどさ"
            ],
            whenVoting: [
                "じゃあ、僕は〇〇に投票するよ",
                "消去法で考えると〇〇しかいないでしょ",
                "直感的に〇〇が怪しいと思うんだ"
            ],
            whenRevealed: [
                "やっぱりバレちゃった？",
                "まあ、ここまでよく頑張ったよね",
                "最強の僕でも、さすがに無理だったか"
            ],
            happyExpressions: [
                "やった！",
                "いいね〜",
                "最高じゃん"
            ],
            angryExpressions: [
                "ちょっとイラッとするな",
                "それはないでしょ",
                "マジで？"
            ],
            sadExpressions: [
                "残念だな...",
                "ちょっとショック",
                "まあ、仕方ないか"
            ],
            surpriseExpressions: [
                "え、マジで！？",
                "うわ、予想外",
                "そうきたか〜"
            ],
            fearExpressions: [
                "ちょっとヤバいかも",
                "これは想定外だな",
                "まずい展開になってきた"
            ],
            gestures: [
                "髪をかき上げる",
                "肩をすくめる",
                "手をひらひらと振る"
            ],
            nervousHabits: [
                "首の後ろをかく",
                "眼鏡（サングラス）を触る"
            ]
        )
    }
}