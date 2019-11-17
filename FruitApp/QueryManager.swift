//
//  QueryManager.swift
//  FruitApp
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

class QueryManager {
    
    private let fruitListUrl = "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/data.json"
    private let statsUrl = " https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/stats"
    
    var dataTask: URLSessionDataTask?
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = (FruitBasket?, String) -> Void
    let defaultSession = URLSession(configuration: .default)
    var errorMessage = ""
    
    func loadFruitList(completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: fruitListUrl) {
          guard let url = urlComponents.url else {
            return
          }
        
          dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
              self?.dataTask = nil
            }
            
            if let error = error {
              self?.errorMessage += "Oops: " + error.localizedDescription
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
              do {
                let basket = try JSONDecoder().decode(FruitBasket.self, from: data)
                DispatchQueue.main.async {
                    completion(basket, self?.errorMessage ?? "")
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
    
    func sendStat() {
        
    }
}
