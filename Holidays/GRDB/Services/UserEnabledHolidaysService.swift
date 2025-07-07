import Foundation
import GRDB

public extension AppDatabase {
    func populateUserEnabledHolidays() throws {
        try dbWriter.write { db in
            let allHolidays = try self.getAllHolidays(in: db)

            let allUserEnabledHolidayEntityVariants = try GRDBUserEnabledHolidays.all().fetchAll(db).map { option in
                option.holidayVariant
            }

            for holiday in allHolidays {
                if !allUserEnabledHolidayEntityVariants.contains(holiday.variant) {
                    let new = GRDBUserEnabledHolidays.new(holidayVariant: holiday.variant)
                    try new.upsert(db)
                }
            }
        }
    }
    
    func updateUserEnabledHolidays(_ userEnabledHolidays: [GRDBUserEnabledHolidays]) throws {
        try dbWriter.write { db in
            try userEnabledHolidays.forEach { userEnableHolidayEntity in
                try userEnableHolidayEntity.update(db)
            }
        }
        
    }
    
    func getAllUserEnableHolidayEntities() throws -> [GRDBUserEnabledHolidays] {
        try dbWriter.read { db in
            return try self.getAllUserEnableHolidayEntities(in: db)
        }
    }
    
    func getAllUserEnableHolidayEntities(in db: Database) throws -> [GRDBUserEnabledHolidays] {
        return try GRDBUserEnabledHolidays.all().fetchAll(db)
    }
}
