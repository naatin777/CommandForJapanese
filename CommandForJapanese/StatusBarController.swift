import AppKit

final class StatusBarController: NSObject {
    private let statusItem: NSStatusItem
    private let menuFactory: StatusBarMenuFactory

    override init() {
        statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.variableLength
        )
        menuFactory = StatusBarMenuFactory()

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
        print("Open settings")
    }

    @objc func quit() {
        NSApp.terminate(nil)
    }
}
