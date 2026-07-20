import Foundation

nonisolated enum CommandKeyEventMonitorError: LocalizedError {
    case eventTapCreationFailed

    var errorDescription: String? {
        switch self {
        case .eventTapCreationFailed:
            "Failed to create keyboard event monitor."
        }
    }
}
