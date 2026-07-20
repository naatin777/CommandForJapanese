@testable import CommandForJapanese
import XCTest

@MainActor
final class CommandKeyHandlerTests: XCTestCase {
    func test_leftCommandTap_executesConfiguredLeftAction() throws {
        let settings = AppSettings(
            leftCommandAction: .showEmoji,
            rightCommandAction: .switchToJapanese,
            bothCommandAction: .doNothing,
            launchAtLogin: false
        )

        let store = MockAppSettingsStore(settings: settings)
        let executor = MockCommandKeyActionExecutor()

        let handler = CommandKeyHandler(
            settingsStore: store,
            actionExecutor: executor
        )

        try handler.handle(.keyDown(.left))
        try handler.handle(.keyUp(.left))

        XCTAssertEqual(executor.receivedActions, [.showEmoji])
    }

    func test_rightCommandTap_executesConfiguredRightAction() throws {
        let settings = AppSettings(
            leftCommandAction: .showEmoji,
            rightCommandAction: .switchToJapanese,
            bothCommandAction: .doNothing,
            launchAtLogin: false
        )

        let store = MockAppSettingsStore(settings: settings)
        let executor = MockCommandKeyActionExecutor()

        let handler = CommandKeyHandler(
            settingsStore: store,
            actionExecutor: executor
        )

        try handler.handle(.keyDown(.right))
        try handler.handle(.keyUp(.right))

        XCTAssertEqual(
            executor.receivedActions,
            [.switchToJapanese]
        )
    }

    func test_bothCommands_executesConfiguredBothAction() throws {
        let settings = AppSettings(
            leftCommandAction: .switchToEnglish,
            rightCommandAction: .switchToJapanese,
            bothCommandAction: .showEmoji,
            launchAtLogin: false
        )

        let store = MockAppSettingsStore(settings: settings)
        let executor = MockCommandKeyActionExecutor()

        let handler = CommandKeyHandler(
            settingsStore: store,
            actionExecutor: executor
        )

        try handler.handle(.keyDown(.left))
        try handler.handle(.keyDown(.right))
        try handler.handle(.keyUp(.left))
        try handler.handle(.keyUp(.right))

        XCTAssertEqual(executor.receivedActions, [.showEmoji])
    }

    func test_commandShortcut_executesNoAction() throws {
        let store = MockAppSettingsStore(settings: .default)
        let executor = MockCommandKeyActionExecutor()

        let handler = CommandKeyHandler(
            settingsStore: store,
            actionExecutor: executor
        )

        try handler.handle(.keyDown(.left))
        try handler.handle(.otherKeyDown)
        try handler.handle(.keyUp(.left))

        XCTAssertTrue(executor.receivedActions.isEmpty)
    }

    func test_eachCompletedTrigger_loadsLatestSettings() throws {
        let store = MockAppSettingsStore(settings: .default)
        let executor = MockCommandKeyActionExecutor()

        let handler = CommandKeyHandler(
            settingsStore: store,
            actionExecutor: executor
        )

        try handler.handle(.keyDown(.left))
        try handler.handle(.keyUp(.left))

        store.settings.leftCommandAction = .showEmoji

        try handler.handle(.keyDown(.left))
        try handler.handle(.keyUp(.left))

        XCTAssertEqual(
            executor.receivedActions,
            [
                .switchToEnglish,
                .showEmoji
            ]
        )
    }

    func test_whenExecutorFails_handleThrowsError() {
        let store = MockAppSettingsStore(settings: .default)
        let executor = MockCommandKeyActionExecutor()
        executor.errorToThrow = TestError.failed

        let handler = CommandKeyHandler(
            settingsStore: store,
            actionExecutor: executor
        )

        XCTAssertNoThrow(
            try handler.handle(.keyDown(.left))
        )

        XCTAssertThrowsError(
            try handler.handle(.keyUp(.left))
        )
    }
}

private nonisolated final class MockAppSettingsStore: AppSettingsStoring {
    var settings: AppSettings

    init(settings: AppSettings) {
        self.settings = settings
    }

    func load() -> AppSettings {
        settings
    }

    func save(_ settings: AppSettings) throws {
        self.settings = settings
    }

    func reset() {
        settings = .default
    }
}

@MainActor
private final class MockCommandKeyActionExecutor:
    CommandKeyActionExecuting
{
    private(set) var receivedActions: [CommandKeyAction] = []

    var errorToThrow: Error?

    func execute(_ action: CommandKeyAction) throws {
        receivedActions.append(action)

        if let errorToThrow {
            throw errorToThrow
        }
    }
}

private enum TestError: Error {
    case failed
}
