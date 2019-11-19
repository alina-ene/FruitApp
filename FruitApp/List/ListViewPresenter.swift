//
//  ListViewPresenter.swift
//  FruitApp
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

protocol ListViewPresentable {
    func rowCount(for section: Int) -> Int
    func text(for rowIndex: Int) -> String?
    var sectionTitle: String { get }
    var outputMessage: String { get }
    var refreshControlMessage: String { get }
    func showDetail(for rowIndex: Int)
    func refreshList()
    var fruitList: [Fruit] { get set }
    var queryManager: QueryManager { get set }
}

enum ListViewState {
    case resultsLoaded
    case loading
    case error
}

class ListViewPresenter: ListViewPresentable {
    
    var refreshControlMessage = "Pull to refresh"
    var sectionTitle: String = "Fruit Basket"
    var coordinator: AppCoordinator
    var fruitList: [Fruit] = [] {
        didSet {
            coordinator.reloadList()
        }
    }
    var queryManager: QueryManager
    var state: ListViewState = .loading {
        didSet {
            outputMessage = outputMessage(state: state)
            coordinator.updateOutput()
        }
    }
    
    var outputMessage: String = ""
    
    init(coordinator: AppCoordinator, queryManager: QueryManager) {
        self.coordinator = coordinator
        self.queryManager = queryManager
        refreshList()
    }
    
    func outputMessage(state: ListViewState) -> String {
        switch state {
        case .resultsLoaded:
            return refreshControlMessage
        case .loading:
            return "Loading..."
        case .error:
            return "Something went wrong. Pull to refresh"
        }
    }
    
    func refreshList() {
        state = .loading
        queryManager.loadFruitList { (fruitBasket: FruitBasket?, errorMessage: String?) in
            if let basket = fruitBasket {
                self.fruitList = basket.fruit
                self.state = .resultsLoaded
            }
            if let _ = errorMessage {
                self.state = .error
            }
        }
    }
    
    func rowCount(for section: Int) -> Int {
        return fruitList.count
    }
    
    func text(for rowIndex: Int) -> String? {
        if rowIndex < fruitList.count {
            return fruitList[rowIndex].type.capitalized
        }
        return nil
    }

    func showDetail(for rowIndex: Int) {
        if rowIndex < fruitList.count {
            let detailPresenter = DetailViewPresenter(fruit: fruitList[rowIndex])
            coordinator.showDetail(presenter: detailPresenter)
        }
    }
}
