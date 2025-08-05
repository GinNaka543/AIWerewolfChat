import Foundation

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let character: Character?
    let isUser: Bool
    let timestamp: Date
    
    init(content: String, character: Character? = nil, isUser: Bool = false) {
        self.content = content
        self.character = character
        self.isUser = isUser
        self.timestamp = Date()
    }
}