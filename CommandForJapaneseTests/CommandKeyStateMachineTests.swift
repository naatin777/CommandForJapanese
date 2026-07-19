@testable import CommandForJapanese
import XCTest

final class CommandKeyStateMachineTests: XCTestCase {
    func test_leftCommandTap_returnsLeftTrigger() {
        var machine = CommandKeyStateMachine()

        XCTAssertNil(machine.handle(.keyDown(.left)))

        let trigger = machine.handle(.keyUp(.left))

        XCTAssertEqual(trigger, .left)
    }

    func test_rightCommandTap_returnsRightTrigger() {
        var machine = CommandKeyStateMachine()

        XCTAssertNil(machine.handle(.keyDown(.right)))

        let trigger = machine.handle(.keyUp(.right))

        XCTAssertEqual(trigger, .right)
    }

    func test_bothCommands_returnsBothTriggerAfterBothAreReleased() {
        var machine = CommandKeyStateMachine()

        XCTAssertNil(machine.handle(.keyDown(.left)))
        XCTAssertNil(machine.handle(.keyDown(.right)))
        XCTAssertNil(machine.handle(.keyUp(.left)))

        let trigger = machine.handle(.keyUp(.right))

        XCTAssertEqual(trigger, .both)
    }

    func test_bothCommands_inReverseOrder_returnsBothTrigger() {
        var machine = CommandKeyStateMachine()

        XCTAssertNil(machine.handle(.keyDown(.right)))
        XCTAssertNil(machine.handle(.keyDown(.left)))
        XCTAssertNil(machine.handle(.keyUp(.right)))

        let trigger = machine.handle(.keyUp(.left))

        XCTAssertEqual(trigger, .both)
    }

    func test_commandWithAnotherKey_returnsNoTrigger() {
        var machine = CommandKeyStateMachine()

        XCTAssertNil(machine.handle(.keyDown(.left)))
        XCTAssertNil(machine.handle(.otherKeyDown))

        let trigger = machine.handle(.keyUp(.left))

        XCTAssertNil(trigger)
    }

    func test_stateIsResetAfterLeftCommandTap() {
        var machine = CommandKeyStateMachine()

        _ = machine.handle(.keyDown(.left))
        XCTAssertEqual(machine.handle(.keyUp(.left)), .left)

        _ = machine.handle(.keyDown(.right))
        XCTAssertEqual(machine.handle(.keyUp(.right)), .right)
    }

    func test_stateIsResetAfterCancelledShortcut() {
        var machine = CommandKeyStateMachine()

        _ = machine.handle(.keyDown(.left))
        _ = machine.handle(.otherKeyDown)
        XCTAssertNil(machine.handle(.keyUp(.left)))

        _ = machine.handle(.keyDown(.right))
        XCTAssertEqual(machine.handle(.keyUp(.right)), .right)
    }
}
