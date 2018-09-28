//
//  CurrentWeatherViewModel.swift
//  Stormy
//
//  Created by Arshin Jain on 9/27/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeatherViewModel {
    let temperature:                String
    let humidity:                   String
    let precipitationProbability:   String
    let summary:                    String
    let icon:                       UIImage
    
    init(model: CurrentWeather) {
        let roundedTemperature = Int(model.temperature)
        self.temperature = "\(roundedTemperature)º"
        let humidityPercentage = Int(model.humidity * 100)
        self.humidity = "\(humidityPercentage)%"
        self.precipitationProbability = "100%"
        self.summary = ""
        
    }
}
