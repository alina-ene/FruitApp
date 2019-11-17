//
//  ListViewPresenter.swift
//  FruitApp
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

protocol Presentable {
}

protocol ListViewPresentable: Presentable {
    func rowCount(for section: Int) -> Int
    func fruitName(for rowIndex: Int) -> String?
    var sectionTitle: String { get }
    func showDetail(for rowIndex: Int)
}

class ListViewPresenter: ListViewPresentable {
    
    var sectionTitle: String = "Fruit App"
    var coordinator: AppCoordinator
    private var fruitList: [Fruit] = [Fruit(type: "applE", price: 12, weight: 12)]
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func rowCount(for section: Int) -> Int {
        return fruitList.count
    }
    
    func fruitName(for rowIndex: Int) -> String? {
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
