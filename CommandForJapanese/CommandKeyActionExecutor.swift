import Foundation

@MainActor
final class CommandKeyActionExecutor {
    private let inputSourceService: any InputSourceServicing
    private let emojiPresenter: any EmojiPresenting

    init(
        inputSourceService: any InputSourceServicing,
        emojiPresenter: any EmojiPresenting
    ) {
        self.inputSourceService = inputSourceService
        self.emojiPresenter = emojiPresenter
    }

    func execute(_ action: CommandKeyAction) throws {
        switch action {
        case .switchToEnglish:
            try inputSourceService.switchToEnglish()
        case .switchToJapanese:
            try inputSourceService.switchToJapanese()
        case .showEmoji:
            emojiPresenter.showEmoji()
        case .doNothing:
            break
        }
    }
}
