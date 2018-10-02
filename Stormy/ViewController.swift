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
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            // Alert user: please go to settings and enable location services for this app
        }
        
        getCurrentWeather()
        
    }
    
    // Get user location coordinates continously
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let loc = fetchCityAndCountry(from: locations[0]) { (city, state, country, error) in
            if error == nil {
                let city = city
                let state = state
                let country = country
                print("\(city!), \(state!), \(country!)")
            } else {
                print("error: \(error!)")
            }
        }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    */
    
    //
    func getCoordinates() -> [Double] {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //locationManager.startUpdatingLocation()
            let location = locationManager.location
            return [(location?.coordinate.latitude)!, (location?.coordinate.longitude)!]
        } else {
            return [37.8267, -122.4233]
        }
    }
    
    // Get city and country from loc coordinates
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ state: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.administrativeArea,
                       placemarks?.first?.country,
                       error)
        }
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

