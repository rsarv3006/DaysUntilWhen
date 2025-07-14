import Foundation
import GRDB

public enum FtueEvents: String, CaseIterable, Codable, DatabaseValueConvertible {
    public typealias RawValue = String
    
    case reloadTextOptionsFtue = "reloadOptionsFtue-20250713"
}

extension AppDatabase {
    func createFtueEvents() throws {
        try dbWriter.write { db in
            if try GRDBFtueEvent.fetchOne(db, key: FtueEvents.reloadTextOptionsFtue.rawValue) == nil {
                let ftueEvent = GRDBFtueEvent.new(eventName: FtueEvents.reloadTextOptionsFtue.rawValue)
                try ftueEvent.insert(db)
            }
        }
    }
    
    func hasFtueBeenCompleted(_ event: FtueEvents) throws -> Bool {
        try dbWriter.read { db in
            try GRDBFtueEvent.fetchOne(db, key: event.rawValue)?.hasCompleted ?? false
        }
    }
    
    func markFtueEventAsCompleted(_ event: FtueEvents) throws {
        try dbWriter.write { db in
            guard var ftueEvent = try GRDBFtueEvent.fetchOne(db, key: event.rawValue) else {
                return
            }
            ftueEvent.markAsCompleted()
            try ftueEvent.update(db)
        }
    }
}
