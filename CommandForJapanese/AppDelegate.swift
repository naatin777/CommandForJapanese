import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?
    private var settingsWindowController: SettingsWindowController?
    private var actionExecutor: CommandKeyActionExecutor?

    func applicationDidFinishLaunching(_: Notification) {
        configureApplication()
        setupActionExecutor()
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
    
    private func setupActionExecutor() {
        let executor = CommandKeyActionExecutor(
            inputSourceService: TemporaryInputSourceService(),
            emojiPresenter: EmojiPresenter()
        )
        
        actionExecutor = executor
        try? executor.execute(.showEmoji)
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
}
