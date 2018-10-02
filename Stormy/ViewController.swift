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
            showAlert(title: "Please Enable Location Services", message: "Please enable location services from your settings so we can show weather based on your location.", actionTitle: "Okay")
        }
        
        // Update weather with latest data
        getCurrentWeather()
        
    }
    
    // Get user location coordinates continously
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    //
    func getCoordinates() -> CLLocation {
        
        let coordinates = locationManager.location
        
        if CLLocationManager.locationServicesEnabled() {
            return coordinates!
        } else {
            // Alert user: please go to settings and enable location services for this app
            return CLLocation(latitude: 37.8267, longitude: -122.4233)
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
        client.getCurrentWeather(at: Coordinate.currentLocation) { [unowned self] (currentWeather, error) in
            if let currentWeather = currentWeather {
                let viewModel = CurrentWeatherViewModel(model: currentWeather)
                self.displayWeather(using: viewModel)
                self.toggleRefreshAnimation(on: false)
            }
        }
        
        if let location = locationManager.location {
            
            fetchCityAndCountry(from: location) { (city, state, country, error) in
                print("Label location: \(location.coordinate) \(String(describing: city)), \(String(describing: state)), \(String(describing: error))")
                if error == nil {
                    let city = city
                    let state = state
                    self.locationLabel.text = "\(city!), \(state!)"
                } else {
                    let city = "Alcatraz Island"
                    let state = "CA"
                    self.locationLabel.text = "\(city), \(state)"
                    print("error: \(error!)")
                }
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
    
    // Create & Show Alert
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

