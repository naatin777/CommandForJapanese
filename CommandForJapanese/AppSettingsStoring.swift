import Foundation

nonisolated protocol AppSettingsStoring: AnyObject {
    func load() -> AppSettings
    func save(_ settings: AppSettings) throws
    func reset()
}
