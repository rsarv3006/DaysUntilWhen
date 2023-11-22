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
        date: HolidaysUtils.getHolidayDate(Date(), 12, 25),
        description: "The day we celebrate the birth of Jesus Christ", 
        dayOfGreeting: "Merry Christmas!",
        defaultBackgroundOptionIndex: 0,
        defaultTextOptionIndex: 0
    )
]
