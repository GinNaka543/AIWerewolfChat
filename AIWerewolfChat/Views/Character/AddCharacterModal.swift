import SwiftUI
import PhotosUI
import Foundation

struct AddCharacterModal: View {
    @Binding var isPresented: Bool
    @ObservedObject var characterStore: CharacterStore
    
    // 基本情報
    @State private var name = ""
    @State private var age = ""
    @State private var gender = "男性"
    @State private var occupation = ""
    @State private var description = ""
    
    // 画像
    @State private var selectedImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    // 性格・話し方
    @State private var personality = ""
    @State private var speechStyle = "casual"  // casual, polite, formal, archaic
    @State private var firstPersons = ""  // カンマ区切り
    @State private var secondPersons = ""  // カンマ区切り
    @State private var catchPhrases = ""  // カンマ区切り
    @State private var sentenceEndings = ""  // カンマ区切り
    @State private var laughStyle = ""  // 笑い方
    @State private var fillerWords = ""  // 感嘆詞
    
    // タグ
    @State private var selectedTags: Set<Character.CharacterTagType> = []
    
    // 詳細設定（折りたたみ可能）
    @State private var showAdvancedSettings = false
    @State private var coreValues = ""
    @State private var likes = ""
    @State private var dislikes = ""
    @State private var fears = ""
    @State private var dialect = ""
    @State private var reasoningStyle = ""
    @State private var nervousHabits = ""
    
    var body: some View {
        NavigationStack {
            Form {
                // 画像選択セクション
                Section {
                    VStack {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        } else {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray)
                                )
                        }
                        
                        PhotosPicker(selection: $selectedPhotoItem,
                                   matching: .images,
                                   photoLibrary: .shared()) {
                            Text("写真を選択")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .onChange(of: selectedPhotoItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    selectedImage = image
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // 基本情報セクション
                Section("基本情報") {
                    TextField("名前（必須）", text: $name)
                    TextField("年齢", text: $age)
                    Picker("性別", selection: $gender) {
                        Text("男性").tag("男性")
                        Text("女性").tag("女性")
                        Text("その他").tag("その他")
                    }
                    TextField("職業・肩書き", text: $occupation)
                    TextField("キャラクター説明", text: $description, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                // 話し方の基本セクション
                Section("話し方の基本") {
                    HStack {
                        Text("一人称")
                            .frame(width: 80, alignment: .leading)
                            .foregroundColor(.secondary)
                        TextField("私, わたし, 僕, 俺, あたし", text: $firstPersons)
                    }
                    
                    HStack {
                        Text("二人称")
                            .frame(width: 80, alignment: .leading)
                            .foregroundColor(.secondary)
                        TextField("あなた, 君, お前, ～さん", text: $secondPersons)
                    }
                    
                    HStack {
                        Text("語尾")
                            .frame(width: 80, alignment: .leading)
                            .foregroundColor(.secondary)
                        TextField("だよ, だね, です, にゃん, でござる", text: $sentenceEndings)
                    }
                }
                
                // 性格・感情表現セクション
                Section("性格・感情表現") {
                    TextField("基本的な性格（例：優しくて包容力がある）", text: $personality)
                    
                    HStack {
                        Text("笑い方")
                            .frame(width: 80, alignment: .leading)
                            .foregroundColor(.secondary)
                        TextField("あはは, ふふっ, くくく, にひひ", text: $laughStyle)
                    }
                    
                    HStack {
                        Text("感嘆詞")
                            .frame(width: 80, alignment: .leading)
                            .foregroundColor(.secondary)
                        TextField("わー, きゃー, おお, ふむ, あら", text: $fillerWords)
                    }
                    
                    HStack {
                        Text("口癖")
                            .frame(width: 80, alignment: .leading)
                            .foregroundColor(.secondary)
                        TextField("なのだ, ～的な, というか", text: $catchPhrases)
                    }
                }
                
                // タグ選択セクション
                Section("タグ") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(Character.CharacterTagType.allCases, id: \.self) { tag in
                            TagToggleButton(tag: tag, isSelected: selectedTags.contains(tag)) {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            }
                        }
                    }
                }
                
                // 詳細設定セクション（折りたたみ可能）
                Section {
                    DisclosureGroup("詳細設定", isExpanded: $showAdvancedSettings) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("特殊な話し方")
                                .font(.headline)
                            
                            HStack {
                                Text("敬語レベル")
                                    .frame(width: 100, alignment: .leading)
                                    .foregroundColor(.secondary)
                                Picker("", selection: $speechStyle) {
                                    Text("タメ口").tag("casual")
                                    Text("丁寧語").tag("polite")
                                    Text("敬語").tag("formal")
                                    Text("古風").tag("archaic")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            HStack {
                                Text("方言")
                                    .frame(width: 100, alignment: .leading)
                                    .foregroundColor(.secondary)
                                TextField("関西弁, 東北弁, なし", text: $dialect)
                            }
                            
                            Divider()
                            
                            Text("価値観・好み")
                                .font(.headline)
                            
                            TextField("大切にしている価値観", text: $coreValues)
                            TextField("好きなもの", text: $likes)
                            TextField("嫌いなもの", text: $dislikes)
                            TextField("恐れているもの", text: $fears)
                            
                            Divider()
                            
                            Text("人狼ゲーム時の特徴")
                                .font(.headline)
                            
                            HStack {
                                Text("推理スタイル")
                                    .frame(width: 100, alignment: .leading)
                                    .foregroundColor(.secondary)
                                TextField("論理的, 直感的, 感情的", text: $reasoningStyle)
                            }
                            
                            HStack {
                                Text("緊張時の癖")
                                    .frame(width: 100, alignment: .leading)
                                    .foregroundColor(.secondary)
                                TextField("どもる, 早口になる, 沈黙する", text: $nervousHabits)
                            }
                        }
                    }
                }
            }
            .navigationTitle("キャラクター追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveCharacter()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveCharacter() {
        // カンマ区切りのテキストを配列に変換
        let firstPersonArray = firstPersons.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let secondPersonArray = secondPersons.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let catchPhrasesArray = catchPhrases.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let sentenceEndingsArray = sentenceEndings.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let laughStyleArray = laughStyle.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let fillerWordsArray = fillerWords.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        // 話し方スタイルの変換
        let speechStyleText: String = {
            switch speechStyle {
            case "casual": return "カジュアルな口調"
            case "polite": return "丁寧な口調"
            case "formal": return "敬語を使う口調"
            case "archaic": return "古風な口調"
            default: return "普通の口調"
            }
        }()
        
        // 新しいキャラクターを作成
        let newCharacter = Character(
            name: name,
            personality: personality.isEmpty ? "個性的" : personality,
            speechStyle: speechStyleText,
            catchPhrases: catchPhrasesArray.isEmpty ? ["よろしく"] : catchPhrasesArray,
            emoji: "🙂",  // デフォルト絵文字
            color: .blue,  // デフォルトカラー
            description: description.isEmpty ? "カスタムキャラクター" : description,
            rating: 3,  // デフォルト評価
            tags: Array(selectedTags),
            imageName: nil,  // 画像は別途保存
            customImage: selectedImage
        )
        
        // TODO: カスタムキャラクターの詳細性格情報（一人称、二人称、語尾、笑い方など）を
        // CharacterPersonalityとして保存する仕組みを実装
        
        // CharacterStoreに追加
        characterStore.addCustomCharacter(newCharacter)
        
        // モーダルを閉じる
        isPresented = false
    }
}

// タグ選択ボタン
struct TagToggleButton: View {
    let tag: Character.CharacterTagType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag.rawValue)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? tag.color : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

// プレースホルダー用のView拡張は削除（重なり問題の原因）