import Foundation
import GRDB

public struct GRDBUserEnabledHolidays: Identifiable, Equatable {
    
    public static func == (lhs: GRDBUserEnabledHolidays, rhs: GRDBUserEnabledHolidays) -> Bool {
        lhs.holidayVariant == rhs.holidayVariant
    }

    public private(set) var id: String
    public private(set) var holidayVariant: HolidayVariant
    public var isEnabled: Bool

    init(holidayVariant: HolidayVariant, isEnabled: Bool = true) {
        id = holidayVariant.rawValue
        self.holidayVariant = holidayVariant
        self.isEnabled = isEnabled
    }
    
    mutating func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
}

extension GRDBUserEnabledHolidays: TableRecord {
    public static let databaseTableName = TableNames.userEnabledHolidays.rawValue
}

extension GRDBUserEnabledHolidays {
    static func new(holidayVariant: HolidayVariant, isEnabled: Bool = true) -> GRDBUserEnabledHolidays {
        GRDBUserEnabledHolidays(holidayVariant: holidayVariant, isEnabled: isEnabled)
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBUserEnabledHolidays: Codable, FetchableRecord, PersistableRecord {
    public enum Columns {
        static let holidayVariant = Column(CodingKeys.holidayVariant)
        static let isEnabled = Column(CodingKeys.isEnabled)
    }
}

extension GRDBUserEnabledHolidays: Hashable {}

extension DerivableRequest<GRDBUserEnabledHolidays> {}
