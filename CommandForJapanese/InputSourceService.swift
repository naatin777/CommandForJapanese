import CoreGraphics
import Foundation

@MainActor
final class InputSourceService: InputSourceServicing {
    private enum KeyCode {
        static let eisu: CGKeyCode = 102
        static let kana: CGKeyCode = 104
    }
    
    func switchToEnglish() throws {
        try postKey(keyCode: KeyCode.eisu)
    }
    
    func switchToJapanese() throws {
        try postKey(keyCode: KeyCode.kana)
    }
    
    private func postKey(
        keyCode: CGKeyCode
    ) throws {
        guard
            let keyDown = CGEvent(
                keyboardEventSource: nil,
                virtualKey: keyCode,
                keyDown: true
            ),
            let keyUp = CGEvent(
                keyboardEventSource: nil,
                virtualKey: keyCode,
                keyDown: false
            )
        else {
            throw InputSourceServiceError.eventCreationFailed
        }
        
        markAsSynthetic(keyDown)
        markAsSynthetic(keyUp)
        
        keyDown.post(tap: .cghidEventTap)
        keyUp.post(tap: .cghidEventTap)
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
