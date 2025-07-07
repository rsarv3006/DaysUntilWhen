
import Foundation
import GRDB

extension AppDatabase {
    func getAllHolidays(in db: Database) throws -> [GRDBHoliday] {
        return try GRDBHoliday.fetchAll(db)
    }

    func getAllHolidays() throws -> [GRDBHoliday] {
        try dbWriter.read { db in
            try self.getAllHolidays(in: db)
        }
    }

    func deleteHolidaysInThePast() throws {
        try dbWriter.write { db in
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let todayTimeInterval = today.timeIntervalSince1970

        try GRDBHoliday
            .filter(GRDBHoliday.Columns.id < todayTimeInterval)
            .deleteAll(db)
            
        }
    }

    func populateInitialHolidays() throws {
        try dbWriter.write { db in
            let loadedHolidays = try self.getAllHolidays(in: db)

            let christmasDate = try Date.christmasFor(year: Date.currentYear)
            let newYearDate = try Date.newYearsFor(year: Date.currentYear)
            let valentinesDate = try Date.valentinesFor(year: Date.currentYear)
            let easterDate = try Date.easterFor(year: Date.currentYear)
            let mothersDayDate = try Date.mothersDayFor(year: Date.currentYear)
            let halloweenDate = try Date.halloweenFor(year: Date.currentYear)
            let thanksgiving = try Date.thanksgivingFor(year: Date.currentYear)
            let memorialDay = try Date.memorialDayFor(year: Date.currentYear)
            let fourthOfJuly = try Date.fourthOfJulyFor(year: Date.currentYear)
            let fathersDay = try Date.fathersDayFor(year: Date.currentYear)

            let christmasNextYearDate = try Date.christmasFor(year: Date.currentYear + 1)
            let newYearNextYearDate = try Date.newYearsFor(year: Date.currentYear + 1)
            let valentinesNextYearDate = try Date.valentinesFor(year: Date.currentYear + 1)
            let easterNextYearDate = try Date.easterFor(year: Date.currentYear + 1)
            let mothersDayNextYearDate = try Date.mothersDayFor(year: Date.currentYear + 1)
            let halloweenNextYearDate = try Date.halloweenFor(year: Date.currentYear + 1)
            let thanksgivingNextYearDate = try Date.thanksgivingFor(year: Date.currentYear + 1)
            let memorialDayNextYearDate = try Date.memorialDayFor(year: Date.currentYear + 1)
            let fourthOfJulyNextYearDate = try Date.fourthOfJulyFor(year: Date.currentYear + 1)
            let fathersDayNextYearDate = try Date.fathersDayFor(year: Date.currentYear + 1)

            let holidaysToInsert = [
                HolidayCreation.createChristmasHolidayModel(christmasTimeInterval: christmasDate.timeIntervalSince1970),
                HolidayCreation.createNewYearHolidayModel(newYearTimeInterval: newYearDate.timeIntervalSince1970),
                HolidayCreation.createValentinesHolidayModel(valentinesTimerInterval: valentinesDate.timeIntervalSince1970),
                HolidayCreation.createEasterHolidayModel(easterTimeInterval: easterDate.timeIntervalSince1970),
                HolidayCreation.createMothersDayHolidayModel(mothersTimeInterval: mothersDayDate.timeIntervalSince1970),
                HolidayCreation.createHalloweenHolidayModel(halloweenTimeInterval: halloweenDate.timeIntervalSince1970),
                HolidayCreation.createThanksgivingHolidayModel(thanksgivingTimeInterval: thanksgiving.timeIntervalSince1970),
                HolidayCreation.createFourthOfJulyHolidayModel(fourthOfJulyTimeInterval: fourthOfJuly.timeIntervalSince1970),
                HolidayCreation.createFathersDayHolidayModel(fathersDayTimeInterval: fathersDay.timeIntervalSince1970),

                HolidayCreation.createChristmasHolidayModel(christmasTimeInterval: christmasNextYearDate.timeIntervalSince1970),
                HolidayCreation.createNewYearHolidayModel(newYearTimeInterval: newYearNextYearDate.timeIntervalSince1970),
                HolidayCreation.createValentinesHolidayModel(valentinesTimerInterval: valentinesNextYearDate.timeIntervalSince1970),
                HolidayCreation.createEasterHolidayModel(easterTimeInterval: easterNextYearDate.timeIntervalSince1970),
                HolidayCreation.createMothersDayHolidayModel(mothersTimeInterval: mothersDayNextYearDate.timeIntervalSince1970),
                HolidayCreation.createHalloweenHolidayModel(halloweenTimeInterval: halloweenNextYearDate.timeIntervalSince1970),
                HolidayCreation.createThanksgivingHolidayModel(thanksgivingTimeInterval: thanksgivingNextYearDate.timeIntervalSince1970),
                HolidayCreation.createFourthOfJulyHolidayModel(fourthOfJulyTimeInterval: fourthOfJulyNextYearDate.timeIntervalSince1970),
                HolidayCreation.createFathersDayHolidayModel(fathersDayTimeInterval: fathersDayNextYearDate.timeIntervalSince1970),
            ]

            for holiday in holidaysToInsert {
                let isHolidayLoaded = loadedHolidays.contains(where: { $0.variant == holiday.variant && $0.id == holiday.id })

                if !isHolidayLoaded {
                    try holiday.insert(db)
                }
            }
        }
    }
}
