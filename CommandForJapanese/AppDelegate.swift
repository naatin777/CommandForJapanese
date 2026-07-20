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
        let inputPermissionService =
            InputMonitoringPermissionService()

        let accessibilityPermissionService =
            AccessibilityPermissionService()

        print(
            "Input Monitoring:",
            inputPermissionService.isGranted
        )

        print(
            "Accessibility:",
            accessibilityPermissionService.isTrusted
        )

        guard inputPermissionService.isGranted else {
            inputPermissionService.requestPermission()
            print("Input Monitoring permission is required.")
            return
        }

        guard accessibilityPermissionService.isTrusted else {
            accessibilityPermissionService.requestPermission()
            print("Accessibility permission is required.")
            return
        }

        setupCommandKeyEventMonitor()
    }

    private func setupCommandKeyEventMonitor() {
        let actionExecutor = CommandKeyActionExecutor(
            inputSourceService: InputSourceService(),
            emojiPresenter: EmojiPresenter()
        )

        let handler = CommandKeyHandler(
            settingsStore: AppSettingsStore(),
            actionExecutor: actionExecutor
        )

        let monitor = CommandKeyEventMonitor { event in
            do {
                try handler.handle(event)
            } catch {
                print("Command key handling failed:", error)
            }
        }

        commandKeyHandler = handler
        commandKeyEventMonitor = monitor

        do {
            try monitor.start()
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
