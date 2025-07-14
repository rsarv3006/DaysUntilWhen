import Foundation
import GRDB

public struct GRDBFtueEvent: Identifiable, Equatable {
    public static func == (lhs: GRDBFtueEvent, rhs: GRDBFtueEvent) -> Bool {
        lhs.id == rhs.id
    }

    public private(set) var id: String
    public private(set) var hasCompleted: Bool

    init(id: String) {
        self.id = id
        self.hasCompleted = false
    }

    mutating func markAsCompleted() {
        self.hasCompleted = true
    }
    
}

extension GRDBFtueEvent: TableRecord {
    public static let databaseTableName = TableNames.ftueEvents.rawValue
}

extension GRDBFtueEvent {
    static func new(eventName: String) -> GRDBFtueEvent {
        GRDBFtueEvent(id: eventName)
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBFtueEvent: Codable, FetchableRecord, PersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let hasCompleted = Column(CodingKeys.hasCompleted)
    }
}

extension GRDBFtueEvent: Hashable {}

extension DerivableRequest<GRDBFtueEvent> {}

