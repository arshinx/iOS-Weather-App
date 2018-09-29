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
    
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, DarkSkyError?) -> Void
    let downloader = JSONDownloader()
    
    func getCurrentWeather(at coordinate: Coordinate, completionhandler completion: @escaping CurrentWeatherCompletionHandler) {
        
        guard let url = URL(dataRepresentation: coordinate.description, relativeTo: baseURL) else {
            
        }
    }
}
