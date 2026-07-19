import Foundation

final nonisolated class AppSettingsStore: AppSettingsStoring {
    private let userDefaults: UserDefaults
    private let key = "appSettings"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func load() -> AppSettings {
        guard let data = userDefaults.data(forKey: key) else {
            return .default
        }

        do {
            return try JSONDecoder().decode(AppSettings.self, from: data)
        } catch {
            return .default
        }
    }

    func save(_ settings: AppSettings) throws {
        let data = try JSONEncoder().encode(settings)
        userDefaults.set(data, forKey: key)
    }

    func reset() {
        userDefaults.removeObject(forKey: key)
    }
}
