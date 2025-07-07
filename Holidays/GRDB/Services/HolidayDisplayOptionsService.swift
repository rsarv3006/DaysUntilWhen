import Foundation
import GRDB

extension AppDatabase {
    func getDisplayOptions(for holidayVariant: HolidayVariant, in db: Database) throws -> GRDBHolidayDisplayOptions? {
        return try GRDBHolidayDisplayOptions.fetchOne(db, key: holidayVariant)
    }

    func getDisplayOptions(for holidayVariant: HolidayVariant) throws -> GRDBHolidayDisplayOptions? {
        try dbWriter.read { db in
            try self.getDisplayOptions(for: holidayVariant, in: db)
        }
    }

    func getAllDisplayOptions(in db: Database) throws -> [GRDBHolidayDisplayOptions] {
        return try GRDBHolidayDisplayOptions.fetchAll(db)
    }

    func getAllDisplayOptions() throws -> [GRDBHolidayDisplayOptions] {
        try dbWriter.read { db in
            try self.getAllDisplayOptions(in: db)
        }
    }
    
    func updateDisplayOptions(for holiday: GRDBHoliday, withBackground background: GRDBBackgroundOption, withText text: GRDBTextOption) throws {
        try dbWriter.write { db in
            guard var displayOption = try self.getDisplayOptions(for: holiday.variant, in: db) else {
                throw HolidayErrors.failedToUpdateDisplayOptions
            }
            
            displayOption.updateDisplayOptions(backgroundOptionId: background.id, textOptionId: text.id)
            try displayOption.update(db)
        }
    }

    func populateDisplayOptions() throws {
        try dbWriter.write { db in
            let loadedDisplayOptions = try self.getAllDisplayOptions()

            let backgroundOptions = try self.getAllBackgroundOptions()
            let textOptions = try self.getAllTextOptions()

            if backgroundOptions.isEmpty || textOptions.isEmpty {
                throw HolidayLoadingError.attemptedToLoadDisplayOptionsBeforeDependencies
            }

            for variant in HolidayVariant.allCases {
                guard !loadedDisplayOptions.contains(where: { $0.id == variant }) else { continue }
                var displayOptions = GRDBHolidayDisplayOptions.new(id: variant)

                switch variant {
                case .christmas:
                    displayOptions.updateDisplayOptions(backgroundOptionId: BackgroundOptionId.ChristmasBackground1.rawValue, textOptionId: TextOptionId.ChristmasRed.rawValue)
                case .newYears:
                    displayOptions.updateDisplayOptions(backgroundOptionId: BackgroundOptionId.NewYearsBackground1.rawValue, textOptionId: TextOptionId.GenericGold.rawValue)
                case .valentines:
                    displayOptions.updateDisplayOptions(backgroundOptionId: BackgroundOptionId.ValentinesBackground1.rawValue, textOptionId: TextOptionId.ValentinesRed.rawValue)
                case .easter:
                    displayOptions.updateDisplayOptions(backgroundOptionId: BackgroundOptionId.EasterBackground1.rawValue, textOptionId: TextOptionId.EasterPurple.rawValue)
                case .mothersDay:
                    displayOptions.updateDisplayOptions(backgroundOptionId: BackgroundOptionId.MothersDayBackground1.rawValue, textOptionId: TextOptionId.MothersDayYellow.rawValue)
                case .halloween:
                    displayOptions.updateDisplayOptions(backgroundOptionId: BackgroundOptionId.HalloweenBackground1.rawValue, textOptionId: TextOptionId.HalloweenOrange.rawValue)
                case .thanksgiving:
                    displayOptions.updateDisplayOptions(backgroundOptionId: BackgroundOptionId.ThanksgivingBackground1.rawValue, textOptionId: TextOptionId.ThanksgivingSpicedPumpkin.rawValue)
                case .fourthOfJuly:
                    displayOptions.updateDisplayOptions(backgroundOptionId: BackgroundOptionId.FourthOfJulyBackground1.rawValue, textOptionId: TextOptionId.FourthOfJulyRed.rawValue)
                case .fathersDay:
                    displayOptions.updateDisplayOptions(backgroundOptionId: BackgroundOptionId.FathersDayBackground1.rawValue, textOptionId: TextOptionId.FathersDayYellow.rawValue)
                }

                try displayOptions.insert(db)
            }
        }
    }
}
