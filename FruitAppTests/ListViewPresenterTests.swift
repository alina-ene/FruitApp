//
//  ListViewPresenterTests.swift
//  FruitAppTests
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import XCTest
@testable import FruitApp

class ListViewPresenterTests: XCTestCase {

    var listViewPresenter: ListViewPresenter!
    let fruitList = [Fruit(type: "apple", price: 122, weight: 345), Fruit(type: "watermelon", price: 987, weight: 333)]
    
    override func setUp() {
        listViewPresenter = ListViewPresenter(queryManager: QueryManager())
    }

    override func tearDown() {

    }

    func testStateMessage() {
        XCTAssert(listViewPresenter.stateMessage == "Loading...", "State message has Loading ... as an initial value")
        listViewPresenter.state = .error
        XCTAssert(listViewPresenter.stateMessage == "Something went wrong. Pull to refresh", "State message when an error occurs")
        listViewPresenter.state = .resultsLoaded
        XCTAssert(listViewPresenter.stateMessage == "Pull to refresh", "State message when results have loaded")
    }
    
    func testSectionTitle() {
        XCTAssert(listViewPresenter.sectionTitle == "Fruit Basket", "Section title displayed in the nav bar")
    }
    
    func testRefreshControlMessage() {
        XCTAssert(listViewPresenter.refreshControlMessage == "Pull to refresh", "Refresh control text")
    }
    
    func testRowCountForSection() {
        listViewPresenter.fruitList = []
        XCTAssert(listViewPresenter.rowCount(for: 0) == 0, "Row count for empty list, first section")
        XCTAssert(listViewPresenter.rowCount(for: 1) == 0, "Row count for empty list, second section")
        XCTAssert(listViewPresenter.rowCount(for: -1) == 0, "Row count for empty list, invalid section number")
        listViewPresenter.fruitList = fruitList
        XCTAssert(listViewPresenter.rowCount(for: 0) == 2, "Row count for list with 2 elements, first section")
        XCTAssert(listViewPresenter.rowCount(for: 1) == 2, "Row count for list with 2 elements, second section")
        XCTAssert(listViewPresenter.rowCount(for: -1) == 2, "Row count for list with 2 elements, invalid section number")
    }
    
    func testTextForRowIndex() {
        listViewPresenter.fruitList = []
        XCTAssertNil(listViewPresenter.text(for: 0), "Nil text value for empty list")
        
        listViewPresenter.fruitList = fruitList
        XCTAssertNil(listViewPresenter.text(for: -1), "Nil text value for element at negative index")
        XCTAssertNil(listViewPresenter.text(for: 5), "Nil text value for element outside of range")
        XCTAssert(listViewPresenter.text(for: 0) == "Apple", "Apple is the first element to be displayed in the list")
        XCTAssert(listViewPresenter.text(for: 1) == "Watermelon", "Watermelon is the first element to be displayed in the list")
    }

    func testRefreshListTime() {
        // This is an example of a performance test case.
        self.measure {
            listViewPresenter.refreshList()
        }
    }

}
