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
    typealias FruitQueryResult = (FruitBasket?, String) -> Void
    typealias StatQueryResult = (Bool, String) -> Void
    let defaultSession = URLSession(configuration: .default)
    var errorMessage = ""
    
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
                self?.sendStat(event: .load, data: String(timeInterval)) { (hasBeenSent: Bool, errorMessage: String) in
                    print(hasBeenSent)
                    dispatchGroup.leave()
                }
                
                if let error = error {
                    self?.errorMessage += "Oops: " + error.localizedDescription
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let basket = try JSONDecoder().decode(FruitBasket.self, from: data)
                        dispatchGroup.notify(queue: DispatchQueue.global()) {
                            DispatchQueue.main.async {
                                completion(basket, self?.errorMessage ?? "")
                            }
                        }
                    } catch let parseError as NSError {
                        self?.errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
                        return
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
                    completion(false, "Oops: " + error.localizedDescription)
                } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completion(true, "")
                }
            }
            
            statDataTask?.resume()
        }
    }
    
}
