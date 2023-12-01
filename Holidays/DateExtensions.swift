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
}
