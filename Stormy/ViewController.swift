//
//  ViewController.swift
//  Stormy
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let client = DarkSkyAPIClient()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        getCurrentWeather()
        
    }
    
    // Assign values to View Elements
    func displayWeather(using viewModel: CurrentWeatherViewModel) {
        currentTemperatureLabel.text    = viewModel.temperature
        currentHumidityLabel.text       = viewModel.humidity
        currentPrecipitationLabel.text  = viewModel.precipitationProbability
        currentSummaryLabel.text        = viewModel.summary
        currentWeatherIcon.image        = viewModel.icon
    }
    
    // Get and display current Weather data
    @IBAction func getCurrentWeather() {
        
        // refresh animation
        toggleRefreshAnimation(on: true)
        
        // get weather
        client.getCurrentWeather(at: Coordinate.alcatrazIsland) { [unowned self] (currentWeather, error) in
            if let currentWeather = currentWeather {
                let viewModel = CurrentWeatherViewModel(model: currentWeather)
                self.displayWeather(using: viewModel)
                self.toggleRefreshAnimation(on: false)
            }
        }
    }
    
    // Animation for while data is loading
    func toggleRefreshAnimation(on: Bool) {
        refreshButton.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

