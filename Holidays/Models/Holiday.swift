//
//  Holiday.swift
//  Holidays
//
//  Created by Robert J. Sarvis Jr on 11/15/23.
//

import Foundation
import SwiftData

@Model
class Holiday: Identifiable {
    let id: TimeInterval
    let variant: HolidayVariant
    let name: String
    let holidayDescription: String
    let dayOfGreeting: String
    var isFavorite: Bool
    
    init(id: TimeInterval, variant: HolidayVariant, name: String, holidayDescription: String, dayOfGreeting: String) {
       self.id = id
         self.variant = variant
            self.name = name
            self.holidayDescription = holidayDescription
            self.dayOfGreeting = dayOfGreeting
            self.isFavorite = false
    }
    
    @Transient
    var date: Date? {
        Date(timeIntervalSince1970: id)
    }
}

extension Holiday: Hashable {}
