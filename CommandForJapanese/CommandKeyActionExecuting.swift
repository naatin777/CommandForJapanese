import Foundation

@MainActor
protocol CommandKeyActionExecuting: AnyObject {
    func execute(_ action: CommandKeyAction) throws
}
