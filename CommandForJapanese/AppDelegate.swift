import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?
    private var settingsWindowController: SettingsWindowController?

    private var commandKeyHandler: CommandKeyHandler?
    private var commandKeyEventMonitor: CommandKeyEventMonitor?

    func applicationDidFinishLaunching(_: Notification) {
        configureApplication()
        setupCommandKeyHandling()
        setupStatusBar()
        openSettings()
    }

    func applicationWillTerminate(_: Notification) {
        commandKeyEventMonitor?.stop()
    }

    func applicationShouldHandleReopen(
        _: NSApplication,
        hasVisibleWindows _: Bool
    ) -> Bool {
        openSettings()
        return true
    }

    private func configureApplication() {
        NSApp.setActivationPolicy(.accessory)
    }

    private func setupCommandKeyHandling() {
        let permissionService = AccessibilityPermissionService()

        guard permissionService.isTrusted else {
            permissionService.requestPermission()
            print("Accessibility permission is required.")
            return
        }

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
                print("Command key handling failed:", error)
            }
        }

        self.commandKeyHandler = commandKeyHandler
        self.commandKeyEventMonitor = commandKeyEventMonitor

        do {
            try commandKeyEventMonitor.start()
        } catch {
            print("Command key monitor failed to start:", error)
        }
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
