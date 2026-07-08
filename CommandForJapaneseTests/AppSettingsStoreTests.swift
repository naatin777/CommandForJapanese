@testable import CommandForJapanese
import XCTest

final class AppSettingsStoreTests: XCTestCase {
    private var suiteName: String!
    private var userDefaults: UserDefaults!
    private var store: AppSettingsStore!

    override func setUp() {
        super.setUp()

        suiteName = "AppSettingsStoreTests-\(UUID().uuidString)"
        userDefaults = UserDefaults(suiteName: suiteName)
        store = AppSettingsStore(userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: suiteName)

        store = nil
        userDefaults = nil
        suiteName = nil

        super.tearDown()
    }

    func test_load_returnsDefaultSettingsWhenNoSavedDataExists() {
        let settings = store.load()

        XCTAssertEqual(settings, .default)
    }

    func test_saveAndLoad_returnsSavedSettings() throws {
        let expected = AppSettings(
            leftCommandAction: .showEmoji,
            rightCommandAction: .doNothing,
            bothCommandAction: .switchToJapanese,
            launchAtLogin: true
        )

        try store.save(expected)

        let actual = store.load()

        XCTAssertEqual(actual, expected)
    }

    func test_reset_removesSavedSettings() throws {
        let settings = AppSettings(
            leftCommandAction: .showEmoji,
            rightCommandAction: .doNothing,
            bothCommandAction: .switchToJapanese,
            launchAtLogin: true
        )

        try store.save(settings)
        store.reset()

        XCTAssertEqual(store.load(), .default)
    }

    func test_load_returnsDefaultSettingsWhenSavedDataIsInvalid() {
        userDefaults.set(
            Data("invalid json".utf8),
            forKey: "appSettings"
        )

        let settings = store.load()

        XCTAssertEqual(settings, .default)
    }
}
