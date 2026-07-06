import AppKit

struct StatusBarMenuActions {
    let openSettings: Selector
    let quit: Selector
}

final class StatusBarMenuFactory {
    func makeMenu(target: AnyObject, actions: StatusBarMenuActions) -> NSMenu {
        let menu = NSMenu()

        let settingsItem = NSMenuItem(
            title: "Settings...",
            action: actions.openSettings,
            keyEquivalent: ","
        )
        let quitItem = NSMenuItem(
            title: "Quit",
            action: actions.quit,
            keyEquivalent: "q"
        )

        settingsItem.target = target
        quitItem.target = target

        menu.addItem(settingsItem)
        menu.addItem(.separator())
        menu.addItem(quitItem)

        return menu
    }
}
