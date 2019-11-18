//
//  QueryManager.swift
//  FruitApp
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

enum StatEvent: String {
    case load = "load"
    case display = "display"
    case error = "error"
}

enum StatParamKey: String {
    case event = "event"
    case data = "data"
}

enum FruitUrl: String {
    case list = "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/data.json"
    case stats = "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/stats"
}
class QueryManager {
    
    var dataTask: URLSessionDataTask?
    var statDataTask: URLSessionDataTask?
    typealias JSONDictionary = [String: Any]
    typealias FruitQueryResult = (FruitBasket?, String?) -> Void
    typealias StatQueryResult = (Bool, String?) -> Void
    let defaultSession = URLSession(configuration: .default)
    
    func loadFruitList(completion: @escaping FruitQueryResult) {
        dataTask?.cancel()
        
        if let urlComponents = URLComponents(string: FruitUrl.list.rawValue) {
            guard let url = urlComponents.url else {
                return
            }
            let startDate = Date()
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                let timeInterval = Int(Double(Date().timeIntervalSince(startDate)) * 1000)
                self?.sendStat(event: .load, data: String(timeInterval)) { (hasBeenSent: Bool, errorMessage: String?) in
                    print("\(timeInterval)ms time interval sent as stat for loading fruit basket")
                    dispatchGroup.leave()
                }
                var errorMessage: String?
                var basket: FruitBasket?
                if let error = error {
                    errorMessage = "Request error: " + error.localizedDescription
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        basket = try JSONDecoder().decode(FruitBasket.self, from: data)
                    } catch let parseError as NSError {
                        errorMessage = "JSONSerialization error: \(parseError.localizedDescription)\n"
                    }
                }
                dispatchGroup.notify(queue: DispatchQueue.global()) {
                    DispatchQueue.main.async {
                        completion(basket, errorMessage)
                    }
                }
            }
            
            dataTask?.resume()
        }
    }
    
    func sendStat(event: StatEvent, data: String, completion: @escaping StatQueryResult) {
        statDataTask?.cancel()
        
        if var urlComponents = URLComponents(string: FruitUrl.stats.rawValue) {
            let queryItemToken = URLQueryItem(name: StatParamKey.event.rawValue, value: event.rawValue)
            let queryItemQuery = URLQueryItem(name: StatParamKey.data.rawValue, value: data)
            urlComponents.queryItems = [queryItemToken, queryItemQuery]
            guard let url = urlComponents.url else {
                return
            }
            
            statDataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.statDataTask = nil
                }
                
                if let error = error {
                    completion(false, "Request error: " + error.localizedDescription)
                } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completion(true, nil)
                }
            }
            
            statDataTask?.resume()
        }
    }
    
}
