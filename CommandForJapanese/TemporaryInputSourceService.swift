import Foundation

@MainActor
final class TemporaryInputSourceService: InputSourceServicing {
    func switchToEnglish() throws {
        print("Switch to English")
    }
    
    func switchToJapanese() throws {
        print("Switch to Japanese")
    }
}
