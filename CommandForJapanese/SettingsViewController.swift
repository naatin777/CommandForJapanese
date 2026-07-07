import AppKit

final class SettingsViewController: NSViewController {
    private let titleLabel = NSTextField(labelWithString: "Command for Japanese")
    private let descriptionLabel = NSTextField(labelWithString: "Configure command key behavior.")
    private let launchAtLoginCheckbox = NSButton(checkboxWithTitle: "Launch at login", target: nil, action: nil)
    
    private let leftCommandPopup = NSPopUpButton()
    private let rightCommandPopup = NSPopUpButton()
    private let bothCommandPopup = NSPopUpButton()
    
    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .secondaryLabelColor
        
        leftCommandPopup.addItems(withTitles: [
            "Switch to English",
            "Switch to Japanese",
            "Show Emoji",
            "Do Nothing"
        ])

        rightCommandPopup.addItems(withTitles: [
            "Switch to Japanese",
            "Switch to English",
            "Show Emoji",
            "Do Nothing"
        ])

        bothCommandPopup.addItems(withTitles: [
            "Show Emoji",
            "Switch to English",
            "Switch to Japanese",
            "Do Nothing"
        ])
    }
    
    private func setupLayout() {
        let rootStack = NSStackView()
        rootStack.orientation = .vertical
        rootStack.alignment = .leading
        rootStack.spacing = 20
        rootStack.translatesAutoresizingMaskIntoConstraints = false

        let headerStack = makeHeaderStack()
        let shortcutGrid = makeShortcutGrid()

        rootStack.addArrangedSubview(headerStack)
        rootStack.addArrangedSubview(makeSeparator())
        rootStack.addArrangedSubview(shortcutGrid)
        rootStack.addArrangedSubview(makeSeparator())
        rootStack.addArrangedSubview(launchAtLoginCheckbox)

        view.addSubview(rootStack)

        NSLayoutConstraint.activate([
            rootStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            rootStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            rootStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            rootStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -28)
        ])
    }
    
    private func makeHeaderStack() -> NSStackView {
        let stack = NSStackView(views: [
            titleLabel,
            descriptionLabel
        ])

        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 6

        return stack
    }
    
    private func makeShortcutGrid() -> NSGridView {
        let grid = NSGridView(views: [
            [
                NSTextField(labelWithString: "Left Command"),
                leftCommandPopup
            ],
            [
                NSTextField(labelWithString: "Right Command"),
                rightCommandPopup
            ],
            [
                NSTextField(labelWithString: "Both Commands"),
                bothCommandPopup
            ]
        ])
        
        grid.rowSpacing = 12
        grid.columnSpacing = 12
        grid.xPlacement = .leading
        grid.yPlacement = .center
        
        return grid
    }

    
    private func makeSeparator() -> NSBox {
        let separator = NSBox()
        separator.boxType = .separator
        return separator
    }
}
