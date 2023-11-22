//
//  HolidaysList.swift
//  Holidays
//
//  Created by Robert J. Sarvis Jr on 11/15/23.
//

import Foundation

let HolidaysList: [Holiday] = [
    Holiday(
        id: .christmas,
        name: "Christmas",
        date: DateComponents(calendar: .current, year: Date.currentYear, month: 12, day: 25).date,
        description: "The day we celebrate the birth of Jesus Christ", 
        dayOfMessage: "Merry Christmas!")
]
