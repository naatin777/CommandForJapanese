import Foundation

nonisolated enum InputSourceServiceError: LocalizedError {
    case eventCreationFailed

    var errorDescription: String? {
        switch self {
        case .eventCreationFailed:
            "Failed to create an input source key event."
        }
    }
}
