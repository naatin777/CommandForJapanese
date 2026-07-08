import AppKit

final class SettingsWindowController: NSWindowController {
    init() {
        let viewController = SettingsViewController()

        let window = NSWindow(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: 560,
                height: 420
            ),
            styleMask: [
                .titled,
                .closable,
                .miniaturizable
            ],
            backing: .buffered,
            defer: false
        )

        window.title = "Settings"
        window.contentViewController = viewController
        window.center()
        window.isReleasedWhenClosed = false

        super.init(window: window)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}
