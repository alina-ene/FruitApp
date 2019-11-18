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
    var fruit: Fruit { get set }
}

class DetailViewPresenter: DetailViewPresentable {
 
    var fruitDetailCount = 3
    var fruit: Fruit
    
    init(fruit: Fruit) {
        self.fruit = fruit
    }
    
    //DetailVP decides the order of the displayed fruit details' labels
    func text(for index: Int) -> String? {
        switch index {
        case 0:
            return fruit.type.uppercased()
        case 1:
            
            let price = fruit.price
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_UK")
            let formattedString = formatter.string(from: price/100 as NSNumber)
            return formattedString
        case 2:
            
            let weightGrams = fruit.weight
            let weightKg = weightGrams/1000
            return "\(weightKg)KG"
        default:
            return nil
        }
     }
}
