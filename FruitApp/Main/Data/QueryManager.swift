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
    typealias JSONDictionary = [String: Any]
    typealias FruitBasketQueryResult = (FruitBasket?, String?) -> Void
    typealias StatQueryResult = (Bool, String?) -> Void
    let defaultSession = URLSession(configuration: .default)
    let dispatchGroup = DispatchGroup()
    let displayDispatchGroup = DispatchGroup()
    var displayStartDate: Date?
    var displayEndDate: Date? {
        didSet {
            trackScreenDisplayTransitionTime()
        }
    }
    
    func loadFruitList(completion: @escaping FruitBasketQueryResult) {
        dataTask?.cancel()
        
        if let urlComponents = URLComponents(string: FruitUrl.list.rawValue) {
            guard let url = urlComponents.url else {
                return
            }
            let startDate = Date()
            
            dispatchGroup.enter()
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                let timeIntervalString = String(self?.timeInterval(endDate: Date(), startDate: startDate) ?? 0)
                self?.sendStat(event: .load, data: timeIntervalString) { (isSuccessful: Bool, errorMessage: String?) in
                    if let message = self?.statResponseMessage(isSuccessful, errorMessage, "Fruit Basket load",  timeIntervalString) {
                        print(message)
                    }
                    self?.dispatchGroup.leave()
                }
                var errorMessage: String?
                var basket: FruitBasket?
                if let error = error {
                    errorMessage = error.localizedDescription
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        basket = try JSONDecoder().decode(FruitBasket.self, from: data)
                    } catch let parseError as NSError {
                        errorMessage = parseError.localizedDescription
                    }
                }
                if let error = errorMessage {
                    let log = #function + " " + error
                    self?.dispatchGroup.enter()
                    self?.sendStat(event: .error, data: log) { (isSuccessful: Bool, errorMessage: String?) in
                        if let message = self?.statResponseMessage(isSuccessful, errorMessage,  StatEvent.error.rawValue, log) {
                            print(message)
                        }
                        self?.dispatchGroup.leave()
                    }
                }
                self?.dispatchGroup.notify(queue: DispatchQueue.main) {
                    completion(basket, errorMessage)
                }
            }
            
            dataTask?.resume()
        }
    }
    
    func sendStat(event: StatEvent, data: String, completion: @escaping StatQueryResult) {
        if var urlComponents = URLComponents(string: FruitUrl.stats.rawValue) {
            let queryItemToken = URLQueryItem(name: StatParamKey.event.rawValue, value: event.rawValue)
            let queryItemQuery = URLQueryItem(name: StatParamKey.data.rawValue, value: data)
            urlComponents.queryItems = [queryItemToken, queryItemQuery]
            guard let url = urlComponents.url else {
                return
            }
            
            let statDataTask = defaultSession.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    completion(false, "Request error: " + error.localizedDescription)
                } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completion(true, nil)
                }
            }
            statDataTask.resume()
        }
    }
    
    func trackScreenDisplayTransitionTime() {
        if let endDate = displayEndDate, let startDate = displayStartDate {
            let timeIntervalString = String(timeInterval(endDate: endDate, startDate: startDate))
            displayDispatchGroup.enter()
            sendStat(event: .display, data: timeIntervalString) { [weak self] (isSuccessful: Bool, errorMessage: String?) in
                if let message = self?.statResponseMessage(isSuccessful, errorMessage, StatEvent.display.rawValue, timeIntervalString) {
                    print(message)
                }
                if let error = errorMessage {
                    let log = #function + " " + error
                    
                    self?.sendStat(event: .error, data: log) { (isSuccessful: Bool, errorMessage: String?) in
                        if let message = self?.statResponseMessage(isSuccessful, errorMessage,  StatEvent.error.rawValue, log) {
                            print(message)
                        }
                        self?.displayDispatchGroup.leave()
                    }
                }
                
                self?.displayDispatchGroup.notify(queue: DispatchQueue.main) {
                    self?.displayStartDate = nil
                    self?.displayEndDate = nil
                }
            }
        }
    }
    
    func timeInterval(endDate: Date, startDate: Date) -> Int {
        return Int(Double(endDate.timeIntervalSince(startDate)) * 1000)
    }
    
    func statResponseMessage(_ isSuccessful: Bool, _ errorMessage: String?, _ event: String, _ data: String) -> String {
        var message = ""
        let output = isSuccessful ? "successfully" : "unsuccessfully"
        message += "\(event) has been \(output) reported - \(data)"
        if let error = errorMessage {
            message += "\n Error : \(error)"
        }
        return message
    }
}
