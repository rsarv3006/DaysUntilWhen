
import Foundation

struct HolidayCreation {
    static func createChristmasHolidayModel(christmasTimeInterval: TimeInterval) -> GRDBHoliday {
        let christmas = GRDBHoliday.new(id: christmasTimeInterval, variant: .christmas, name: "Christmas", holidayDescription: "The day we celebrate the birth of Jesus Christ.", dayOfGreeting: "Merry Christmas!", icon: "gift.fill")
        return christmas
    }
    
    static func createNewYearHolidayModel(newYearTimeInterval: TimeInterval) -> GRDBHoliday {
        let newYear = GRDBHoliday.new(id: newYearTimeInterval, variant: .newYears, name: "New Year", holidayDescription: "The day we celebrate the new year.", dayOfGreeting: "Happy New Year!", icon: "party.popper.fill")
        return newYear
    }
    
    static func createValentinesHolidayModel(valentinesTimerInterval: TimeInterval) -> GRDBHoliday {
        return GRDBHoliday.new(id: valentinesTimerInterval, variant: .valentines, name: "Valentines", holidayDescription: "Valentine's Day is a romantic holiday for couples to celebrate their love by exchanging cards, flowers, chocolates, and other gifts.", dayOfGreeting: "Happy Valentine's Day!", icon: "heart.fill")
    }
    
    static func createEasterHolidayModel(easterTimeInterval: TimeInterval) -> GRDBHoliday {
        return GRDBHoliday.new(id: easterTimeInterval, variant: .easter, name: "Easter", holidayDescription: "Easter is a Christian holiday that celebrates the resurrection of Jesus Christ from the dead.", dayOfGreeting: "Happy Easter!", icon: "cross.fill")
    }
    
    static func createMothersDayHolidayModel(mothersTimeInterval: TimeInterval) -> GRDBHoliday {
        return GRDBHoliday.new(id: mothersTimeInterval,
                       variant: .mothersDay,
                       name: "Mother's Day",
                       holidayDescription: "Mother's Day is a celebration honoring the mother of the family, as well as motherhood, maternal bonds, and the influence of mothers in society.",
                               dayOfGreeting: "Happy Mother's Day!", icon: "heart.circle.fill")
    }
    
    static func createHalloweenHolidayModel(halloweenTimeInterval: TimeInterval) -> GRDBHoliday {
        return GRDBHoliday.new(id: halloweenTimeInterval, variant: .halloween, name: "Halloween", holidayDescription: "Originally a pagan holiday. It is now a holiday celebrating all things spooky. Also candy, an egregious amount of candy.", dayOfGreeting: "Happy Halloween!", icon: "moon.fill")
    }
    
    static func createThanksgivingHolidayModel(thanksgivingTimeInterval: TimeInterval) -> GRDBHoliday {
        return GRDBHoliday.new(id: thanksgivingTimeInterval, variant: .thanksgiving, name: "Thanksgiving", holidayDescription: "A day to celebrate the harvest and the many blessings of the past year.", dayOfGreeting: "Happy Thanksgiving!", icon: "leaf.fill")
    }
    
//    static func createMemorialDayHolidayModel(memorialDayTimeInterval: TimeInterval) -> GRDBHoliday {
//        return GRDBHoliday.new(id: memorialDayTimeInterval, variant: .memorialDay, name: "Memorial Day", holidayDescription: "A day to honor and remember the men and women who have died while serving in the United States military.", dayOfGreeting: "Happy Memorial Day")
//    }
    
    static func createFourthOfJulyHolidayModel(fourthOfJulyTimeInterval: TimeInterval) -> GRDBHoliday {
        return GRDBHoliday.new(id: fourthOfJulyTimeInterval, variant: .fourthOfJuly, name: "Fourth of July", holidayDescription: "A day to celebrate the birth of the United States of America.", dayOfGreeting: "Happy Fourth of July!", icon: "flag.fill")
    }
    
    static func createFathersDayHolidayModel(fathersDayTimeInterval: TimeInterval) -> GRDBHoliday {
        return GRDBHoliday.new(id: fathersDayTimeInterval, variant: .fathersDay, name: "Father's Day", holidayDescription: "A day to celebrate the men in our lives.", dayOfGreeting: "Happy Father's Day!", icon: "figure.wave")
    }
//    
//    static func createVeteransDayHolidayModel(veteransDayTimeInterval: TimeInterval) -> GRDBHoliday {
//        return GRDBHoliday.new(id: veteransDayTimeInterval, variant: .veteransDay, name: "Veterans Day", holidayDescription: "A day to honor and remember the men and women who have served in the United States military.", dayOfGreeting: "Happy Veterans Day!")
//    }
    
}
