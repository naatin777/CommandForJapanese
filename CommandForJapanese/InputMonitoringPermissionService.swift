import CoreGraphics
import Foundation

@MainActor
final class InputMonitoringPermissionService {
    var isGranted: Bool {
        CGPreflightListenEventAccess()
    }

    @discardableResult
    func requestPermission() -> Bool {
        CGRequestListenEventAccess()
    }
}
