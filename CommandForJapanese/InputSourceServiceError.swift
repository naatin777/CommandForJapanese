import Foundation

nonisolated enum InputSourceServiceError: LocalizedError {
    case inputSourceNotFound(language: String)
    case selectionFailed(language: String, status: OSStatus)
    
    var errorDescription: String? {
        switch self {
        case let .inputSourceNotFound(language):
            "\(language) input source was not found."
        case let .selectionFailed(language, status):
            "Failed to select \(language) input source. OSStatus: \(status)"
        }
    }
}
