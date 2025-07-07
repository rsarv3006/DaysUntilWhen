import Foundation
import GRDB
import SwiftUI

public struct GRDBTextOption: Identifiable, Equatable {
    public static func == (lhs: GRDBTextOption, rhs: GRDBTextOption) -> Bool {
        lhs.id == rhs.id
    }

    public private(set) var id: String
    public private(set) var optionName: String
    public private(set) var holidayFilter: [HolidayVariant]

    public var color: Color? {
        return Color(id)
    }

    init(id: String, optionName: String = "", holidayFilter: [HolidayVariant] = []) {
        self.id = id
        self.optionName = optionName.isEmpty ? id : optionName
        self.holidayFilter = holidayFilter
    }
}

extension GRDBTextOption: TableRecord {
    public static let databaseTableName = TableNames.textOption.rawValue
}

extension GRDBTextOption {
    static func new(id: String, optionName: String = "", holidayFilter: [HolidayVariant] = []) -> GRDBTextOption {
        GRDBTextOption(id: id, optionName: optionName, holidayFilter: holidayFilter)
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBTextOption: Codable, FetchableRecord, PersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let optionName = Column(CodingKeys.optionName)
        static let holidayFilter = Column(CodingKeys.holidayFilter)
    }
}

extension GRDBTextOption: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension DerivableRequest<GRDBTextOption> {}
