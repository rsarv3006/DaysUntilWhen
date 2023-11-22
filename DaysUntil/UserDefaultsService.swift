//
//  UserDefaultsService.swift
//  DaysUntil
//
//  Created by Robert J. Sarvis Jr on 11/17/23.
//

import Foundation

enum DefaultsKey: String {
    case selectedHolidayIndex
    case selectedBackgroundIndex
    case selectedTextIndex
}

class UserDefaultsService {
    private static let defaults = AppGroup.daysUntilWhen.defaults
    
    static func save(value: Int, forKey key: DefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    static func integer(forKey key: DefaultsKey) -> Int {
        return defaults.integer(forKey: key.rawValue)
    }
    
}


