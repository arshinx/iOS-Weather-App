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
    
    typealias WeatherCompletionHandler = (Weather?, DarkSkyError?) -> Void
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, DarkSkyError?) -> Void
    let downloader = JSONDownloader()
    
    private func getWeather(at coordinate: Coordinate, completionhandler completion: @escaping WeatherCompletionHandler) {
        
        guard let url = URL(string: coordinate.description, relativeTo: baseURL) else {
            completion(nil, .invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        let task = downloader.jsonTask(with: request) { (json, error) in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                guard let weather = Weather(json: json) else {
                    completion(nil, .jsonParsingFailiure)
                    return
                }
                
                completion(weather, nil)
            }
        }
        // Resume the task
        task.resume()
    }
        }
    }
}
