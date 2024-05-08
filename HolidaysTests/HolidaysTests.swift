//
//  HolidaysTests.swift
//  HolidaysTests
//
//  Created by Robert J. Sarvis Jr on 11/22/23.
//

import XCTest

final class HolidaysTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEasterDateForYear() throws {
        var easterDate = try Date.easterFor(year: 2024)
        XCTAssertEqual(easterDate, DateComponents(calendar: .current, year: 2024, month: 3, day: 31).date)
        
        easterDate = try Date.easterFor(year: 2023)
        XCTAssertEqual(easterDate, DateComponents(calendar: .current, year: 2023, month: 4, day: 16).date)
    }
    
    func testMothersDayForYear() throws {
        var mothersDay = try Date.mothersDayFor(year: 2024)
        XCTAssertEqual(mothersDay, DateComponents(calendar: .current, year: 2024, month: 5, day: 12).date)
        
        mothersDay = try Date.mothersDayFor(year: 2025)
        XCTAssertEqual(mothersDay, DateComponents(calendar: .current, year: 2025, month: 5, day: 11).date)
        
        mothersDay = try Date.mothersDayFor(year: 2026)
        XCTAssertEqual(mothersDay, DateComponents(calendar: .current, year: 2026, month: 5, day: 10).date)
        
        mothersDay = try Date.mothersDayFor(year: 2030)
        XCTAssertEqual(mothersDay, DateComponents(calendar: .current, year: 2030, month: 5, day: 12).date)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
