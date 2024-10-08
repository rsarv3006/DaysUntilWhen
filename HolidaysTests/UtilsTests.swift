//
//  Utils.swift
//  HolidaysTests
//
//  Created by Robert J. Sarvis Jr on 11/22/23.
//

import XCTest

final class Utils: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDaysUntilFromMonthBefore() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 11, day: 22).date
        let holiday = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date
        
        let calculatedInterval = HolidaysUtils.daysUntil(currentDate!, holiday)
        XCTAssertEqual(calculatedInterval, 33)
    }
    
    func testDaysUntilFromDayBefore() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 24).date
        let holiday = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date
        
        let calculatedInterval = HolidaysUtils.daysUntil(currentDate!, holiday)
        XCTAssertEqual(calculatedInterval, 1)
    }
    
    func testDaysUntilDayOf() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date
        let holiday = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date
        
        let calculatedInterval = HolidaysUtils.daysUntil(currentDate!, holiday)
        XCTAssertEqual(calculatedInterval, 0)
    }
    
    func testDaysUntilDayAfter() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 26).date
        let holiday = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date
        
        let calculatedInterval = HolidaysUtils.daysUntil(currentDate!, holiday)
        XCTAssertEqual(calculatedInterval, -1)
    }
    
    func testIsHolidayInFutureForHolidayInFuture() throws {
         let currentDate = DateComponents(calendar: .current, year: 2023, month: 11, day: 25).date!
        let holiday = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date
        
        XCTAssertTrue(HolidaysUtils.isHolidayInFuture(currentDate, holiday))
    }
    
    func testIsHolidayInFutureIfHolidayMatchesCurrentDate() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date!
        let holiday = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date
        
        XCTAssertTrue(HolidaysUtils.isHolidayInFuture(currentDate, holiday))
    }
    
    func testIsHolidayInFutureHolidayInPast() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date!
        let holiday = DateComponents(calendar: .current, year: 2022, month: 12, day: 25).date
        
        XCTAssertFalse(HolidaysUtils.isHolidayInFuture(currentDate, holiday))
    }

    func testGetHolidayDateHolidayInCurrentYearNotInPast() throws {
        let calendar = Calendar.current
        let currentDate = Date() // Use the actual current date
        
        // Calculate the next Christmas date
        var christmasComponents = DateComponents()
        christmasComponents.month = 12
        christmasComponents.day = 25
        
        guard let nextChristmas = calendar.nextDate(after: currentDate, matching: christmasComponents, matchingPolicy: .nextTime) else {
            XCTFail("Failed to calculate next Christmas date")
            return
        }
        
        let calculatedHolidayDate = HolidaysUtils.getHolidayDate(currentDate, 12, 25)
        XCTAssertEqual(nextChristmas, calculatedHolidayDate)
        
        // Additional assertion to ensure the calculated date is not in the past
        XCTAssertGreaterThanOrEqual(calculatedHolidayDate!, currentDate, "Calculated holiday date should not be in the past")
    }
    
    func testGetHolidayDateCurrentDatePastYearHoliday() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 26).date!
        let holidayDate = DateComponents(calendar: .current, year: 2024, month: 12, day: 25).date!
        
        let calculatedHolidayDate = HolidaysUtils.getHolidayDate(currentDate, 12, 25)
        XCTAssertEqual(holidayDate, calculatedHolidayDate)
    }
    
    func testGetHolidayDateHolidayDayOf() throws {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        // Create a date for this year's Christmas
        guard let christmasDate = calendar.date(from: DateComponents(year: currentYear, month: 12, day: 25)) else {
            XCTFail("Failed to create Christmas date")
            return
        }
        
        let calculatedHolidayDate = HolidaysUtils.getHolidayDate(christmasDate, 12, 25)
        
        XCTAssertEqual(christmasDate, calculatedHolidayDate, "Calculated holiday date should be the same as the input date when it's the holiday")
        
        // Additional assertions to verify the date components
        let components = calendar.dateComponents([.year, .month, .day], from: calculatedHolidayDate!)
        XCTAssertEqual(components.year, currentYear, "Year should be the current year")
        XCTAssertEqual(components.month, 12, "Month should be December")
        XCTAssertEqual(components.day, 25, "Day should be the 25th")
    }
    

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
