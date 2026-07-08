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
}
