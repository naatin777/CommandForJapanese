import Foundation

nonisolated enum CommandKeyAction: String, CaseIterable, Codable, Equatable {
    case switchToEnglish
    case switchToJapanese
    case showEmoji
    case doNothing

    var title: String {
        switch self {
        case .switchToEnglish:
            "Switch to English"
        case .switchToJapanese:
            "Switch to Japanese"
        case .showEmoji:
            "Show Emoji"
        case .doNothing:
            "Do Nothing"
        }
    }
}
