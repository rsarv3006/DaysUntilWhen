import Foundation
import GRDB
import SwiftUI

public struct GRDBBackgroundOption: Identifiable, Equatable {
    public static func == (lhs: GRDBBackgroundOption, rhs: GRDBBackgroundOption) -> Bool {
        lhs.id == rhs.id
    }

    public private(set) var id: String
    public private(set) var type: BackgroundOptionType
    public private(set) var optionName: String
    public private(set) var holidayFilter: [HolidayVariant]

    public var image: Image? {
        guard type == .image else { return nil }
        return Image(id)
    }

    public var color: Color? {
        guard type == .color else { return nil }
        return Color(id)
    }

    init(id: String, type: BackgroundOptionType, optionName: String = "", holidayFilter: [HolidayVariant] = []) {
        self.id = id
        self.type = type
        self.optionName = optionName.isEmpty ? id : optionName
        self.holidayFilter = holidayFilter
    }
}

extension GRDBBackgroundOption: TableRecord {
    public static let databaseTableName = TableNames.backgroundOption.rawValue
}

extension GRDBBackgroundOption {
    static func new(id: String, type: BackgroundOptionType, optionName: String = "", holidayFilter: [HolidayVariant] = []) -> GRDBBackgroundOption {
        GRDBBackgroundOption(id: id, type: type, optionName: optionName, holidayFilter: holidayFilter)
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBBackgroundOption: Codable, FetchableRecord, PersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let type = Column(CodingKeys.type)
        static let optionName = Column(CodingKeys.optionName)
        static let holidayFilter = Column(CodingKeys.holidayFilter)
    }
}

extension GRDBBackgroundOption: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension DerivableRequest<GRDBBackgroundOption> {}
