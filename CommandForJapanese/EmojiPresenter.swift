import AppKit

@MainActor
final class EmojiPresenter: EmojiPresenting {
    func showEmoji() {
        NSApp.orderFrontCharacterPalette(nil)
    }
}
