import Foundation
import GRDB
// Ensure the correct HolidayVariant is referenced

// Disambiguate HolidayVariant if multiple modules define it
// Replace `AppModule` with the module that defines your HolidayVariant if needed.
// typealias AppHolidayVariant = AppModule.HolidayVariant

public struct GRDBUserEnabledHolidays: Identifiable, Equatable, Hashable {
    public static func == (lhs: GRDBUserEnabledHolidays, rhs: GRDBUserEnabledHolidays) -> Bool {
        lhs.holidayVariant == rhs.holidayVariant
    }

    public private(set) var id: String
    public private(set) var holidayVariant: HolidayVariant
    public var isEnabled: Bool

    public init(holidayVariant: HolidayVariant, isEnabled: Bool = true) {
        self.id = holidayVariant.rawValue
        self.holidayVariant = holidayVariant
        self.isEnabled = isEnabled
    }

    mutating func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }

    // Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension GRDBUserEnabledHolidays: TableRecord {
    public static let databaseTableName = TableNames.userEnabledHolidays.rawValue
}

extension GRDBUserEnabledHolidays: Codable, FetchableRecord, PersistableRecord {
    enum CodingKeys: String, CodingKey { case id, holidayVariant, isEnabled }

    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let holidayVariant = Column(CodingKeys.holidayVariant)
        static let isEnabled = Column(CodingKeys.isEnabled)
    }

    // Codable synth with custom id logic
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let variant = try? container.decode(HolidayVariant.self, forKey: .holidayVariant) {
            self.holidayVariant = variant
            self.id = variant.rawValue
        } else {
            // Fallback: decode id as String and construct variant from rawValue
            let id = try container.decode(String.self, forKey: .id)
            guard let variant = HolidayVariant(rawValue: id) else {
                throw DecodingError.dataCorruptedError(forKey: .holidayVariant, in: container, debugDescription: "Invalid HolidayVariant rawValue: \(id)")
            }
            self.holidayVariant = variant
            self.id = id
        }
        self.isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(holidayVariant, forKey: .holidayVariant)
        try container.encode(isEnabled, forKey: .isEnabled)
    }

    // GRDB Row decoding to avoid ambiguous init(row:) errors
    public init(row: Row) {
        // Decode variant from stored raw value string
        if let raw: String = row[Columns.holidayVariant] as String?, let variant = HolidayVariant(rawValue: raw) {
            self.holidayVariant = variant
            self.id = raw
        } else if let rawId: String = row[Columns.id], let variant = HolidayVariant(rawValue: rawId) {
            self.id = rawId
            self.holidayVariant = variant
        } else {
            // As a last resort, default to custom
            self.holidayVariant = HolidayVariant.custom
            self.id = HolidayVariant.custom.rawValue
        }
        self.isEnabled = row[Columns.isEnabled] ?? true
    }

    public func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.holidayVariant] = holidayVariant.rawValue
        container[Columns.isEnabled] = isEnabled
    }
}

extension GRDBUserEnabledHolidays {
    static func new(holidayVariant: HolidayVariant, isEnabled: Bool = true) -> GRDBUserEnabledHolidays {
        GRDBUserEnabledHolidays(holidayVariant: holidayVariant, isEnabled: isEnabled)
    }
}

extension DerivableRequest<GRDBUserEnabledHolidays> {}

