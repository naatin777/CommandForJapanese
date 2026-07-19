nonisolated struct AppSettings: Equatable, Codable {
    var leftCommandAction: CommandKeyAction
    var rightCommandAction: CommandKeyAction
    var bothCommandAction: CommandKeyAction
    var launchAtLogin: Bool

    static let `default` = AppSettings(
        leftCommandAction: .switchToEnglish,
        rightCommandAction: .switchToJapanese,
        bothCommandAction: .showEmoji,
        launchAtLogin: false
    )

    func action(for trigger: CommandKeyTrigger) -> CommandKeyAction {
        switch trigger {
        case .left:
            leftCommandAction
        case .right:
            rightCommandAction
        case .both:
            bothCommandAction
        }
    }
}
