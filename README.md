# AI Werewolf Chat - AI人狼チャットゲーム

## 概要
AIキャラクターと一緒に楽しむ人狼系ゲームアプリ。1人でもAIプレイヤーと対話しながら、人狼ゲームやその他のパーティーゲームを楽しめます。LINE風の親しみやすいチャットUIで、まるで友達と遊んでいるような体験を提供します。

## 主な特徴

### 🎮 ゲームモード
- **人狼ゲーム**: 本格的な人狼ゲームをAIキャラクターと楽しめる
- **サンレンタン**: お題に対する価値観の順位を当てるコミュニケーションゲーム
- **ito（イト）**: 数字を言葉で表現する協力型カードゲーム

### 💬 チャット機能
- **LINE風UI**: 馴染みのあるメッセージングインターフェース
- **リアルタイムチャット**: AIキャラクターとの自然な会話体験
- **キャラクターアイコン**: 各キャラクターの個性的なアイコン表示
- **タイピングインジケーター**: AIが考えている様子を表現

### 🎭 AIキャラクター
- **個性的な性格設定**: それぞれ異なる性格を持つAIプレイヤー
- **カスタムキャラクター**: 好きなアニメキャラクター（例：五条悟）でプレイ可能
- **自然な会話**: Google Gemini APIによる高度な対話生成

## 技術スタック

### フロントエンド
- **言語**: Swift
- **UIフレームワーク**: SwiftUI
- **アーキテクチャ**: MVVM

### AI・バックエンド
- **AI**: Google Gemini API (Firebase AI Logic SDK)
- **データベース**: Firebase Firestore（将来実装予定）
- **認証**: Firebase Auth（将来実装予定）

### ローカルストレージ
- **UserDefaults**: 設定情報の保存
- **CoreData**: ゲーム履歴・キャラクター情報の保存（予定）

## プロジェクト構造
```
AIWerewolfChat/
├── Views/                      # SwiftUI Views
│   ├── LaunchScreenView.swift # スプラッシュ画面
│   └── （その他のView）
├── ViewModels/                 # ObservableObject ViewModels
│   └── GameRoomViewModel.swift # ゲームルーム管理
├── Models/                     # データモデル
│   ├── Character.swift         # キャラクターモデル
│   ├── CharacterPersonality.swift # 性格設定
│   ├── CharacterStore.swift   # キャラクター管理
│   ├── GameType.swift          # ゲーム種別
│   ├── Message.swift           # メッセージモデル
│   └── WerewolfGame.swift      # 人狼ゲームロジック
├── Services/                   # ビジネスロジック
│   ├── GeminiService.swift    # AI API連携（予定）
│   └── GameEngine/            # ゲームロジック
│       ├── WerewolfEngine.swift
│       ├── SanRentanEngine.swift
│       └── ItoEngine.swift
└── Utilities/                  # ヘルパー関数
```

## ゲーム仕様

### 人狼ゲーム
- **プレイヤー数**: ユーザー1人 + AI 4〜8人
- **役職**: 
  - 村人
  - 人狼
  - 占い師
  - 騎士
  - その他特殊役職
- **ゲーム進行**: 
  1. 昼の議論フェーズ
  2. 投票フェーズ
  3. 夜のアクションフェーズ
- **勝利条件**: 標準的な人狼ルールに準拠

### サンレンタン
- **概要**: お題に対する価値観の1〜3位を当てるゲーム
- **プレイ形式**: 出題者の価値観を予想
- **得点システム**: 
  - サンレンタン（完全一致）: 6点
  - サンレンプク（選択肢のみ一致）: 4点
  - その他部分点あり

### ito（イト）
- **概要**: 1〜100の数字をテーマに沿った言葉で表現
- **ゲームモード**:
  - クモノイト: 協力して小さい順に出す
  - アカイイト: ペアで合計100を目指す
- **禁止事項**: 数字を直接言うことは禁止

## AI実装方針

### Gemini API統合
```swift
let characterPrompt = """
あなたは\(characterName)として振る舞ってください。
性格: \(personality)
口調: \(speechStyle)
特徴的な言い回し: \(catchPhrases)
現在のゲーム状況: \(gameContext)
"""
```

### キャラクター性格の実装
- システムプロンプトで各キャラクターの性格を定義
- ゲームコンテキストを含めて自然な応答を生成
- 役職に応じた戦略的な発言パターン

### コスト最適化
- 定型文はローカルに保存
- 重要な判断のみAPI使用
- レスポンスキャッシュの実装

## UI/UXデザイン

### チャットUI仕様
- メッセージバブル（送信/受信）
- 既読表示
- タイムスタンプ
- キャラクターアイコン表示
- タイピングインジケーター

### カラーテーマ
- **プライマリ**: 緑系（LINE風）
- **背景**: 薄いグレー
- **メッセージ**: 白（受信）、緑（送信）

## セットアップ

### 必要要件
- Xcode 15.0以上
- iOS 17.0以上
- Firebase プロジェクト
- Google Gemini API キー

### インストール手順
```bash
# プロジェクトのクローン
git clone [repository-url]

# プロジェクトディレクトリへ移動
cd AIWerewolfChat

# Xcodeでプロジェクトを開く
open AIWerewolfChat.xcodeproj
```

### Firebase設定
1. Firebase プロジェクトを作成
2. iOS アプリを追加
3. `GoogleService-Info.plist` をプロジェクトに追加
4. Firebase AI Logic SDK を有効化

## 開発コマンド
```bash
# プロジェクトビルド
xcodebuild -project AIWerewolfChat.xcodeproj -scheme AIWerewolfChat -configuration Debug

# シミュレーターで実行
xcodebuild -project AIWerewolfChat.xcodeproj -scheme AIWerewolfChat -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16'

# テスト実行
xcodebuild test -project AIWerewolfChat.xcodeproj -scheme AIWerewolfChat -sdk iphonesimulator
```

## ロードマップ

### Phase 1 (MVP)
- [x] 基本的なチャットUI実装
- [x] キャラクターモデル設計
- [ ] 人狼ゲーム基本ロジック実装
- [ ] Gemini API統合

### Phase 2 (機能拡張)
- [ ] サンレンタン実装
- [ ] ito実装
- [ ] カスタムキャラクター機能
- [ ] ゲーム履歴保存

### Phase 3 (品質向上)
- [ ] オンラインマルチプレイ
- [ ] ボイスチャット機能
- [ ] 実績システム
- [ ] プレイ統計機能

## ターゲットユーザー
- 10代〜20代の若者
- 人と会話がしたいが、相手がいない寂しい人たち
- AIチャットアプリに興味がある人
- 人狼ゲーム・パーティーゲーム好きな人

## 注意事項
- API使用量に注意（開発中は無料枠を活用）
- キャラクターの著作権に配慮
- 不適切な発言を防ぐセーフティ設定
- プライバシーポリシーの遵守

## ライセンス
このプロジェクトはMITライセンスの下で公開されています。

## 貢献
プルリクエストやイシューの報告はいつでも歓迎します。開発に参加する際は以下のガイドラインに従ってください：

1. コードスタイルはSwiftLintの設定に従う
2. 新機能には適切なテストを追加
3. コミットメッセージは分かりやすく記述