@testable import CommandForJapanese
import XCTest

@MainActor
final class SettingsControllerTests: XCTestCase {
    func test_init_loadsSettingsFromStore() {
        let expected = AppSettings(
            leftCommandAction: .showEmoji,
            rightCommandAction: .doNothing,
            bothCommandAction: .switchToEnglish,
            launchAtLogin: false
        )

        let store = MockAppSettingsStore(settings: expected)
        let loginItemService = MockLoginItemService(isEnabled: false)

        let controller = SettingsController(
            settingsStore: store,
            loginItemService: loginItemService
        )

        XCTAssertEqual(controller.settings, expected)
    }

    func test_updateLeftCommandAction_updatesAndSavesSettings() throws {
        let store = MockAppSettingsStore(settings: .default)
        let loginItemService = MockLoginItemService(isEnabled: false)

        let controller = SettingsController(
            settingsStore: store,
            loginItemService: loginItemService
        )

        try controller.updateLeftCommandAction(.showEmoji)

        XCTAssertEqual(controller.settings.leftCommandAction, .showEmoji)
        XCTAssertEqual(store.savedSettings.last?.leftCommandAction, .showEmoji)
    }

    func test_updateRightCommandAction_updatesAndSavesSettings() throws {
        let store = MockAppSettingsStore(settings: .default)
        let loginItemService = MockLoginItemService(isEnabled: false)

        let controller = SettingsController(
            settingsStore: store,
            loginItemService: loginItemService
        )

        try controller.updateRightCommandAction(.doNothing)

        XCTAssertEqual(controller.settings.rightCommandAction, .doNothing)
        XCTAssertEqual(store.savedSettings.last?.rightCommandAction, .doNothing)
    }

    func test_updateBothCommandAction_updatesAndSavesSettings() throws {
        let store = MockAppSettingsStore(settings: .default)
        let loginItemService = MockLoginItemService(isEnabled: false)

        let controller = SettingsController(
            settingsStore: store,
            loginItemService: loginItemService
        )

        try controller.updateBothCommandAction(.switchToJapanese)

        XCTAssertEqual(
            controller.settings.bothCommandAction,
            .switchToJapanese
        )

        XCTAssertEqual(
            store.savedSettings.last?.bothCommandAction,
            .switchToJapanese
        )
    }

    func test_updateLaunchAtLogin_enablesLoginItemAndSavesActualState() throws {
        let store = MockAppSettingsStore(settings: .default)
        let loginItemService = MockLoginItemService(isEnabled: false)

        let controller = SettingsController(
            settingsStore: store,
            loginItemService: loginItemService
        )

        try controller.updateLaunchAtLogin(true)

        XCTAssertEqual(loginItemService.receivedEnabledValues, [true])
        XCTAssertTrue(controller.settings.launchAtLogin)
        XCTAssertTrue(store.savedSettings.last?.launchAtLogin == true)
    }

    func test_updateLaunchAtLogin_whenServiceFails_restoresActualState() {
        let store = MockAppSettingsStore(settings: .default)

        let loginItemService = MockLoginItemService(
            isEnabled: false,
            errorToThrow: TestError.failed
        )

        let controller = SettingsController(
            settingsStore: store,
            loginItemService: loginItemService
        )

        XCTAssertThrowsError(
            try controller.updateLaunchAtLogin(true)
        )

        XCTAssertFalse(controller.settings.launchAtLogin)
        XCTAssertFalse(store.savedSettings.last?.launchAtLogin ?? true)
    }
}

private final class MockAppSettingsStore: AppSettingsStoring {
    private let loadedSettings: AppSettings

    private(set) var savedSettings: [AppSettings] = []
    private(set) var resetCallCount = 0

    init(settings: AppSettings) {
        loadedSettings = settings
    }

    func load() -> AppSettings {
        loadedSettings
    }

    func save(_ settings: AppSettings) throws {
        savedSettings.append(settings)
    }

    func reset() {
        resetCallCount += 1
    }
}

@MainActor
private final class MockLoginItemService: LoginItemServicing {
    private(set) var receivedEnabledValues: [Bool] = []

    var isEnabled: Bool
    var errorToThrow: Error?

    init(
        isEnabled: Bool,
        errorToThrow: Error? = nil
    ) {
        self.isEnabled = isEnabled
        self.errorToThrow = errorToThrow
    }

    func setEnabled(_ enabled: Bool) throws {
        receivedEnabledValues.append(enabled)

        if let errorToThrow {
            throw errorToThrow
        }

        isEnabled = enabled
    }
}

private enum TestError: Error {
    case failed
}
