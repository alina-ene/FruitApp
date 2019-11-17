//
//  DetailViewPresenter.swift
//  FruitApp
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

protocol DetailViewPresentable {
    var fruitDetailCount: Int { get }
    func text(for index: Int) -> String?
}

class DetailViewPresenter: DetailViewPresentable {
 
    var fruitDetailCount = 3
    private let fruit: Fruit
    
    init(fruit: Fruit) {
        self.fruit = fruit
    }
    
    func text(for index: Int) -> String? {
        switch index {
        case 0:
            return fruit.type.capitalized
        case 1:
            return fruit.price.description
        case 2:
            return fruit.weight.description
        default:
            return nil
        }
     }
}
