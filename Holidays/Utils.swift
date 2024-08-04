import Foundation

struct HolidaysUtils {
    static func getSelectedHoliday(holidays: [Holiday], date: Date) -> Holiday? {
        let favoriteHoliday = holidays.first { holiday in
            holiday.isFavorite == true
        }
        
        if let favoriteHoliday {
            return favoriteHoliday
        }
       
        let sortedHolidays = holidays.sorted {
          guard let date1 = $0.date, let date2 = $1.date else {
            return false
          }
          return date1 < date2
        }
        
        for holiday in sortedHolidays {
          if let holidayDate = holiday.date, holidayDate > date {
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
    
    static func isHolidayInFuture(_ currentDate: Date, _ holidayDate: Date?) -> Bool {
        guard let holidayDate else { return false }
        
        if currentDate <= holidayDate {
            return true
        }
        
        return false
    }
    
    static func getHolidayDate(_ currentDate: Date, _ holidayMonth: Int, _ holidayDay: Int) -> Date? {
        let holidayCurrentYear = DateComponents(calendar: .current, year: Date.currentYear, month: holidayMonth, day: holidayDay).date
        let isHolidayCurrentYearInFuture = self.isHolidayInFuture(currentDate, holidayCurrentYear)
        
        if isHolidayCurrentYearInFuture {
            return holidayCurrentYear
        } else {
            return DateComponents(calendar: .current, year: Date.currentYear + 1, month: holidayMonth, day: holidayDay).date
        }
    }
}
