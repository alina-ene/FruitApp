//
//  QueryManagerTests.swift
//  FruitAppTests
//
//  Created by Alina Ene on 19/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import XCTest
@testable import FruitApp

class QueryManagerTests: XCTestCase {
    
    private let queryManager = QueryManager()
    
    func testStatResponseMessage() {
        
        var actualMessage = queryManager.statResponseMessage(true, nil, "Fruit Basket load", "656")
        var expectedMessage = "Fruit Basket load has been successfully reported - 656"
        XCTAssert(actualMessage == expectedMessage, "Successful stat sending scenario")
        
        actualMessage = queryManager.statResponseMessage(false, "Request error: The Internet connection appears to be offline", "display", "605")
        expectedMessage = "display has been unsuccessfully reported - 605\n Error : Request error: The Internet connection appears to be offline"
        XCTAssert(actualMessage == expectedMessage, "Unsuccessful stat sending scenario")
    }
    
    func testTimeIntervalGivenTwoDates() {
        let startDate = Date()
        let endDate = Date().addingTimeInterval(1)
        var expectedOutput = 1000
        var actualOutput = queryManager.timeInterval(endDate: endDate, startDate: startDate)
        XCTAssert(actualOutput == expectedOutput, "End date is bigger than startDate by 1000ms")
        
        expectedOutput = -1000
        actualOutput = queryManager.timeInterval(endDate: startDate, startDate: endDate)
        XCTAssert(actualOutput == expectedOutput, "Start date is bigger than endDate by 1000ms")
    }
    
    func testFruitAppUrls() {
        XCTAssert(FruitUrl.list.rawValue == "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/data.json", "Get Fruit List url")
        XCTAssert(FruitUrl.stats.rawValue == "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/stats", "Send stat base url")
    }
    
    func testFruitListLoad() {
        
       let expectation = self.expectation(description: "Fruit list load")
        queryManager.loadFruitList { (_, _) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
//        XCTAssertEqual(scaledImages?.count, originalImages.count)
    }
    
}
