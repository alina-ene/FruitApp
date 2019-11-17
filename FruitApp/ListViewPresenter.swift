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
    func fruitName(for rowIndex: Int) -> String
    var sectionTitle: String { get }
    func showFruitDetail()
}

class ListViewPresenter: ListViewPresentable {
    
    var sectionTitle: String = "Fruit App"
    var coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func rowCount(for section: Int) -> Int {
        return 1
    }
    
    func fruitName(for rowIndex: Int) -> String {
        return "Fruit"
    }

    func showFruitDetail() {
        coordinator.showFruitDetail()
    }
}
