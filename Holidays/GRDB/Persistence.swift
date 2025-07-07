import Foundation
import GRDB

public extension AppDatabase {
    /// The database for the application
    static let shared = makeShared()

    private static func makeShared() -> AppDatabase {
        do {
            // Use App Group container for shared database access between app and widget
            let appGroup = AppGroup.daysUntilWhen
            let directoryURL = appGroup.containerURL.appendingPathComponent("Database", isDirectory: true)

            // Support for tests: delete the database if requested
            if CommandLine.arguments.contains("-reset") {
                try? FileManager.default.removeItem(at: directoryURL)
            }

            // Create the database folder if needed
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)

            // Open or create the database
            let databaseURL = directoryURL.appendingPathComponent("db.sqlite")
            NSLog("Database stored at \(databaseURL.path)")
            let dbPool = try DatabasePool(
                path: databaseURL.path,
                // Use default AppDatabase configuration
                configuration: AppDatabase.makeConfiguration()
            )

            // Create the AppDatabase
            let appDatabase = try AppDatabase(dbPool)

            try appDatabase.populateBackgroundOptions()
            try appDatabase.populateTextOptions()
            try appDatabase.populateDisplayOptions()
            try appDatabase.populateInitialHolidays()
            try appDatabase.populateUserEnabledHolidays()
            
            try appDatabase.deleteHolidaysInThePast()

            return appDatabase
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            //
            // Typical reasons for an error here include:
            // * The parent directory cannot be created, or disallows writing.
            // * The database is not accessible, due to permissions or data protection when the device is locked.
            // * The device is out of space.
            // * The database could not be migrated to its latest schema version.
            // Check the error message to determine what the actual problem was.
            fatalError("Unresolved error \(error)")
        }
    }

    /// Creates an empty database for SwiftUI previews
    static func empty() -> AppDatabase {
        // Connect to an in-memory database
        // See https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/databaseconnections
        let dbQueue = try! DatabaseQueue(configuration: AppDatabase.makeConfiguration())
        return try! AppDatabase(dbQueue)
    }

    /// Creates a database full of random players for SwiftUI previews
    static func random() -> AppDatabase {
        let appDatabase = empty()

        //        try! appDatabase.createConfig()
        //        try! appDatabase.createDefaultNotificationSchedules()
        //        try! appDatabase.createDefaultScheduleTemplate()
        //
        //        try! appDatabase.addBedtimesFromSchedule()

        return appDatabase
    }
}
