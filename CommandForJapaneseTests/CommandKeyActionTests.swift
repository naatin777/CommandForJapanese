@testable import CommandForJapanese
import XCTest

final class CommandKeyActionTests: XCTestCase {
    func test_title_returnsExpectedDisplayTitle() {
        XCTAssertEqual(CommandKeyAction.switchToEnglish.title, "Switch to English")
        XCTAssertEqual(CommandKeyAction.switchToJapanese.title, "Switch to Japanese")
        XCTAssertEqual(CommandKeyAction.showEmoji.title, "Show Emoji")
        XCTAssertEqual(CommandKeyAction.doNothing.title, "Do Nothing")
    }

    func test_allCases_containsExpectedActions() {
        XCTAssertEqual(
            CommandKeyAction.allCases,
            [
                .switchToEnglish,
                .switchToJapanese,
                .showEmoji,
                .doNothing
            ]
        )
    }

    func test_rawValue_isStableForPersistence() {
        XCTAssertEqual(CommandKeyAction.switchToEnglish.rawValue, "switchToEnglish")
        XCTAssertEqual(CommandKeyAction.switchToJapanese.rawValue, "switchToJapanese")
        XCTAssertEqual(CommandKeyAction.showEmoji.rawValue, "showEmoji")
        XCTAssertEqual(CommandKeyAction.doNothing.rawValue, "doNothing")
    }
}
