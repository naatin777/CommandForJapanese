import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?
    private var settingsWindowController: SettingsWindowController?
    private var actionExecutor: CommandKeyActionExecutor?
    private var commandKeyHandler: CommandKeyHandler?
    private var commandKeyEventMonitor: CommandKeyEventMonitor?

    func applicationDidFinishLaunching(_: Notification) {
        configureApplication()
        setupCommandKeyHandling()
        setupStatusBar()
        openSettings()
    }

    func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows _: Bool) -> Bool {
        openSettings()
        return true
    }

    private func configureApplication() {
        NSApp.setActivationPolicy(.accessory)
    }

    private func setupStatusBar() {
        statusBarController = StatusBarController(
            onOpenSettings: { [weak self] in
                self?.openSettings()
            },
            onQuit: {
                NSApp.terminate(nil)
            }
        )
    }

    private func openSettings() {
        if settingsWindowController == nil {
            settingsWindowController = SettingsWindowController()
        }

        settingsWindowController?.showWindow(nil)
        settingsWindowController?.window?.makeKeyAndOrderFront(nil)

        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func setupCommandKeyHandling() {
        let actionExecutor = CommandKeyActionExecutor(
            inputSourceService: InputSourceService(),
            emojiPresenter: EmojiPresenter()
        )
        
        let commandKeyHandler = CommandKeyHandler(
            settingsStore: AppSettingsStore(),
            actionExecutor: actionExecutor
        )
        
        let commandKeyEventMonitor = CommandKeyEventMonitor { event in
            do {
                try commandKeyHandler.handle(event)
            } catch {
                print("Failed to handle command key: \(error)")
            }
        }
        
        self.actionExecutor = actionExecutor
        self.commandKeyHandler = commandKeyHandler
        self.commandKeyEventMonitor = commandKeyEventMonitor
        
        do {
            try commandKeyEventMonitor.start()
        } catch {
            print("Failed to start command key monitor: \(error)")
        }
    }
}
