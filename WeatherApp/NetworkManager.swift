//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Ilya Pavlov on 14.08.2023.
//

import Foundation

class NetworkManager {
    /* работа с помощью completionHandler
    func fetchCurrentWeather(forCity city: String, completionHandler: @escaping (CurrentWeather) -> (Void)) {
     */
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric"
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
    func parseJSON(withData data: Data) -> CurrentWeather? {
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
