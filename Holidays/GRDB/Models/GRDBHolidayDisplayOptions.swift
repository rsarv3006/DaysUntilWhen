import Foundation
import GRDB

public struct GRDBHolidayDisplayOptions: Identifiable, Equatable {
    public static func == (lhs: GRDBHolidayDisplayOptions, rhs: GRDBHolidayDisplayOptions) -> Bool {
        lhs.id == rhs.id
    }

    public private(set) var id: HolidayVariant
    public var backgroundOptionId: String?
    public var textOptionId: String?

    init(id: HolidayVariant) {
        self.id = id
        backgroundOptionId = nil
        textOptionId = nil
    }

    public mutating func updateDisplayOptions(backgroundOptionId: String?, textOptionId: String?) {
        self.backgroundOptionId = backgroundOptionId
        self.textOptionId = textOptionId
    }
}

extension GRDBHolidayDisplayOptions: TableRecord {
    public static let databaseTableName = TableNames.holidayDisplayOptions.rawValue
}

extension GRDBHolidayDisplayOptions {
    static func new(id: HolidayVariant) -> GRDBHolidayDisplayOptions {
        GRDBHolidayDisplayOptions(id: id)
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBHolidayDisplayOptions: Codable, FetchableRecord, PersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let backgroundOptionId = Column(CodingKeys.backgroundOptionId)
        static let textOptionId = Column(CodingKeys.textOptionId)
    }
}

// MARK: - Relationship Helper Methods

public extension GRDBHolidayDisplayOptions {
    /// Fetches the associated BackgroundOption from the database
    func backgroundOption(in db: Database) throws -> GRDBBackgroundOption? {
        guard let backgroundOptionId = backgroundOptionId else { return nil }
        return try GRDBBackgroundOption.fetchOne(db, key: backgroundOptionId)
    }

    /// Fetches the associated TextOption from the database
    func textOption(in db: Database) throws -> GRDBTextOption? {
        guard let textOptionId = textOptionId else { return nil }
        return try GRDBTextOption.fetchOne(db, key: textOptionId)
    }

    /// Fetches both related options in a single database access
    func getDisplayOptions(in db: Database) throws -> (backgroundOption: GRDBBackgroundOption?, textOption: GRDBTextOption?) {
        let backgroundOption = try self.backgroundOption(in: db)
        let textOption = try self.textOption(in: db)
        return (backgroundOption, textOption)
    }
}

extension DerivableRequest<GRDBHolidayDisplayOptions> {}
