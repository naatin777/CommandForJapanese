import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?

    func applicationDidFinishLaunching(_: Notification) {
        configureApplication()
        setupStatusBar()
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
        print("Open settings from AppDelegate")
    }
}
