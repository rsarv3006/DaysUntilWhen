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
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 11, day: 25).date!
        let holidayDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date!
        
        let calculatedHolidayDate = HolidaysUtils.getHolidayDate(currentDate, 12, 25)
        XCTAssertEqual(holidayDate, calculatedHolidayDate)
    }
    
    func testGetHolidayDateCurrentDatePastYearHoliday() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 26).date!
        let holidayDate = DateComponents(calendar: .current, year: 2024, month: 12, day: 25).date!
        
        let calculatedHolidayDate = HolidaysUtils.getHolidayDate(currentDate, 12, 25)
        XCTAssertEqual(holidayDate, calculatedHolidayDate)
    }
    
    func testGetHolidayDateHolidayDayOf() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date!
        let holidayDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date!
        
        let calculatedHolidayDate = HolidaysUtils.getHolidayDate(currentDate, 12, 25)
        XCTAssertEqual(holidayDate, calculatedHolidayDate)
    }
    
    func testGetDefaultHolidayIndex() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 11, day: 25).date!
        
        let calculatedHolidayIndex = HolidaysUtils.getDefaultHolidayIndex(currentDate: currentDate)
        XCTAssertEqual(calculatedHolidayIndex, 0)
    }
    
    func testGetDefaultHolidayIndexChristmasDay() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date!
        
        let calculatedHolidayIndex = HolidaysUtils.getDefaultHolidayIndex(currentDate: currentDate)
        XCTAssertEqual(calculatedHolidayIndex, 0)
    }
    
    func testGetDefaultHolidayIndexDayAfterChristmas() throws {
        let currentDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 26).date!
        
        let calculatedHolidayIndex = HolidaysUtils.getDefaultHolidayIndex(currentDate: currentDate)
        XCTAssertEqual(calculatedHolidayIndex, 1)
    }
    
    func testGetDefaultHolidayIndexDayAfterNewYears() throws {
        let currentDate = DateComponents(calendar: .current, year: 2024, month: 1, day: 2).date!
        
        let calculatedHolidayIndex = HolidaysUtils.getDefaultHolidayIndex(currentDate: currentDate)
        XCTAssertEqual(calculatedHolidayIndex, 0)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
