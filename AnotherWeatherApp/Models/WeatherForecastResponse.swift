//
//  WeatherForecastResponse.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 16/04/2023.
//

import Foundation

struct WeatherForecastResponse : Codable {
    var hourly : HourlyForecastResponse
    var hourlyUnits : [String: String]
    enum CodingKeys : String, CodingKey {
        case hourly
        case hourlyUnits = "hourly_units"
    }
}

struct HourlyForecastResponse : Codable {
    var time : [String]
    var temperature : [Double]
    var relativeHumidity : [Double]
    var precipitation : [Double]
    var apparentTemperature : [Double]
    var weatherCode : [Int]
    var pressureAtSeaLevel : [Double]
    
    enum CodingKeys : String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case relativeHumidity = "relativehumidity_2m"
        case precipitation
        case apparentTemperature = "apparent_temperature"
        case weatherCode = "weathercode"
        case pressureAtSeaLevel = "pressure_msl"
        
    }
    
    func toHourlyForecasts() -> [HourlyForecast] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        return (0..<time.count).map { i in
            HourlyForecast(time: dateFormatter.date(from:time[i])!, temperature: temperature[i], relativeHumidity: relativeHumidity[i], precipitation: precipitation[i], apparentTemperature: apparentTemperature[i], weatherCode: weatherCode[i], pressureAtSeaLevel: pressureAtSeaLevel[i])
        }
    }
}

struct WeatherDailyForecastResponse : Codable {
    var daily : DailyForecastResponse
    var dailyUnits : [String: String]
    enum CodingKeys : String, CodingKey {
        case daily
        case dailyUnits = "daily_units"
    }
}

struct DailyForecastResponse : Codable {
    var time : [String]
    var precipitationProbability : [Int?]
    var minTemperature : [Double]
    var maxTemperature : [Double]
    var weatherCode : [Int]
    
    enum CodingKeys : String, CodingKey {
        case time
        case minTemperature = "temperature_2m_min"
        case maxTemperature = "temperature_2m_max"
        case precipitationProbability = "precipitation_probability_max"
        case weatherCode = "weathercode"
        
    }
    
    func toDailyForecasts() -> [DailyForecast] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return (0..<time.count).map { i in
            DailyForecast(time: dateFormatter.date(from: time[i])!, minTemperature: minTemperature[i], maxTemperature: maxTemperature[i], precipitationProbability: precipitationProbability[i], weatherCode: weatherCode[i])
        }
    }
}
