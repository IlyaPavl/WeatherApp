//
//  ViewControllerExtension.swift
//  WeatherApp
//
//  Created by Ilya Pavlov on 14.08.2023.
//

import UIKit

extension ViewController {
    func presentSearchAlertController(with title: String, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) ->(Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena"]
            textField.placeholder = cities.randomElement()
        }
        let searchAction = UIAlertAction(title: "Search", style: .default) { action in
            let textField = alertController.textFields?.first
            guard let cityName = textField?.text else {return}
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(searchAction)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}
