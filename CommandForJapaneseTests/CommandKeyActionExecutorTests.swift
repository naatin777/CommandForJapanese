@testable import CommandForJapanese
import XCTest

@MainActor
final class CommandKeyActionExecutorTests: XCTestCase {
    func test_executeSwitchToEnglish_callsInputSourceService() throws {
        let inputSourceService = MockInputSourceService()
        let emojiPresenter = MockEmojiPresenter()

        let executor = CommandKeyActionExecutor(
            inputSourceService: inputSourceService,
            emojiPresenter: emojiPresenter
        )

        try executor.execute(.switchToEnglish)

        XCTAssertEqual(inputSourceService.switchToEnglishCallCount, 1)
        XCTAssertEqual(inputSourceService.switchToJapaneseCallCount, 0)
        XCTAssertEqual(emojiPresenter.showEmojiCallCount, 0)
    }

    func test_executeSwitchToJapanese_callsInputSourceService() throws {
        let inputSourceService = MockInputSourceService()
        let emojiPresenter = MockEmojiPresenter()

        let executor = CommandKeyActionExecutor(
            inputSourceService: inputSourceService,
            emojiPresenter: emojiPresenter
        )

        try executor.execute(.switchToJapanese)

        XCTAssertEqual(inputSourceService.switchToEnglishCallCount, 0)
        XCTAssertEqual(inputSourceService.switchToJapaneseCallCount, 1)
        XCTAssertEqual(emojiPresenter.showEmojiCallCount, 0)
    }

    func test_executeShowEmoji_callsEmojiPresenter() throws {
        let inputSourceService = MockInputSourceService()
        let emojiPresenter = MockEmojiPresenter()

        let executor = CommandKeyActionExecutor(
            inputSourceService: inputSourceService,
            emojiPresenter: emojiPresenter
        )

        try executor.execute(.showEmoji)

        XCTAssertEqual(inputSourceService.switchToEnglishCallCount, 0)
        XCTAssertEqual(inputSourceService.switchToJapaneseCallCount, 0)
        XCTAssertEqual(emojiPresenter.showEmojiCallCount, 1)
    }

    func test_executeDoNothing_callsNoServices() throws {
        let inputSourceService = MockInputSourceService()
        let emojiPresenter = MockEmojiPresenter()

        let executor = CommandKeyActionExecutor(
            inputSourceService: inputSourceService,
            emojiPresenter: emojiPresenter
        )

        try executor.execute(.doNothing)

        XCTAssertEqual(inputSourceService.switchToEnglishCallCount, 0)
        XCTAssertEqual(inputSourceService.switchToJapaneseCallCount, 0)
        XCTAssertEqual(emojiPresenter.showEmojiCallCount, 0)
    }

    func test_executeSwitchToEnglish_whenServiceFails_throwsError() {
        let inputSourceService = MockInputSourceService()
        inputSourceService.errorToThrow = TestError.failed

        let executor = CommandKeyActionExecutor(
            inputSourceService: inputSourceService,
            emojiPresenter: MockEmojiPresenter()
        )

        XCTAssertThrowsError(
            try executor.execute(.switchToEnglish)
        )
    }
}

@MainActor
private final class MockInputSourceService: InputSourceServicing {
    private(set) var switchToEnglishCallCount = 0
    private(set) var switchToJapaneseCallCount = 0

    var errorToThrow: Error?

    func switchToEnglish() throws {
        switchToEnglishCallCount += 1

        if let errorToThrow {
            throw errorToThrow
        }
    }

    func switchToJapanese() throws {
        switchToJapaneseCallCount += 1

        if let errorToThrow {
            throw errorToThrow
        }
    }
}

@MainActor
private final class MockEmojiPresenter: EmojiPresenting {
    private(set) var showEmojiCallCount = 0

    func showEmoji() {
        showEmojiCallCount += 1
    }
}

private enum TestError: Error {
    case failed
}
