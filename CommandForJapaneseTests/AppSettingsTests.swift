@testable import CommandForJapanese
import XCTest

final class AppSettingsTests: XCTestCase {
    func test_defaultSettings_hasExpectedValues() {
        let settings = AppSettings.default

        XCTAssertEqual(settings.leftCommandAction, .switchToEnglish)
        XCTAssertEqual(settings.rightCommandAction, .switchToJapanese)
        XCTAssertEqual(settings.bothCommandAction, .showEmoji)
        XCTAssertFalse(settings.launchAtLogin)
    }

    func test_appSettings_canBeEncodedAndDecoded() throws {
        let original = AppSettings(
            leftCommandAction: .showEmoji,
            rightCommandAction: .doNothing,
            bothCommandAction: .switchToJapanese,
            launchAtLogin: true
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(AppSettings.self, from: data)

        XCTAssertEqual(decoded, original)
    }

    func test_actionForLeftTrigger_returnsLeftCommandAction() {
        let settings = AppSettings(
            leftCommandAction: .showEmoji,
            rightCommandAction: .switchToJapanese,
            bothCommandAction: .doNothing,
            launchAtLogin: false
        )

        let action = settings.action(for: .left)

        XCTAssertEqual(action, .showEmoji)
    }

    func test_actionForRightTrigger_returnsRightCommandAction() {
        let settings = AppSettings(
            leftCommandAction: .showEmoji,
            rightCommandAction: .doNothing,
            bothCommandAction: .switchToEnglish,
            launchAtLogin: false
        )

        let action = settings.action(for: .right)

        XCTAssertEqual(action, .doNothing)
    }

    func test_actionForBothTrigger_returnsBothCommandAction() {
        let settings = AppSettings(
            leftCommandAction: .showEmoji,
            rightCommandAction: .switchToJapanese,
            bothCommandAction: .switchToEnglish,
            launchAtLogin: false
        )

        let action = settings.action(for: .both)

        XCTAssertEqual(action, .switchToEnglish)
    }
}
