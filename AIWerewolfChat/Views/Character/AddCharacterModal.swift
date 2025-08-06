import SwiftUI
import PhotosUI

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
    @State private var speechStyle = ""
    @State private var firstPersons = ""  // カンマ区切り
    @State private var secondPersons = ""  // カンマ区切り
    @State private var catchPhrases = ""  // カンマ区切り
    @State private var sentenceEndings = ""  // カンマ区切り
    
    // タグ
    @State private var selectedTags: Set<Character.CharacterTagType> = []
    
    // 詳細設定（折りたたみ可能）
    @State private var showAdvancedSettings = false
    @State private var laughStyle = ""
    @State private var fillerWords = ""
    @State private var coreValues = ""
    @State private var likes = ""
    @State private var dislikes = ""
    @State private var fears = ""
    
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
                
                // 性格・話し方セクション
                Section("性格・話し方") {
                    TextField("性格（例：優しくて包容力がある）", text: $personality)
                    TextField("話し方の特徴（例：丁寧で温かい口調）", text: $speechStyle)
                    TextField("一人称（カンマ区切り）", text: $firstPersons)
                        .placeholder(when: firstPersons.isEmpty) {
                            Text("例: 私, わたし").foregroundColor(.gray)
                        }
                    TextField("二人称（カンマ区切り）", text: $secondPersons)
                        .placeholder(when: secondPersons.isEmpty) {
                            Text("例: あなた, 君").foregroundColor(.gray)
                        }
                    TextField("口癖・決め台詞（カンマ区切り）", text: $catchPhrases)
                        .placeholder(when: catchPhrases.isEmpty) {
                            Text("例: 大丈夫よ, 頑張ってるね").foregroundColor(.gray)
                        }
                    TextField("語尾（カンマ区切り）", text: $sentenceEndings)
                        .placeholder(when: sentenceEndings.isEmpty) {
                            Text("例: だよ, だね, かな").foregroundColor(.gray)
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
                        TextField("笑い方（カンマ区切り）", text: $laughStyle)
                            .placeholder(when: laughStyle.isEmpty) {
                                Text("例: ふふっ, あはは").foregroundColor(.gray)
                            }
                        TextField("つなぎ言葉（カンマ区切り）", text: $fillerWords)
                            .placeholder(when: fillerWords.isEmpty) {
                                Text("例: えっと, まあ, その").foregroundColor(.gray)
                            }
                        TextField("大切にしている価値観（カンマ区切り）", text: $coreValues)
                        TextField("好きなもの（カンマ区切り）", text: $likes)
                        TextField("嫌いなもの（カンマ区切り）", text: $dislikes)
                        TextField("恐れているもの（カンマ区切り）", text: $fears)
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
        
        // 新しいキャラクターを作成
        let newCharacter = Character(
            name: name,
            personality: personality.isEmpty ? "個性的" : personality,
            speechStyle: speechStyle.isEmpty ? "普通の口調" : speechStyle,
            catchPhrases: catchPhrasesArray.isEmpty ? ["よろしく"] : catchPhrasesArray,
            emoji: "🙂",  // デフォルト絵文字
            color: .blue,  // デフォルトカラー
            description: description.isEmpty ? "カスタムキャラクター" : description,
            rating: 3,  // デフォルト評価
            tags: Array(selectedTags),
            imageName: nil,  // 画像は別途保存
            customImage: selectedImage
        )
        
        // カスタムキャラクターの詳細性格情報を作成
        if !firstPersonArray.isEmpty || !secondPersonArray.isEmpty {
            // TODO: カスタムキャラクターの詳細性格情報を保存する仕組みを実装
        }
        
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

// プレースホルダー用のView拡張
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}