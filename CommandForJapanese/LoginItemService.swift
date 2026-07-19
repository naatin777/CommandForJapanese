import Foundation
import ServiceManagement

@MainActor
final class LoginItemService: LoginItemServicing {
    var isEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    func setEnabled(_ enabled: Bool) throws {
        if enabled {
            try enable()
        } else {
            try disable()
        }
    }

    private func enable() throws {
        guard SMAppService.mainApp.status != .enabled else {
            return
        }

        try SMAppService.mainApp.register()
    }

    private func disable() throws {
        guard SMAppService.mainApp.status != .notRegistered else {
            return
        }

        try SMAppService.mainApp.unregister()
    }
}
