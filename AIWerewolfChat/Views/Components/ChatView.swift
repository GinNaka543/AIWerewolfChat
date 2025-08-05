import SwiftUI

struct ChatView: View {
    let messages: [Message]
    let onSendMessage: (String) -> Void
    @State private var inputText = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGray6))
                .onChange(of: messages.count) { _, _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            ChatInputBar(
                text: $inputText,
                onSend: {
                    if !inputText.isEmpty {
                        onSendMessage(inputText)
                        inputText = ""
                    }
                }
            )
            .focused($isInputFocused)
        }
        .onTapGesture {
            isInputFocused = false
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.isUser {
                Spacer()
            } else {
                CharacterAvatar(character: message.character)
                    .frame(width: 36, height: 36)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                if !message.isUser {
                    Text(message.character?.name ?? "Unknown")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(message.content)
                    .font(.body)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        message.isUser 
                            ? Color.green 
                            : Color.white
                    )
                    .foregroundColor(
                        message.isUser 
                            ? .white 
                            : .primary
                    )
                    .cornerRadius(16)
                
                HStack(spacing: 4) {
                    if message.isUser {
                        Text("既読")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

struct CharacterAvatar: View {
    let character: Character?
    
    var body: some View {
        if let character = character {
            ZStack {
                Circle()
                    .fill(character.color)
                
                Text(character.emoji)
                    .font(.system(size: 20))
            }
        } else {
            Circle()
                .fill(Color.gray)
        }
    }
}

struct ChatInputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            TextField("メッセージを入力", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    onSend()
                }
            
            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(
                        text.isEmpty ? Color.gray : Color.green
                    )
                    .cornerRadius(18)
            }
            .disabled(text.isEmpty)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}