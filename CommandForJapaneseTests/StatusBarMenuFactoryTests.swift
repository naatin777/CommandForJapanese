import AppKit
@testable import CommandForJapanese
import XCTest

final class StatusBarMenuFactoryTests: XCTestCase {
    func test_makeMenu_containsExpectedItems() {
        let factory = StatusBarMenuFactory()
        let target = DummyTarget()

        let menu = factory.makeMenu(
            target: target,
            actions: dummyActions
        )

        XCTAssertEqual(menu.items.count, 3)
        XCTAssertEqual(menu.items[0].title, "Settings...")
        XCTAssertTrue(menu.items[1].isSeparatorItem)
        XCTAssertEqual(menu.items[2].title, "Quit")
    }

    func test_settingsItem_hasExpectedKeyEquivalent() {
        let factory = StatusBarMenuFactory()
        let target = DummyTarget()

        let menu = factory.makeMenu(
            target: target,
            actions: dummyActions
        )

        XCTAssertEqual(menu.items[0].keyEquivalent, ",")
    }

    func test_quitItem_hasExpectedKeyEquivalent() {
        let factory = StatusBarMenuFactory()
        let target = DummyTarget()

        let menu = factory.makeMenu(
            target: target,
            actions: dummyActions
        )

        XCTAssertEqual(menu.items[2].keyEquivalent, "q")
    }

    func test_menuItems_useProvidedTarget() {
        let factory = StatusBarMenuFactory()
        let target = DummyTarget()

        let menu = factory.makeMenu(
            target: target,
            actions: dummyActions
        )

        XCTAssertTrue(menu.items[0].target === target)
        XCTAssertTrue(menu.items[2].target === target)
    }

    func test_menuItems_haveExpectedActions() {
        let factory = StatusBarMenuFactory()
        let target = DummyTarget()

        let menu = factory.makeMenu(
            target: target,
            actions: dummyActions
        )

        XCTAssertEqual(
            menu.items[0].action,
            #selector(DummyTarget.openSettings)
        )
        XCTAssertEqual(
            menu.items[2].action,
            #selector(DummyTarget.quit)
        )
    }

    private var dummyActions: StatusBarMenuActions {
        StatusBarMenuActions(
            openSettings: #selector(DummyTarget.openSettings),
            quit: #selector(DummyTarget.quit)
        )
    }
}

private final class DummyTarget: NSObject {
    @objc func openSettings() {}

    @objc func quit() {}
}
