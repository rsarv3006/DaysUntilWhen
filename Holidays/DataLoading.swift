import Foundation
import SwiftData

enum HolidayLoadingError: Error {
    case invalidChristmasDate
    case invalidNewYearDate
    case invalidValentinesDate
    case invalidEasterDate
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
    BackgroundOption(id: BackgroundOptionId.GenericBlack.rawValue, type: .color, holidayFilter: [.christmas, .newYears, .valentines, .halloween, .thanksgiving]),
    BackgroundOption(id: BackgroundOptionId.GenericWhite.rawValue, type: .color, holidayFilter: [.christmas, .newYears, .valentines, .halloween, .thanksgiving]),
    BackgroundOption(id: BackgroundOptionId.GenericGold.rawValue, type: .color, holidayFilter: [.christmas, .newYears, .valentines, .thanksgiving]),
    BackgroundOption(id: BackgroundOptionId.NewYearsBackground1.rawValue, type: .image, holidayFilter: [.newYears]),
    BackgroundOption(id: BackgroundOptionId.ValentinesBackground1.rawValue, type: .image, holidayFilter: [.valentines]),
    BackgroundOption(id: BackgroundOptionId.ValentinesRed.rawValue, type: .color, holidayFilter: [.valentines]),
    BackgroundOption(id: BackgroundOptionId.ValentinesPink.rawValue, type: .color, holidayFilter: [.valentines]),
    BackgroundOption(id: BackgroundOptionId.EasterBackground1.rawValue, type: .image, holidayFilter: [.easter]),
    BackgroundOption(id: BackgroundOptionId.EasterPurple.rawValue, type: .color, holidayFilter: [.easter]),
    BackgroundOption(id: BackgroundOptionId.EasterOrange.rawValue, type: .color, holidayFilter: [.easter]),
    BackgroundOption(id: BackgroundOptionId.EasterGreen.rawValue, type: .color, holidayFilter: [.easter]),
    BackgroundOption(id: BackgroundOptionId.MothersDayBackground1.rawValue, type: .image, holidayFilter: [.mothersDay]),
    BackgroundOption(id: BackgroundOptionId.MothersDayGray.rawValue, type: .color, holidayFilter: [.mothersDay]),
    BackgroundOption(id: BackgroundOptionId.MothersDayYellow.rawValue, type: .color, holidayFilter: [.mothersDay]),
    BackgroundOption(id: BackgroundOptionId.HalloweenOrange.rawValue, type: .color, holidayFilter: [.halloween]),
    BackgroundOption(id: BackgroundOptionId.HalloweenGreen.rawValue, type: .color, holidayFilter: [.halloween]),
    BackgroundOption(id: BackgroundOptionId.HalloweenPurple.rawValue, type: .color, holidayFilter: [.halloween]),
    BackgroundOption(id: BackgroundOptionId.HalloweenBone.rawValue, type: .color, holidayFilter: [.halloween]),
    BackgroundOption(id: BackgroundOptionId.HalloweenBackground1.rawValue, type: .image, holidayFilter: [.halloween]),
    BackgroundOption(id: BackgroundOptionId.ThanksgivingBackground1.rawValue, type: .image, holidayFilter: [.thanksgiving]),
    BackgroundOption(id: BackgroundOptionId.ThanksgivingSpicedPumpkin.rawValue, type: .color, holidayFilter: [.thanksgiving]),
    BackgroundOption(id: BackgroundOptionId.ThanksgivingGreen.rawValue, type: .color, holidayFilter: [.thanksgiving]),
    BackgroundOption(id: BackgroundOptionId.ThanksgivingWhite.rawValue, type: .color, holidayFilter: [.thanksgiving]),
]

private let TextOptionsList = [
    TextOption(id: TextOptionId.ChristmasRed.rawValue, holidayFilter: [.christmas]),
    TextOption(id: TextOptionId.ChristmasWhite.rawValue, holidayFilter: [.christmas]),
    TextOption(id: TextOptionId.ChristmasGreen.rawValue, holidayFilter: [.christmas]),
    TextOption(id: TextOptionId.GenericBlack.rawValue, holidayFilter: [
        .christmas, .newYears, .valentines, .halloween, .thanksgiving
    ]),
    TextOption(id: TextOptionId.GenericWhite.rawValue, holidayFilter: [
        .christmas, .newYears, .valentines, .halloween, .thanksgiving
    ]),
    TextOption(id: TextOptionId.GenericGold.rawValue, holidayFilter: [.christmas, .newYears, .valentines, .halloween, .thanksgiving]),
    TextOption(id: TextOptionId.ValentinesRed.rawValue, holidayFilter: [.valentines]),
    TextOption(id: TextOptionId.ValentinesPink.rawValue, holidayFilter: [.valentines]),
    TextOption(id: TextOptionId.EasterPurple.rawValue, holidayFilter: [.easter]),
    TextOption(id: TextOptionId.EasterOrange.rawValue, holidayFilter: [.easter]),
    TextOption(id: TextOptionId.EasterGreen.rawValue, holidayFilter: [.easter]),
    TextOption(id: TextOptionId.MothersDayGray.rawValue, holidayFilter: [.mothersDay]),
    TextOption(id: TextOptionId.MothersDayYellow.rawValue, holidayFilter: [.mothersDay]),
    TextOption(id: TextOptionId.HalloweenOrange.rawValue, holidayFilter: [.halloween]),
    TextOption(id: TextOptionId.HalloweenGreen.rawValue, holidayFilter: [.halloween]),
    TextOption(id: TextOptionId.HalloweenPurple.rawValue, holidayFilter: [.halloween]),
    TextOption(id: TextOptionId.HalloweenBone.rawValue, holidayFilter: [.halloween]),
    TextOption(id: TextOptionId.ThanksgivingSpicedPumpkin.rawValue, holidayFilter: [.thanksgiving]),
    TextOption(id: TextOptionId.ThanksgivingGreen.rawValue, holidayFilter: [.thanksgiving]),
    TextOption(id: TextOptionId.ThanksgivingWhite.rawValue, holidayFilter: [.thanksgiving]),
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
                backgroundOption.id == BackgroundOptionId.NewYearsBackground1.rawValue
            })
            displayOptions.textOption = textOptions.first(where: { textOption in
                textOption.id == TextOptionId.GenericGold.rawValue
            })
        case .valentines:
            displayOptions.backgroundOption = backgroundOptions.first(where: { backgroundOption in
                backgroundOption.id == BackgroundOptionId.ValentinesBackground1.rawValue
            })
            displayOptions.textOption = textOptions.first(where: { textOption in
                textOption.id == TextOptionId.ValentinesRed.rawValue
            })
        case .easter:
            displayOptions.backgroundOption = backgroundOptions.first(where: { backgroundOption in
                backgroundOption.id == BackgroundOptionId.EasterBackground1.rawValue
            })
            displayOptions.textOption = textOptions.first(where: { textOption in
                textOption.id == TextOptionId.EasterPurple.rawValue
            })
        case .mothersDay:
            displayOptions.backgroundOption = backgroundOptions.first(where: { backgroundOption in
                backgroundOption.id == BackgroundOptionId.MothersDayBackground1.rawValue
            })
            displayOptions.textOption = textOptions.first(where: { textOption in
                textOption.id == TextOptionId.MothersDayYellow.rawValue
            })
        case .halloween:
            displayOptions.backgroundOption = backgroundOptions.first(where: { backgroundOption in
                backgroundOption.id == BackgroundOptionId.HalloweenBackground1.rawValue
            })
            displayOptions.textOption = textOptions.first(where: { textOption in
                textOption.id == TextOptionId.HalloweenOrange.rawValue
            })
        case .thanksgiving:
            displayOptions.backgroundOption = backgroundOptions.first(where: { backgroundOption in
                backgroundOption.id == BackgroundOptionId.ThanksgivingBackground1.rawValue
            })
            displayOptions.textOption = textOptions.first(where: { textOption in
                textOption.id == TextOptionId.ThanksgivingSpicedPumpkin.rawValue
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
    let easterDate = try Date.easterFor(year: Date.currentYear)
    let mothersDayDate = try Date.mothersDayFor(year: Date.currentYear)
    let halloweenDate = try Date.halloweenFor(year: Date.currentYear)
    let thanksgiving = try Date.thanksgivingFor(year: Date.currentYear)

    let christmasNextYearDate = try Date.christmasFor(year: Date.currentYear + 1)
    let newYearNextYearDate = try Date.newYearsFor(year: Date.currentYear + 1)
    let valentinesNextYearDate = try Date.valentinesFor(year: Date.currentYear + 1)
    let easterNextYearDate = try Date.easterFor(year: Date.currentYear + 1)
    let mothersDayNextYearDate = try Date.mothersDayFor(year: Date.currentYear + 1)
    let halloweenNextYearDate = try Date.halloweenFor(year: Date.currentYear + 1)
    let thanksgivingNextYearDate = try Date.thanksgivingFor(year: Date.currentYear + 1)

    let holidaysToInsert = [
        createChristmasHolidayModel(christmasTimeInterval: christmasDate.timeIntervalSince1970),
        createNewYearHolidayModel(newYearTimeInterval: newYearDate.timeIntervalSince1970),
        createValentinesHolidayModel(valentinesTimerInterval: valentinesDate.timeIntervalSince1970),
        createEasterHolidayModel(easterTimeInterval: easterDate.timeIntervalSince1970),
        createMothersDayHolidayModel(mothersTimeInterval: mothersDayDate.timeIntervalSince1970),
        createHalloweenHolidayModel(halloweenTimeInterval: halloweenDate.timeIntervalSince1970),
        createThanksgivingHolidayModel(thanksgivingTimeInterval: thanksgiving.timeIntervalSince1970),

        createChristmasHolidayModel(christmasTimeInterval: christmasNextYearDate.timeIntervalSince1970),
        createNewYearHolidayModel(newYearTimeInterval: newYearNextYearDate.timeIntervalSince1970),
        createValentinesHolidayModel(valentinesTimerInterval: valentinesNextYearDate.timeIntervalSince1970),
        createEasterHolidayModel(easterTimeInterval: easterNextYearDate.timeIntervalSince1970),
        createMothersDayHolidayModel(mothersTimeInterval: mothersDayNextYearDate.timeIntervalSince1970),
        createHalloweenHolidayModel(halloweenTimeInterval: halloweenNextYearDate.timeIntervalSince1970),
        createThanksgivingHolidayModel(thanksgivingTimeInterval: thanksgivingNextYearDate.timeIntervalSince1970)
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
        holiday.id < currentTimeInterval
    }
    let pastHolidaysFetchDescriptor = FetchDescriptor<Holiday>(predicate: holidayPredicate)
    let pastHolidays = try modelContext.fetch(pastHolidaysFetchDescriptor)

    for holiday in pastHolidays {
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

func createEasterHolidayModel(easterTimeInterval: TimeInterval) -> Holiday {
    return Holiday(id: easterTimeInterval, variant: .easter, name: "Easter", holidayDescription: "Easter is a Christian holiday that celebrates the resurrection of Jesus Christ from the dead.", dayOfGreeting: "Happy Easter!")
}

func createMothersDayHolidayModel(mothersTimeInterval: TimeInterval) -> Holiday {
    return Holiday(id: mothersTimeInterval,
                   variant: .mothersDay,
                   name: "Mother's Day",
                   holidayDescription: "Mother's Day is a celebration honoring the mother of the family, as well as motherhood, maternal bonds, and the influence of mothers in society.",
                   dayOfGreeting: "Happy Mother's Day!")
}

func createHalloweenHolidayModel(halloweenTimeInterval: TimeInterval) -> Holiday {
    return Holiday(id: halloweenTimeInterval, variant: .halloween, name: "Halloween", holidayDescription: "Originally a pagan holiday. It is now a holiday celebrating all things spooky. Also candy, an egregious amount of candy.", dayOfGreeting: "Happy Halloween!")
}

func createThanksgivingHolidayModel(thanksgivingTimeInterval: TimeInterval) -> Holiday {
    return Holiday(id: thanksgivingTimeInterval, variant: .thanksgiving, name: "Thanksgiving", holidayDescription: "A day to celebrate the harvest and the many blessings of the past year.", dayOfGreeting: "Happy Thanksgiving!")
}
