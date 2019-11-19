//
//  Fruit.swift
//  FruitApp
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

struct Fruit: Codable {
    let type: String
    let price: Double
    let weight: Double
}

struct FruitBasket: Codable {
    let fruit: [Fruit]
}
