//
//  DataLoading.swift
//  Holidays
//
//  Created by Robert J. Sarvis Jr on 12/2/23.
//

import Foundation
import SwiftData

enum HolidayLoadingError : Error {
    case invalidChristmasDate
    case invalidNewYearDate
    case invalidValentinesDate
    case failedToLoadBackgroundOptions
    case failedToLoadTextOptions
    case failedToLoadDisplayOptions
    case attemptedToLoadDisplayOptionsBeforeDependencies
}

private let BackgroundOptionsList = [
    BackgroundOption(id: BackgroundOptionId.ChristmasBackground1.rawValue, type: .image, holidayFilter: [.christmas]),
    BackgroundOption(id: BackgroundOptionId.ChristmasRed.rawValue, type: .color, holidayFilter: [.christmas]),
    BackgroundOption(id: BackgroundOptionId.ChristmasWhite.rawValue, type: .color, holidayFilter: [.christmas]),
    BackgroundOption(id: BackgroundOptionId.ChristmasGreen.rawValue, type: .color, holidayFilter: [.christmas]),
    BackgroundOption(id: BackgroundOptionId.GenericBlack.rawValue, type: .color, holidayFilter: [.christmas, .newYears, .valentines]),
    BackgroundOption(id: BackgroundOptionId.GenericWhite.rawValue, type: .color, holidayFilter: [.christmas, .newYears, .valentines]),
]

private let TextOptionsList = [
    TextOption(id: TextOptionId.ChristmasRed.rawValue, holidayFilter: [.christmas]),
    TextOption(id: TextOptionId.ChristmasWhite.rawValue, holidayFilter: [.christmas]),
    TextOption(id: TextOptionId.ChristmasGreen.rawValue, holidayFilter: [.christmas]),
    TextOption(id: TextOptionId.GenericBlack.rawValue, holidayFilter: [.christmas, .newYears, .valentines]),
    TextOption(id: TextOptionId.GenericWhite.rawValue, holidayFilter: [.christmas, .newYears, .valentines])
]

func loadBackgroundOptions(modelContext: ModelContext) throws {
    let backgroundOptionsDescriptor = FetchDescriptor<BackgroundOption>()
    let loadedBackgroundOptions = try modelContext.fetch(backgroundOptionsDescriptor)
    
    BackgroundOptionsList.forEach { option in
        guard !loadedBackgroundOptions.contains(option) else { return }
        modelContext.insert(option)
    }
}

func loadTextOptions(context: ModelContext) throws {
    let textOptionsDescriptor = FetchDescriptor<TextOption>()
    let loadedTextOptions = try context.fetch(textOptionsDescriptor)
    
    TextOptionsList.forEach { option in
        guard !loadedTextOptions.contains(option) else { return }
        context.insert(option)
    }
}

func loadDisplayOptions(context: ModelContext) throws {
    let loadedDisplayOptions = try context.fetch(FetchDescriptor<HolidayDisplayOptions>())
    
    let backgroundOptions = try context.fetch(FetchDescriptor<BackgroundOption>())
    let textOptions = try context.fetch(FetchDescriptor<TextOption>())
    
    if backgroundOptions.isEmpty || textOptions.isEmpty {
        throw HolidayLoadingError.attemptedToLoadDisplayOptionsBeforeDependencies
    }
    
    HolidayVariant.allCases.forEach { variant in
        guard !loadedDisplayOptions.contains(where: { $0.id == variant }) else { return }
        let displayOptions = HolidayDisplayOptions(id: variant)
        switch variant {
        case .christmas:
            displayOptions.backgroundOption = backgroundOptions.first(where: { backgroundOption in
                backgroundOption.id == BackgroundOptionId.ChristmasBackground1.rawValue
            })
            displayOptions.textOption = textOptions.first(where: { textOption in
                textOption.id == TextOptionId.ChristmasRed.rawValue
            })
        case .newYears:
            displayOptions.backgroundOption = backgroundOptions.first(where: { backgroundOption in
                backgroundOption.id == BackgroundOptionId.ChristmasGreen.rawValue
            })
            displayOptions.textOption = textOptions.first(where: { textOption in
                textOption.id == TextOptionId.ChristmasRed.rawValue
            })
        case .valentines:
            displayOptions.backgroundOption = backgroundOptions.first(where: { backgroundOption in
                backgroundOption.id == BackgroundOptionId.ChristmasRed.rawValue
            })
            displayOptions.textOption = textOptions.first(where: { textOption in
                textOption.id == TextOptionId.ChristmasWhite.rawValue
            })
        }
        context.insert(displayOptions)
    }
}

func loadInitialHolidays(context: ModelContext) throws {
    let loadedHolidays = try context.fetch(FetchDescriptor<Holiday>())
   
    let christmasDate = try Date.christmasFor(year: Date.currentYear)
    let newYearDate = try Date.newYearsFor(year: Date.currentYear)
    let valentinesDate = try Date.valentinesFor(year: Date.currentYear)
    
    let christmasNextYearDate = try Date.christmasFor(year: Date.currentYear + 1)
    let newYearNextYearDate = try Date.newYearsFor(year: Date.currentYear + 1)
    let valentinesNextYearDate = try Date.valentinesFor(year: Date.currentYear + 1)
 
    let holidaysToInsert = [
        createChristmasHolidayModel(christmasTimeInterval: christmasDate.timeIntervalSince1970),
        createNewYearHolidayModel(newYearTimeInterval: newYearDate.timeIntervalSince1970),
        createValentinesHolidayModel(valentinesTimerInterval: valentinesDate.timeIntervalSince1970),
        
        createChristmasHolidayModel(christmasTimeInterval: christmasNextYearDate.timeIntervalSince1970),
        createNewYearHolidayModel(newYearTimeInterval: newYearNextYearDate.timeIntervalSince1970),
        createValentinesHolidayModel(valentinesTimerInterval: valentinesNextYearDate.timeIntervalSince1970)
    ]
    
    for holiday in holidaysToInsert {
        let isHolidayLoaded = loadedHolidays.contains(where: { $0.variant == holiday.variant && $0.id == holiday.id })
        
        if !isHolidayLoaded {
            context.insert(holiday)
        }
    }
}



func deleteHolidaysInThePast(modelContext: ModelContext) throws {
    let currentTimeInterval = Date().timeIntervalSince1970
    
    let holidayPredicate = #Predicate<Holiday> { holiday in
        return holiday.id < currentTimeInterval
    }
    let pastHolidaysFetchDescriptor = FetchDescriptor<Holiday>(predicate: holidayPredicate)
    let pastHolidays = try modelContext.fetch(pastHolidaysFetchDescriptor)
    
    pastHolidays.forEach { holiday in
        modelContext.delete(holiday)
    }
}

func createChristmasHolidayModel(christmasTimeInterval: TimeInterval) -> Holiday {
    let christmas = Holiday(id: christmasTimeInterval, variant: .christmas, name: "Christmas", holidayDescription: "The day we celebrate the birth of Jesus Christ.", dayOfGreeting: "Merry Christmas!")
    return christmas
}

func createNewYearHolidayModel(newYearTimeInterval: TimeInterval) -> Holiday {
    let newYear = Holiday(id: newYearTimeInterval, variant: .newYears, name: "New Year", holidayDescription: "The day we celebrate the new year.", dayOfGreeting: "Happy New Year!")
    return newYear
}

func createValentinesHolidayModel(valentinesTimerInterval: TimeInterval) -> Holiday {
    return Holiday(id: valentinesTimerInterval, variant: .valentines, name: "Valentines", holidayDescription: "Valentine's Day is a romantic holiday for couples to celebrate their love by exchanging cards, flowers, chocolates, and other gifts.", dayOfGreeting: "Happy Valentine's Day!")
}
