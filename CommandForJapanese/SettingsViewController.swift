import AppKit

final class SettingsViewController: NSViewController {
    private let settingsStore: AppSettingsStore
    private var settings: AppSettings
    
    private let titleLabel = NSTextField(labelWithString: "Command for Japanese")
    private let descriptionLabel = NSTextField(labelWithString: "Configure command key behavior.")
    
    private let launchAtLoginCheckbox = NSButton(checkboxWithTitle: "Launch at login", target: nil, action: nil)

    private let leftCommandPopup = NSPopUpButton()
    private let rightCommandPopup = NSPopUpButton()
    private let bothCommandPopup = NSPopUpButton()

    private let leftCommandActions: [CommandKeyAction] = [
        .switchToEnglish,
        .switchToJapanese,
        .showEmoji,
        .doNothing
    ]

    private let rightCommandActions: [CommandKeyAction] = [
        .switchToJapanese,
        .switchToEnglish,
        .showEmoji,
        .doNothing
    ]

    private let bothCommandActions: [CommandKeyAction] = [
        .showEmoji,
        .switchToEnglish,
        .switchToJapanese,
        .doNothing
    ]
    
    init(settingsStore: AppSettingsStore = AppSettingsStore()) {
        self.settingsStore = settingsStore
        self.settings = settingsStore.load()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        applySettingsToViews()
        setupActions()
        setupLayout()
    }

    func setupViews() {
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)

        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .secondaryLabelColor

        leftCommandPopup.addItems(withTitles: leftCommandActions.map(\.title))
        rightCommandPopup.addItems(withTitles: rightCommandActions.map(\.title))
        bothCommandPopup.addItems(withTitles: bothCommandActions.map(\.title))
    }
    
    private func applySettingsToViews() {
        selectAction(
            settings.leftCommandAction,
            in: leftCommandPopup,
            from: leftCommandActions
        )
        
        selectAction(
            settings.rightCommandAction,
            in: rightCommandPopup,
            from: rightCommandActions
        )
        
        selectAction(
            settings.bothCommandAction,
            in: bothCommandPopup,
            from: bothCommandActions
        )
        
        launchAtLoginCheckbox.state = settings.launchAtLogin ? .on : .off
    }

    private func selectAction(
        _ action: CommandKeyAction,
        in popup: NSPopUpButton,
        from actions: [CommandKeyAction]
    ) {
        guard let index = actions.firstIndex(of: action) else {
            popup.selectItem(at: 0)
            return
        }

        popup.selectItem(at: index)
    }
    
    private func setupActions() {
        launchAtLoginCheckbox.target = self
        launchAtLoginCheckbox.action = #selector(launchAtLoginChanged)

        leftCommandPopup.target = self
        leftCommandPopup.action = #selector(leftCommandPopupChanged)

        rightCommandPopup.target = self
        rightCommandPopup.action = #selector(rightCommandPopupChanged)

        bothCommandPopup.target = self
        bothCommandPopup.action = #selector(bothCommandPopupChanged)
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

    private func selectedLeftCommandAction() -> CommandKeyAction {
        leftCommandActions[leftCommandPopup.indexOfSelectedItem]
    }

    private func selectedRightCommandAction() -> CommandKeyAction {
        rightCommandActions[rightCommandPopup.indexOfSelectedItem]
    }

    private func selectedBothCommandAction() -> CommandKeyAction {
        bothCommandActions[bothCommandPopup.indexOfSelectedItem]
    }

    @objc private func launchAtLoginChanged() {
        settings.launchAtLogin = launchAtLoginCheckbox.state == .on
        saveSettings()
    }

    @objc private func leftCommandPopupChanged() {
        settings.leftCommandAction = selectedLeftCommandAction()
        saveSettings()
    }

    @objc private func rightCommandPopupChanged() {
        settings.rightCommandAction = selectedRightCommandAction()
        saveSettings()
    }

    @objc private func bothCommandPopupChanged() {
        settings.bothCommandAction = selectedBothCommandAction()
        saveSettings()
    }
    
    private func saveSettings() {
        do {
            try settingsStore.save(settings)
        } catch {
            showSaveError(error)
        }
    }
    
    private func showSaveError(_ error: Error) {
        let alert = NSAlert()
        alert.messageText = "Failed to save settings"
        alert.informativeText = error.localizedDescription
        alert.alertStyle = .warning
        alert.runModal()
    }
}
