//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ilya Pavlov on 13.08.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    let networkManager = NetworkManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.presentSearchAlertController(with: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            /* работа с помощью completionHandler
             self.networkManager.fetchCurrentWeather(forCity: city) { currentWeather in
             }
             */
            
            self.networkManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* работа с помощью completionHandler
         networkManager.fetchCurrentWeather(forCity: "London") { currentWeather in
         */
        
        networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else {return}
            self.updateInterface(with: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    func updateInterface(with weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeLabel.text = weather.feelsLikeTempString
            self.weatherIcon.image = UIImage(systemName: weather.systemIconNameString)
        }
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        
        networkManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
}
