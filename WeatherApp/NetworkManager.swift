//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Ilya Pavlov on 14.08.2023.
//

import Foundation
import CoreLocation

class NetworkManager {
    /* работа с помощью completionHandler
    func fetchCurrentWeather(forCity city: String, completionHandler: @escaping (CurrentWeather) -> (Void)) {
     */
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    //пишем универсальный метод для работы с разными запросами
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric&lang=\(countryKey)"
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apikey=\(apiKey)&units=metric"
        }
        
        performRequest(withURLString: urlString)
        
    }
    
//    func fetchCurrentWeather(forCity city: String) {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric&lang=\(countryKey)"
//        performRequest(withURLString: urlString)
//    }
//
//    func fetchCurrentWeather(forLatitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(forLatitude)&lon=\(longitude)&appid={API key}"
//        performRequest(withURLString: urlString)
//    }
    
    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else {return}

        //создаем стандратную сессию
        let session = URLSession(configuration: .default)
        
        //для сессии создаем задачу
        let task = session.dataTask(with: url) { data, response, error in
            //проверяем, что у нас есть данные
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }
        //пишем task.resume, чтобы инициировать запрос
        task.resume()
    }
    
    // функция для парсинга JSON
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {return nil}
            return currentWeather
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
}
