import Foundation
import GRDB

// MARK: - User enabled holiday record

/// Represents a user‑enabled holiday. The table stores the holiday id and whether the user wants a notification.
@objcMembers
public final class GRDBUserEnabledHolidays: TableRecord, Codable {
    public static let databaseTableName = "user_enabled_holidays"

    public var id: String
    public var holidayId: TimeInterval
    public var isEnabled: Bool

    public init(id: String, holidayId: TimeInterval, isEnabled: Bool) {
        self.id = id
        self.holidayId = holidayId
        self.isEnabled = isEnabled
    }

    enum CodingKeys: String, CodingKey, ColumnExpression {
        case id, holidayId, isEnabled
    }
}

// MARK: - Migration helpers

extension AppDatabase {
    func getAllUserEnableHolidayEntities(in db: Database) throws -> [GRDBUserEnabledHolidays] {
        try GRDBUserEnabledHolidays.fetchAll(db)
    }

    func getAllUserEnableHolidayEntities() throws -> [GRDBUserEnabledHolidays] {
        try dbWriter.read { db in try self.getAllUserEnableHolidayEntities(in: db) }
    }

    func updateUserEnabledHolidays(_ entities: [GRDBUserEnabledHolidays]) throws {
        try dbWriter.write { db in
            try entities.forEach { try $0.save(db) }
        }
    }
}
