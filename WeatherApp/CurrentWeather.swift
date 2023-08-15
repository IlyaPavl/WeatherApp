//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Ilya Pavlov on 14.08.2023.
//

import Foundation

struct CurrentWeather {
    let cityName: String
    let temperature: Double
    var temperatureString: String {
        "\(temperature.rounded())"
    }
    let feelsLikeTemperature: Double
    var feelsLikeTempString: String {
        "\(feelsLikeTemperature)"
    }
    let conditionCode: Int
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
    
}
