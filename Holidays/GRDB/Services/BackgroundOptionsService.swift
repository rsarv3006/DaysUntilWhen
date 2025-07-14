import Foundation
import GRDB

private let BackgroundOptionsList = [
    GRDBBackgroundOption.new(id: BackgroundOptionId.ChristmasBackground1.rawValue, type: .image, holidayFilter: [.christmas]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.ChristmasRed.rawValue, type: .color, holidayFilter: [.christmas]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.ChristmasWhite.rawValue, type: .color, holidayFilter: [.christmas]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.ChristmasGreen.rawValue, type: .color, holidayFilter: [.christmas]),
    GRDBBackgroundOption.new(
        id: BackgroundOptionId.GenericBlack.rawValue,
        type: .color,
        holidayFilter: [
            .christmas,
            .newYears,
            .valentines,
            .halloween,
            .thanksgiving,
            .fourthOfJuly,
            .fathersDay,
            .texasIndependenceDay,
        ]),
    GRDBBackgroundOption.new(
        id: BackgroundOptionId.GenericWhite.rawValue,
        type: .color,
        holidayFilter: [
            .christmas,
            .newYears,
            .valentines,
            .halloween,
            .thanksgiving,
            .fourthOfJuly,
            .fathersDay,
            .texasIndependenceDay,
        ]),
    GRDBBackgroundOption.new(
        id: BackgroundOptionId.GenericGold.rawValue,
        type: .color,
        holidayFilter: [
            .christmas,
            .newYears,
            .valentines,
            .thanksgiving,
            .texasIndependenceDay
        ]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.NewYearsBackground1.rawValue, type: .image, holidayFilter: [.newYears]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.ValentinesBackground1.rawValue, type: .image, holidayFilter: [.valentines]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.ValentinesRed.rawValue, type: .color, holidayFilter: [.valentines]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.ValentinesPink.rawValue, type: .color, holidayFilter: [.valentines]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.EasterBackground1.rawValue, type: .image, holidayFilter: [.easter]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.EasterPurple.rawValue, type: .color, holidayFilter: [.easter]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.EasterOrange.rawValue, type: .color, holidayFilter: [.easter]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.EasterGreen.rawValue, type: .color, holidayFilter: [.easter]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.MothersDayBackground1.rawValue, type: .image, holidayFilter: [.mothersDay]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.MothersDayGray.rawValue, type: .color, holidayFilter: [.mothersDay]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.MothersDayYellow.rawValue, type: .color, holidayFilter: [.mothersDay]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.HalloweenOrange.rawValue, type: .color, holidayFilter: [.halloween]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.HalloweenGreen.rawValue, type: .color, holidayFilter: [.halloween]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.HalloweenPurple.rawValue, type: .color, holidayFilter: [.halloween]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.HalloweenBone.rawValue, type: .color, holidayFilter: [.halloween]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.HalloweenBackground1.rawValue, type: .image, holidayFilter: [.halloween]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.ThanksgivingBackground1.rawValue, type: .image, holidayFilter: [.thanksgiving]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.ThanksgivingSpicedPumpkin.rawValue, type: .color, holidayFilter: [.thanksgiving]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.ThanksgivingGreen.rawValue, type: .color, holidayFilter: [.thanksgiving]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.ThanksgivingWhite.rawValue, type: .color, holidayFilter: [.thanksgiving]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.FathersDayBlue.rawValue, type: .color, holidayFilter: [.fathersDay]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.FathersDayYellow.rawValue, type: .color, holidayFilter: [.fathersDay]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.FathersDayBackground1.rawValue, type: .image, holidayFilter: [.fathersDay]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.FourthOfJulyRed.rawValue, type: .color, holidayFilter: [.fourthOfJuly]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.FourthOfJulyBlue.rawValue, type: .color, holidayFilter: [.fourthOfJuly]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.FourthOfJulyBackground1.rawValue, type: .image, holidayFilter: [.fourthOfJuly]),
    GRDBBackgroundOption.new(id: BackgroundOptionId.TexasIndependenceDayBackground1.rawValue, type: .image, holidayFilter: [.texasIndependenceDay])
]

public extension AppDatabase {
    func populateBackgroundOptions() throws {
        try dbWriter.write { db in
            for option in BackgroundOptionsList {
                try option.upsert(db)
            }
        }
    }
    
    func getAllBackgroundOptions() throws -> [GRDBBackgroundOption] {
        try dbWriter.read { db in
            try self.getAllBackgroundOptions(in: db)
        }
    }
    
    func getAllBackgroundOptions(in db: Database) throws -> [GRDBBackgroundOption] {
        try GRDBBackgroundOption.all().fetchAll(db)
    }
}
