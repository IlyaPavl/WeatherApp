//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ilya Pavlov on 13.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    let networkManager = NetworkManager()
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.presentSearchAlertController(with: "Enter city name", message: nil, style: .alert) { city in
            /* работа с помощью completionHandler
             self.networkManager.fetchCurrentWeather(forCity: city) { currentWeather in
             }
             */
            
            self.networkManager.fetchCurrentWeather(forCity: city)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* работа с помощью completionHandler
         networkManager.fetchCurrentWeather(forCity: "London") { currentWeather in
         */
        
        networkManager.onCompletion = { currentWeather in
            print(currentWeather.cityName)
        }
        networkManager.fetchCurrentWeather(forCity: "London")
    }
}

