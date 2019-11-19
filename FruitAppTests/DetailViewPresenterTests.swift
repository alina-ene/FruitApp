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

    func testTextForIndex() {
        XCTAssertNil(detailViewPresenter.text(for: -1), "Nil text value for element at negative index")
        XCTAssertNil(detailViewPresenter.text(for: 5), "Nil text value for element outside of range")
        XCTAssert(detailViewPresenter.text(for: 0) == "APPLE", "APPLE is the first element to be displayed")
        XCTAssert(detailViewPresenter.text(for: 1) == "£2.33", "£2.33 is displayed second")
        XCTAssert(detailViewPresenter.text(for: 2) == "0.122KG", "1.22KG is displayed third")
    }

    func testNumberOfLabelsDisplayed() {
        
        XCTAssert(detailViewPresenter.fruitDetailCount == 3, "Detail screen displays a set number of labels for the fruit")
    }

}
