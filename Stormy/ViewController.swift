//
//  ViewController.swift
//  Stormy
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate let darkSkyApiKey = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let base = URL(string: "https://api.darksky.net/forecast/\(darkSkyApiKey)/")
        let forecastURL = URL(string: "37.8267,-122.4233", relativeTo: base)
        
        // Get Data
        let weatherData = try! Data(contentsOf: forecastURL!)
        print(weatherData)
        
        let currentWeather = CurrentWeather(temperature: 85.0, humidity: 0.8, precipProbability: 0.1, summary: "Hot!", icon: "clear-day")
        let viewModel = CurrentWeatherViewModel(model: currentWeather)
        displayWeather(using: viewModel)
    }
    
    func displayWeather(using viewModel: CurrentWeatherViewModel) {
        currentTemperatureLabel.text    = viewModel.temperature
        currentHumidityLabel.text       = viewModel.humidity
        currentPrecipitationLabel.text  = viewModel.precipitationProbability
        currentSummaryLabel.text        = viewModel.summary
        currentWeatherIcon.image        = viewModel.icon
    }
}

