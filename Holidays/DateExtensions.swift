import Foundation

extension Date {
    static var tomorrow: Date {
        return Date().addingTimeInterval(86400)
    }
    
    static var currentYear: Int {
        return Calendar.current.component(.year, from: Date())
    }
    
    static var christmas: Date? {
        return DateComponents(calendar: .current, year: Date.currentYear, month: 12, day: 25).date
    }
    
    static var dayAfterChristmas: Date? {
        return DateComponents(calendar: .current, year: Date.currentYear, month: 12, day: 26).date
    }
    
    static func christmasFor(year: Int) throws -> Date {
        guard let christmas = DateComponents(calendar: .current, year: year, month: 12, day: 25).date else { throw HolidayCreateErrors.invalidChristmasDate }
        return christmas
    }
    
    static func newYearsFor(year: Int) throws -> Date {
        guard let newYears = DateComponents(calendar: .current, year: year, month: 1, day: 1).date else { throw HolidayCreateErrors.invalidNewYearsDate }
        return newYears
    }
    
    static func valentinesFor(year: Int) throws -> Date {
        guard let valentines = DateComponents(calendar: .current, year: year, month: 2, day: 14).date else { throw HolidayCreateErrors.invalidValentinesDate }
        return valentines
    }
    
    static func halloweenFor(year: Int) throws -> Date {
        guard let halloween = DateComponents(calendar: .current, year: year, month: 10, day: 31).date else { throw HolidayCreateErrors.invalidHalloween }
        return halloween
    }
    
    static func mothersDayFor(year: Int) throws -> Date {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: 5, day: 1)
        
        guard let firstDayOfMay = calendar.date(from: components) else {
            throw HolidayCreateErrors.invalidMothersDayDate
        }
        
        let daysInMay = calendar.range(of: .day, in: .month, for: firstDayOfMay)?.count ?? 0
        var currentDay = firstDayOfMay
        var weekday = calendar.component(.weekday, from: currentDay)
        
        for _ in 1...daysInMay {
            if weekday == 1 {
                if let maybeDay = calendar.date(byAdding: .day, value: 7, to: currentDay) {
                    currentDay = maybeDay
                }
                break
            } else {
                if let maybeDay = calendar.date(byAdding: .day, value: 1, to: currentDay) {
                    currentDay = maybeDay
                    weekday = calendar.component(.weekday, from: currentDay)
                }
            }
        }
        
        return currentDay
    }
    
    
    static func easterFor(year: Int) throws -> Date {
        let c = year / 100
        let n = year - 19 * (year / 19)
        let k = (c - 17) / 25
        var i = c - c / 4 - (c - k) / 3 + 19 * n + 15
        i = i - 30 * (i / 30)
        i = i - (i / 28) * (1 - (i / 28) * (29 / (i + 1)) * ((21 - n) / 11))
        
        var j = year + year / 4 + i + 2 - c + c / 4
        j = j - 7 * (j / 7)
        
        let l = i - j
        let m = 3 + (l + 40) / 44
        let d = l + 28 - 31 * (m / 4)
        
        guard let easterDate = DateComponents(calendar: .current, year: year, month: m, day: d).date else { throw HolidayCreateErrors.invalidEasterDate }
        
        return easterDate
        
    }
    
    static func thanksgivingFor(year: Int) throws -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let november = DateComponents(year: year, month: 11)
        
        guard let nov1 = calendar.date(from: november) else {
            throw HolidayCreateErrors.invalidThanksgiving
        }
        
        let weekdayComponents = calendar.dateComponents([.weekday], from: nov1)
        let daysUntilFirstThursday = (5 - (weekdayComponents.weekday ?? 1) + 7) % 7
        
        guard let thanksgivingDay = calendar.date(byAdding: .day, value: daysUntilFirstThursday + 21, to: nov1)
        else { throw HolidayCreateErrors.invalidThanksgiving }
        
        return thanksgivingDay
    }
    
    static func fourthOfJulyFor(year: Int) throws -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let julyFourth = DateComponents(year: year, month: 7, day: 4)
        
        guard let fourth = calendar.date(from: julyFourth) else {
            throw HolidayCreateErrors.invalidJuly4thDate
        }
        
        return fourth
    }

    
    static func memorialDayFor(year: Int) throws -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let may31 = DateComponents(year: year, month: 5, day: 31)
        
        guard let lastDayOfMay = calendar.date(from: may31) else {
            throw HolidayCreateErrors.invalidMemorialDayDate
        }
        
        var currentDate = lastDayOfMay
        while calendar.component(.weekday, from: currentDate) != 2 {
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        return currentDate
    }
    
    static func fathersDayFor(year: Int) throws -> Date {
        let calendar = Calendar(identifier: .gregorian)
        
        // Create June 1st of the given year
        let june1Components = DateComponents(year: year, month: 6, day: 1)
        
        guard let june1 = calendar.date(from: june1Components) else {
            throw HolidayCreateErrors.invalidFathersDayDate
        }
        
        // Find the first Sunday in June
        var firstSunday = june1
        let sunday = 1 // In Gregorian calendar, Sunday is 1
        
        // Move forward until we find the first Sunday
        while calendar.component(.weekday, from: firstSunday) != sunday {
            firstSunday = calendar.date(byAdding: .day, value: 1, to: firstSunday)!
        }
        
        // Add 14 days (2 weeks) to the first Sunday to get the third Sunday
        let fathersDay = calendar.date(byAdding: .day, value: 14, to: firstSunday)!
        
        return fathersDay
    }
}

// MARK: - Date Components
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
}

