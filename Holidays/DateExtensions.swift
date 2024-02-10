//
//  DateExtensions.swift
//  Holidays
//
//  Created by Robert J. Sarvis Jr on 11/16/23.
//

import Foundation

extension Date {
    static var tomorrow: Date {
        return Date().addingTimeInterval(86400)
    }
    
    static var currentYear: Int {
        return Calendar.current.component(.year, from: Date())
    }
    
    static var christmas: Date? {
        return DateComponents(calendar: .current, year: Date.currentYear, month: 12, day: 25).date
    }
    
    static var dayAfterChristmas: Date? {
        return DateComponents(calendar: .current, year: Date.currentYear, month: 12, day: 26).date
    }
    
    static func christmasFor(year: Int) throws -> Date {
        guard let christmas = DateComponents(calendar: .current, year: year, month: 12, day: 25).date else { throw HolidayCreateErrors.invalidChristmasDate }
        return christmas
    }
    
    static func newYearsFor(year: Int) throws -> Date {
        guard let newYears = DateComponents(calendar: .current, year: year, month: 1, day: 1).date else { throw HolidayCreateErrors.invalidNewYearsDate }
        return newYears
    }
    
    static func valentinesFor(year: Int) throws -> Date {
        guard let valentines = DateComponents(calendar: .current, year: year, month: 2, day: 14).date else { throw HolidayCreateErrors.invalidValentinesDate }
        return valentines
    }
    
    static func easterFor(year: Int) throws -> Date {
        let c = year / 100
        let n = year - 19 * (year / 19)
        let k = (c - 17) / 25
        var i = c - c / 4 - (c - k) / 3 + 19 * n + 15
        i = i - 30 * (i / 30)
        i = i - (i / 28) * (1 - (i / 28) * (29 / (i + 1)) * ((21 - n) / 11))
        
        var j = year + year / 4 + i + 2 - c + c / 4
        j = j - 7 * (j / 7)
        
        let l = i - j
        let m = 3 + (l + 40) / 44
        let d = l + 28 - 31 * (m / 4)
        
        guard let easterDate = DateComponents(calendar: .current, year: year, month: m, day: d).date else { throw HolidayCreateErrors.invalidEasterDate }
        
        return easterDate
        
    }
    
    enum HolidayCreateErrors : Error {
        case invalidChristmasDate
        case invalidNewYearsDate
        case invalidValentinesDate
        case invalidEasterDate
    }
}

// MARK: - Date Components
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
}
