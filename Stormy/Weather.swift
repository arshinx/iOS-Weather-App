//
//  Weather.swift
//  Stormy
//
//  Created by Arshin Jain on 9/28/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

struct Weather {
    let currently: CurrentWeather
}

extension Weather {
    
    init?(json: [String: AnyObject]) {
        
        guard let currentWeatherJson = json["currently"] as? [String: AnyObject], let currentWeather = CurrentWeather(json: currentWeatherJson) else {
            return nil
        }
        
        self.currently = currentWeather
    }
}
