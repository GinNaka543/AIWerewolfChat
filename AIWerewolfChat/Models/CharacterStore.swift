import SwiftUI
import Combine

class CharacterStore: ObservableObject {
    @Published var customCharacters: [Character] = []
    
    private let userDefaults = UserDefaults.standard
    private let customCharactersKey = "customCharacters"
    
    init() {
        loadCustomCharacters()
    }
    
    // すべてのキャラクター（デフォルト + カスタム）を取得
    var allCharacters: [Character] {
        Character.sampleCharacters + customCharacters
    }
    
    // カスタムキャラクターを追加
    func addCustomCharacter(_ character: Character) {
        customCharacters.append(character)
        saveCustomCharacters()
    }
    
    // カスタムキャラクターを削除
    func removeCustomCharacter(_ character: Character) {
        customCharacters.removeAll { $0.id == character.id }
        saveCustomCharacters()
    }
    
    // カスタムキャラクターを保存
    private func saveCustomCharacters() {
        // 画像データを含めてエンコード
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(customCharacters.map { CharacterData(from: $0) }) {
            userDefaults.set(encoded, forKey: customCharactersKey)
        }
    }
    
    // カスタムキャラクターを読み込み
    private func loadCustomCharacters() {
        let decoder = JSONDecoder()
        if let data = userDefaults.data(forKey: customCharactersKey),
           let decoded = try? decoder.decode([CharacterData].self, from: data) {
            customCharacters = decoded.map { $0.toCharacter() }
        }
    }
}

// 保存用のデータ構造
struct CharacterData: Codable {
    let id: UUID
    let name: String
    let personality: String
    let speechStyle: String
    let catchPhrases: [String]
    let emoji: String
    let colorData: Data
    let description: String
    let rating: Int
    let tags: [String]
    let imageData: Data?
    
    init(from character: Character) {
        self.id = character.id
        self.name = character.name
        self.personality = character.personality
        self.speechStyle = character.speechStyle
        self.catchPhrases = character.catchPhrases
        self.emoji = character.emoji
        self.colorData = character.color.data ?? Data()
        self.description = character.description
        self.rating = character.rating
        self.tags = character.tags.map { $0.rawValue }
        self.imageData = character.customImage?.jpegData(compressionQuality: 0.8)
    }
    
    func toCharacter() -> Character {
        let color = Color(data: colorData) ?? .blue
        let tagTypes = tags.compactMap { Character.CharacterTagType(rawValue: $0) }
        let image = imageData.flatMap { UIImage(data: $0) }
        
        return Character(
            name: name,
            personality: personality,
            speechStyle: speechStyle,
            catchPhrases: catchPhrases,
            emoji: emoji,
            color: color,
            description: description,
            rating: rating,
            tags: tagTypes,
            imageName: nil,
            customImage: image
        )
    }
}

// Color拡張（保存用）
extension Color {
    var data: Data? {
        let uiColor = UIColor(self)
        return try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
    }
    
    init?(data: Data) {
        guard let uiColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor else {
            return nil
        }
        self.init(uiColor: uiColor)
    }
}