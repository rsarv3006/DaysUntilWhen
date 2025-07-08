import Foundation
import GRDB
import os.log

public struct AppDatabase {
    init(_ dbWriter: DatabasePool) throws {
        self.dbWriter = dbWriter
        databasePool = dbWriter

        try migrator.migrate(dbWriter)
    }
    
    init(_ dbWriter: DatabaseQueue) throws {
        self.dbWriter = dbWriter
        databasePool = nil
        
        try migrator.migrate(dbWriter)
    }

    let dbWriter: any DatabaseWriter
    let databasePool: DatabasePool?
}

// MARK: - Database Configuration

extension AppDatabase {
    private static let sqlLogger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SQL")

    public static func makeConfiguration(_ base: Configuration = Configuration()) -> Configuration {
        var config = base

        if ProcessInfo.processInfo.environment["SQL_TRACE"] != nil {
            config.prepareDatabase { db in
                db.trace {
                    os_log("%{public}@", log: sqlLogger, type: .debug, String(describing: $0))
                }
            }
        }

        #if DEBUG
            config.publicStatementArguments = true
        #endif

        return config
    }
}

// MARK: - Database Migrations

extension AppDatabase {
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        #if DEBUG
            migrator.eraseDatabaseOnSchemaChange = false
        #endif

        migrator.registerMigration("initial") { db in
            try db.create(table: TableNames.holiday.rawValue) { t in
                t.primaryKey("id", .double).notNull() // TimeInterval
                t.column("variant", .text).notNull() // HolidayVariant as string
                t.column("name", .text).notNull()
                t.column("holidayDescription", .text).notNull()
                t.column("dayOfGreeting", .text).notNull()
                t.column("icon", .text).notNull()
            }

            // New user preferences table for enabled/disabled holidays
            try db.create(table: TableNames.userEnabledHolidays.rawValue) { t in
                t.primaryKey("id", .text).notNull()
                t.column("holidayVariant", .text).notNull()
                t.column("isEnabled", .boolean).notNull().defaults(to: true)
            }

            // Background options lookup table
            try db.create(table: TableNames.backgroundOption.rawValue) { t in
                t.primaryKey("id", .text).notNull()
                t.column("type", .text).notNull() // BackgroundOptionType as string
                t.column("optionName", .text).notNull()
                t.column("holidayFilter", .jsonText).notNull() // [HolidayVariant] as JSON
            }

            // Text options lookup table
            try db.create(table: TableNames.textOption.rawValue) { t in
                t.primaryKey("id", .text).notNull()
                t.column("optionName", .text).notNull()
                t.column("holidayFilter", .jsonText).notNull() // [HolidayVariant] as JSON
            }

            // Holiday display preferences (user customizations)
            try db.create(table: TableNames.holidayDisplayOptions.rawValue) { t in
                t.primaryKey("id", .text).notNull()
                t.column("backgroundOptionId", .text)
                    .references(TableNames.backgroundOption.rawValue, onDelete: .setNull)
                t.column("textOptionId", .text)
                    .references(TableNames.textOption.rawValue, onDelete: .setNull)
            }

            // Add indexes for common queries
            try db.create(index: "idx_holidays_date", on: TableNames.holiday.rawValue, columns: ["id"])
            try db.create(index: "idx_holidays_variant", on: TableNames.holiday.rawValue, columns: ["variant"])
            try db.create(index: "idx_enabled_holidays", on: TableNames.userEnabledHolidays.rawValue, columns: ["isEnabled"])
        }

        // Migrations for future application versions will be inserted here:
        // migrator.registerMigration(...) { db in
        //     ...
        // }

        migrator.registerMigration("20240811:1 - Add Status Notification Schedule - update default") { _ in
//            try db.alter(table: TableNames.notificationSchedule.rawValue) { t in
//                t.add(column: "status", .text).notNull().defaults(to: "inactive")
//            }
//
//            try db.execute(sql: """
//                UPDATE notificationSchedule
//                SET status = 'active'
//                WHERE name = 'Default' OR name = 'Standard'
//            """)
//
//            try db.execute(literal: """
//                UPDATE notificationSchedule
//                SET name = 'Standard'
//                WHERE name = 'Default' OR name = 'Standard'
//            """)
        }

        return migrator
    }
}

extension AppDatabase {
    var reader: DatabaseReader {
        dbWriter
    }
}
