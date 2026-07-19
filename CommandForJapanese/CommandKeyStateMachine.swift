nonisolated struct CommandKeyStateMachine {
    private var leftIsPressed = false
    private var rightIsPressed = false

    private var leftWasPressed = false
    private var rightWasPressed = false

    private var otherKeyWasPressed = false
    private var bothTriggered = false

    mutating func handle(_ event: CommandKeyEvent) -> CommandKeyTrigger? {
        switch event {
        case let .keyDown(side):
            handleKeyDown(side)

        case let .keyUp(side):
            return handleKeyUp(side)

        case .otherKeyDown:
            otherKeyWasPressed = true
        }

        return nil
    }

    private mutating func handleKeyDown(_ side: CommandKeySide) {
        switch side {
        case .left:
            leftIsPressed = true
            leftWasPressed = true

        case .right:
            rightIsPressed = true
            rightWasPressed = true
        }

        if leftIsPressed, rightIsPressed {
            bothTriggered = true
        }
    }

    private mutating func handleKeyUp(
        _ side: CommandKeySide
    ) -> CommandKeyTrigger? {
        switch side {
        case .left:
            leftIsPressed = false

        case .right:
            rightIsPressed = false
        }

        guard !otherKeyWasPressed else {
            resetIfNeeded()
            return nil
        }

        if bothTriggered {
            guard !leftIsPressed, !rightIsPressed else {
                return nil
            }

            reset()
            return .both
        }

        let trigger: CommandKeyTrigger? = switch side {
        case .left:
            leftWasPressed ? .left : nil

        case .right:
            rightWasPressed ? .right : nil
        }

        resetIfNeeded()
        return trigger
    }

    private mutating func resetIfNeeded() {
        guard !leftIsPressed, !rightIsPressed else {
            return
        }

        reset()
    }

    private mutating func reset() {
        leftIsPressed = false
        rightIsPressed = false
        leftWasPressed = false
        rightWasPressed = false
        otherKeyWasPressed = false
        bothTriggered = false
    }
}
