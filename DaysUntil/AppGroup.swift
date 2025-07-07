import Foundation

public enum AppGroup: String {
    case daysUntilWhen = "group.rjs.app.dev.daysUntilWhen"
    
    public var containerURL: URL {
        switch self {
        case .daysUntilWhen:
            return FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: self.rawValue)!
        }
    }
    
    public var defaults: UserDefaults {
        switch self {
        case .daysUntilWhen:
            return UserDefaults(suiteName: self.rawValue)!
        }
    }
}
