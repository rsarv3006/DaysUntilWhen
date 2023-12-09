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
    
    enum HolidayCreateErrors : Error {
        case invalidChristmasDate
        case invalidNewYearsDate
        case invalidValentinesDate
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
