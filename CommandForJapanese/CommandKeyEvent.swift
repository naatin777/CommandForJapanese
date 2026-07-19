nonisolated enum CommandKeyEvent: Equatable {
    case keyDown(CommandKeySide)
    case keyUp(CommandKeySide)
    case otherKeyDown
}
