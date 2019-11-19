//
//  DetailViewPresenterTests.swift
//  FruitAppTests
//
//  Created by Alina Ene on 19/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import XCTest
@testable import FruitApp

class DetailViewPresenterTests: XCTestCase {
    
    var detailViewPresenter: DetailViewPresenter!

    override func setUp() {
        detailViewPresenter = DetailViewPresenter(fruit: Fruit(type: "apple", price: 233, weight: 122))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
