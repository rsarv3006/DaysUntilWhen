import Foundation

enum HolidaysUtils {
    static func getSelectedHoliday(holidays: [GRDBHoliday], date: Date, userEnabledHolidays: [GRDBUserEnabledHolidays]) -> GRDBHoliday? {
        let sortedHolidays = holidays.sorted {
            guard let date1 = $0.date, let date2 = $1.date else {
                return false
            }
            return date1 < date2
        }

        for holiday in sortedHolidays {
            let userEnabledHolidayEntity = userEnabledHolidays.first { $0.holidayVariant == holiday.variant}
            
            if let holidayDate = holiday.date, userEnabledHolidayEntity?.isEnabled ?? true, holidayDate > date {
                return holiday
            }
        }

        return nil
    }

    static func daysUntil(_ startDate: Date, _ futureDate: Date?) -> Int? {
        guard let futureDate else { return nil }
        let calendar = Calendar.current

        let today = calendar.startOfDay(for: startDate)
        let futureDay = calendar.startOfDay(for: futureDate)

        let components = calendar.dateComponents([.day], from: today, to: futureDay)

        return components.day
    }

    static func isHolidayTodayOrInFuture(_ currentDate: Date, _ holidayDate: Date?) -> Bool {
        guard let holidayDate else { return false }
        
        let calendar = Calendar.current
        let currentDay = calendar.startOfDay(for: currentDate)
        let holidayDay = calendar.startOfDay(for: holidayDate)
        
        return currentDay <= holidayDay
    }

    static func getHolidayDate(_ currentDate: Date, _ holidayMonth: Int, _ holidayDay: Int) -> Date? {
        let holidayCurrentYear = DateComponents(calendar: .current, year: Date.currentYear, month: holidayMonth, day: holidayDay).date
        let isHolidayCurrentYearInFuture = isHolidayTodayOrInFuture(currentDate, holidayCurrentYear)

        if isHolidayCurrentYearInFuture {
            return holidayCurrentYear
        } else {
            return DateComponents(calendar: .current, year: Date.currentYear + 1, month: holidayMonth, day: holidayDay).date
        }
    }
}
