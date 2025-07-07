import Foundation
import GRDB

private let TextOptionsList = [
    GRDBTextOption.new(id: TextOptionId.ChristmasRed.rawValue, holidayFilter: [.christmas]),
    GRDBTextOption.new(id: TextOptionId.ChristmasWhite.rawValue, holidayFilter: [.christmas]),
    GRDBTextOption.new(id: TextOptionId.ChristmasGreen.rawValue, holidayFilter: [.christmas]),
    GRDBTextOption.new(id: TextOptionId.GenericBlack.rawValue, holidayFilter: [
        .christmas, .newYears, .valentines, .halloween, .thanksgiving, .fourthOfJuly, .fathersDay,
    ]),
    GRDBTextOption.new(id: TextOptionId.GenericWhite.rawValue, holidayFilter: [
        .christmas, .newYears, .valentines, .halloween, .thanksgiving, .fourthOfJuly, .fathersDay,
    ]),
    GRDBTextOption.new(id: TextOptionId.GenericGold.rawValue, holidayFilter: [.christmas, .newYears, .valentines, .halloween, .thanksgiving, .fourthOfJuly, .fathersDay]),
    GRDBTextOption.new(id: TextOptionId.ValentinesRed.rawValue, holidayFilter: [.valentines]),
    GRDBTextOption.new(id: TextOptionId.ValentinesPink.rawValue, holidayFilter: [.valentines]),
    GRDBTextOption.new(id: TextOptionId.EasterPurple.rawValue, holidayFilter: [.easter]),
    GRDBTextOption.new(id: TextOptionId.EasterOrange.rawValue, holidayFilter: [.easter]),
    GRDBTextOption.new(id: TextOptionId.EasterGreen.rawValue, holidayFilter: [.easter]),
    GRDBTextOption.new(id: TextOptionId.MothersDayGray.rawValue, holidayFilter: [.mothersDay]),
    GRDBTextOption.new(id: TextOptionId.MothersDayYellow.rawValue, holidayFilter: [.mothersDay]),
    GRDBTextOption.new(id: TextOptionId.HalloweenOrange.rawValue, holidayFilter: [.halloween]),
    GRDBTextOption.new(id: TextOptionId.HalloweenGreen.rawValue, holidayFilter: [.halloween]),
    GRDBTextOption.new(id: TextOptionId.HalloweenPurple.rawValue, holidayFilter: [.halloween]),
    GRDBTextOption.new(id: TextOptionId.HalloweenBone.rawValue, holidayFilter: [.halloween]),
    GRDBTextOption.new(id: TextOptionId.ThanksgivingSpicedPumpkin.rawValue, holidayFilter: [.thanksgiving]),
    GRDBTextOption.new(id: TextOptionId.ThanksgivingGreen.rawValue, holidayFilter: [.thanksgiving]),
    GRDBTextOption.new(id: TextOptionId.ThanksgivingWhite.rawValue, holidayFilter: [.thanksgiving]),
    GRDBTextOption.new(id: TextOptionId.FathersDayBlue.rawValue, holidayFilter: [.fathersDay]),
    GRDBTextOption.new(id: TextOptionId.FathersDayYellow.rawValue, holidayFilter: [.fathersDay]),
    GRDBTextOption.new(id: TextOptionId.FourthOfJulyRed.rawValue, holidayFilter: [.fourthOfJuly]),
    GRDBTextOption.new(id: TextOptionId.FourthOfJulyBlue.rawValue, holidayFilter: [.fourthOfJuly]),
]

public extension AppDatabase {
    func populateTextOptions() throws {
        try dbWriter.write { db in
            let allOptionIds = try GRDBTextOption.all().fetchAll(db).map { option in
                option.id
            }

            for option in TextOptionsList {
                if !allOptionIds.contains(option.id) {
                    try option.insert(db)
                }
            }
        }
    }
    
    func getAllTextOptions() throws -> [GRDBTextOption] {
        try dbWriter.read { db in
            try self.getAllTextOptions(in: db)
        }
    }
    
    func getAllTextOptions(in db: Database) throws -> [GRDBTextOption] {
        try GRDBTextOption.all().fetchAll(db)
    }
}
