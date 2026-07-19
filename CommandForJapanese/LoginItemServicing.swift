import Foundation

@MainActor
protocol LoginItemServicing: AnyObject {
    var isEnabled: Bool { get }
    
    func setEnabled(_ enabled: Bool) throws
}
