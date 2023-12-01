//
//  Utils.swift
//  Holidays
//
//  Created by Robert J. Sarvis Jr on 11/15/23.
//

import Foundation

struct HolidaysUtils {
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
    
    static func getDefaultHolidayIndex(currentDate: Date) -> Int {
        let christmasDate = DateComponents(calendar: .current, year: Date.currentYear, month: 12, day: 25).date
        let newYearsDate = DateComponents(calendar: .current, year: Date.currentYear + 1, month: 1, day: 1).date
        
        if HolidaysUtils.isHolidayInFuture(currentDate, christmasDate) {
            return 0
        } else if HolidaysUtils.isHolidayInFuture(currentDate, newYearsDate) {
            return 1
        }
        return 0
    }
}
