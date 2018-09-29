//
//  DarkSkyAPIClient.swift
//  Stormy
//
//  Created by Arshin Jain on 9/28/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

class DarkSkyAPIClient {
    
    fileprivate let darkSkyApiKey = ""
    
    lazy var baseURL: URL = {
        return URL(string: "https://api.darksky.net/forecast/\(darkSkyApiKey)/")!
    }()
    
    typealias WeatherCompletionHandler = (Weather?, Error?) -> Void
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, Error?) -> Void

    // Parse JSON
    let decoder = JSONDecoder() // handles decoding
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    // Get Weather
    private func getWeather(at coordinate: Coordinate, completionhandler completion: @escaping WeatherCompletionHandler) {
        
        guard let url = URL(string: coordinate.description, relativeTo: baseURL) else {
            completion(nil, DarkSkyError.invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, res, error) in
            
            DispatchQueue.main.async {
                
                if let data = data {
                    
                    guard let httpResponse = res as? HTTPURLResponse else {
                        completion(nil, DarkSkyError.requestFailed)
                        return
                    }
                    
                    // Check if request is successful
                    if httpResponse.statusCode == 200 {
                        do {
                            // decode to type Weather, from data (JSON)
                            let weather = try self.decoder.decode(Weather.self, from: data)
                            completion(weather, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else { // status not "success/200"
                        completion(nil, DarkSkyError.invalidData)
                    }
                    
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        // Resume the task
        task.resume()
    }
    
    func getCurrentWeather(at coordinate: Coordinate, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        getWeather(at: coordinate) { (weather, error) in
            completion(weather?.currently, error)
        }
    }
}
