import CoreGraphics
import Foundation

@MainActor
final class EmojiPresenter: EmojiPresenting {
    private enum KeyCode {
        static let space: CGKeyCode = 49
    }

    func showEmoji() {
        guard
            let source = CGEventSource(stateID: .privateState),
            let keyDown = CGEvent(
                keyboardEventSource: source,
                virtualKey: KeyCode.space,
                keyDown: true
            ),
            let keyUp = CGEvent(
                keyboardEventSource: source,
                virtualKey: KeyCode.space,
                keyDown: false
            )
        else {
            return
        }

        let flags: CGEventFlags = [
            .maskControl,
            .maskCommand,
        ]

        keyDown.flags = flags
        keyUp.flags = flags

        markAsSynthetic(keyDown)
        markAsSynthetic(keyUp)

        keyDown.post(tap: .cgSessionEventTap)
        keyUp.post(tap: .cgSessionEventTap)
    }

    private func markAsSynthetic(
        _ event: CGEvent
    ) {
        event.setIntegerValueField(
            .eventSourceUserData,
            value: SyntheticEvent.marker
        )
    }
}
