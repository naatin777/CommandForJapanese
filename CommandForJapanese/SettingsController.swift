import Foundation

@MainActor
final class SettingsController {
    private let settingsStore: any AppSettingsStoring
    private let loginItemService: any LoginItemServicing
    
    private(set) var settings: AppSettings
    
    init(
        settingsStore: any AppSettingsStoring,
        loginItemService: any LoginItemServicing
    ) {
        self.settingsStore = settingsStore
        self.loginItemService = loginItemService
        self.settings = settingsStore.load()
            
        syncLaunchAtLoginFromSystem()
    }
    
    var isLaunchAtLoginEnabled: Bool {
        loginItemService.isEnabled
    }
    
    func updateLeftCommandAction(_ action: CommandKeyAction) throws {
        settings.leftCommandAction = action
        try settingsStore.save(settings)
    }
    
    func updateRightCommandAction(_ action: CommandKeyAction) throws {
        settings.rightCommandAction = action
        try settingsStore.save(settings)
    }

    func updateBothCommandAction(_ action: CommandKeyAction) throws {
        settings.bothCommandAction = action
        try settingsStore.save(settings)
    }

    func updateLaunchAtLogin(_ shouldEnable: Bool) throws {
        do {
            try loginItemService.setEnabled(shouldEnable)
            settings.launchAtLogin = loginItemService.isEnabled
            try settingsStore.save(settings)
        } catch {
            settings.launchAtLogin = loginItemService.isEnabled
            try? settingsStore.save(settings)
            
            throw error
        }
    }
    
    private func syncLaunchAtLoginFromSystem() {
        settings.launchAtLogin = loginItemService.isEnabled
        
        try? settingsStore.save(settings)
    }
}
