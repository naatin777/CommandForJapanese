# CommandForJapanese

Commandキーの単押しで、英数・かなの切り替えや絵文字パレットの表示を行うmacOSメニューバーアプリです。

このプロジェクトは、[⌘英かな（cmd-eikana）](https://github.com/iMasanari/cmd-eikana)を参考に、macOSアプリ開発とAppKitの学習を目的として個人で再実装しているクローンです。元プロジェクトおよび作者の方とは関係ありません。

## 機能

初期設定では、次の操作を割り当てています。

| 操作 | 動作 |
| --- | --- |
| 左Commandキーを単押し | 英数入力へ切り替え |
| 右Commandキーを単押し | 日本語入力へ切り替え |
| 左右のCommandキーを同時押し | 絵文字パレットを表示 |

設定画面から、左右および同時押しの動作を変更できます。

- 英数入力へ切り替え
- 日本語入力へ切り替え
- 絵文字パレットを表示
- 何もしない
- ログイン時に起動

通常のCommandショートカットと組み合わせた場合は、単押しとして扱いません。

## 必要な権限

キーボード入力の監視と疑似キーイベントの送信に、次の権限が必要です。

- 入力監視
- アクセシビリティ

初回起動時に許可を求められたら、macOSの「システム設定 > プライバシーとセキュリティ」から `CommandForJapanese` を有効にしてください。権限を変更した後は、アプリを一度終了して再起動します。

## ビルドとインストール

1. Xcodeで `CommandForJapanese.xcodeproj` を開きます。
2. 実行先に `My Mac` を選びます。
3. Release構成でビルドします。
4. 生成された `CommandForJapanese.app` を `/Applications` にコピーします。

ターミナルからビルドする場合は、リポジトリ直下で次を実行します。

```bash
xcodebuild \
  -project CommandForJapanese.xcodeproj \
  -scheme CommandForJapanese \
  -configuration Release \
  -derivedDataPath .build
```

生成物は次の場所にあります。

```text
.build/Build/Products/Release/CommandForJapanese.app
```

## 開発

フォーマット、Lint、テストは次のコマンドで実行できます。

```bash
Scripts/format.sh && Scripts/lint.sh && Scripts/test.sh
```

主に以下のAPIを学習するために作っています。

- AppKit
- Core Graphicsのキーボードイベント
- Core FoundationのRunLoop
- Accessibility API
- macOSの入力監視権限

## 参考プロジェクト

- [iMasanari/cmd-eikana](https://github.com/iMasanari/cmd-eikana)

本プロジェクトのアイデアと基本的な操作体系は、⌘英かなを参考にしています。コードは学習目的で独自に実装しています。

## 状態

学習中の個人プロジェクトです。動作や仕様は今後変更される可能性があります。
