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
}
