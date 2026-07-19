@testable import CommandForJapanese
import Foundation

@MainActor
final class MockLoginItemService: LoginItemServicing {
    var isEnabled: Bool = false
    var receivedSetEnabledValues: [Bool] = []
    var errorToThrow: Error?
    
    func setEnabled(_ enabled: Bool) throws {
        receivedSetEnabledValues.append(enabled)
        
        if let errorToThrow {
            throw errorToThrow
        }
        
        isEnabled = enabled
    }
}
