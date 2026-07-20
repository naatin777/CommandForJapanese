import Foundation

@MainActor
final class CommandKeyHandler {
    private let settingsStore: any AppSettingsStoring
    private let actionExecutor: any CommandKeyActionExecuting

    private var stateMachine = CommandKeyStateMachine()

    init(
        settingsStore: any AppSettingsStoring,
        actionExecutor: any CommandKeyActionExecuting
    ) {
        self.settingsStore = settingsStore
        self.actionExecutor = actionExecutor
    }

    func handle(_ event: CommandKeyEvent) throws {
        guard let trigger = stateMachine.handle(event) else { return }

        let settings = settingsStore.load()
        let action = settings.action(for: trigger)

        try actionExecutor.execute(action)
    }
}
