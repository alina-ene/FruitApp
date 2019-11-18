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
    var refreshControlMessage: String { get }
    func showDetail(for rowIndex: Int)
    func refreshList()
    var fruitList: [Fruit] { get set }
    var queryManager: QueryManager { get set }
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
    
    init(coordinator: AppCoordinator, queryManager: QueryManager) {
        self.coordinator = coordinator
        self.queryManager = queryManager
        refreshList()
    }
    
    func refreshList() {
        queryManager.loadFruitList { (fruitBasket: FruitBasket?, errorMessage: String?) in
            if let basket = fruitBasket {
                self.fruitList = basket.fruit
            }
        }
    }
    
    func sendScreenStat() {
        let ms = ""//compare now to when 
        queryManager.sendStat(event: .load, data: ms) { (isSuccessful: Bool, error: String?) in
            
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
