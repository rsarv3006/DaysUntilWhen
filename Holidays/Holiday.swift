//
//  Holiday.swift
//  Holidays
//
//  Created by Robert J. Sarvis Jr on 11/15/23.
//

import Foundation

struct Holiday: Identifiable {
    let id: HolidayVariant
    let name: String
    let date: Date?
    let description: String
    let dayOfMessage: String
}

extension Holiday: Hashable {}
