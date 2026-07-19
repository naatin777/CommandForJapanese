import Foundation

@MainActor
protocol InputSourceServicing: AnyObject {
    func switchToEnglish() throws
    func switchToJapanese() throws
}
