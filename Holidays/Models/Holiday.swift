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
    private(set) var id: TimeInterval
    private(set) var variant: HolidayVariant
    private(set) var name: String
    private(set) var holidayDescription: String
    private(set) var dayOfGreeting: String
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
