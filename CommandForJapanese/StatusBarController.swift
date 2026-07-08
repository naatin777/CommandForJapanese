import AppKit

final class StatusBarController: NSObject {
    private let statusItem: NSStatusItem
    private let menuFactory: StatusBarMenuFactory

    private let onOpenSettings: () -> Void
    private let onQuit: () -> Void

    init(
        onOpenSettings: @escaping () -> Void,
        onQuit: @escaping () -> Void
    ) {
        statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.variableLength
        )
        menuFactory = StatusBarMenuFactory()
        self.onOpenSettings = onOpenSettings
        self.onQuit = onQuit

        super.init()

        setupStatusItem()
    }

    private func setupStatusItem() {
        if let button = statusItem.button {
            button.title = "⌘"
            button.toolTip = "Command for Japanese"
        }

        statusItem.menu = menuFactory.makeMenu(
            target: self,
            actions: StatusBarMenuActions(
                openSettings: #selector(openSettings),
                quit: #selector(quit)
            )
        )
    }

    @objc func openSettings() {
        onOpenSettings()
    }

    @objc func quit() {
        onQuit()
    }
}
