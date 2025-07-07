import Foundation
import GRDB

public struct GRDBHoliday: Identifiable, Equatable {
    public static func == (lhs: GRDBHoliday, rhs: GRDBHoliday) -> Bool {
        lhs.id == rhs.id
    }

    public private(set) var id: TimeInterval
    public private(set) var variant: HolidayVariant
    public private(set) var name: String
    public private(set) var holidayDescription: String
    public private(set) var dayOfGreeting: String
    public private(set) var icon: String

    init(id: TimeInterval, variant: HolidayVariant, name: String, holidayDescription: String, dayOfGreeting: String, icon: String) {
        self.id = id
        self.variant = variant
        self.name = name
        self.holidayDescription = holidayDescription
        self.dayOfGreeting = dayOfGreeting
        self.icon = icon
    }

    public var date: Date? {
        Date(timeIntervalSince1970: id)
    }
}

extension GRDBHoliday: TableRecord {
    public static let databaseTableName = TableNames.holiday.rawValue
}

extension GRDBHoliday {
    static func new(id: TimeInterval, variant: HolidayVariant, name: String, holidayDescription: String, dayOfGreeting: String, icon: String) -> GRDBHoliday {
        GRDBHoliday(id: id, variant: variant, name: name, holidayDescription: holidayDescription, dayOfGreeting: dayOfGreeting, icon: icon)
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBHoliday: Codable, FetchableRecord, PersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let variant = Column(CodingKeys.variant)
        static let name = Column(CodingKeys.name)
        static let holidayDescription = Column(CodingKeys.holidayDescription)
        static let dayOfGreeting = Column(CodingKeys.dayOfGreeting)
    }
}

extension GRDBHoliday: Hashable {}

extension DerivableRequest<GRDBHoliday> {}
