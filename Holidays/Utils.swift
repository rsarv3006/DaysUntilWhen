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
    
}
