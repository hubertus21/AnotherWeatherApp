//
//  DailyWeatherResponse.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 19/04/2023.
//

import Foundation

struct DailyWeatherResponse : Codable {
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
    
    func groupByDay() -> [DailyForecast] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return (0..<time.count).map { i in
            DailyForecast(time: dateFormatter.date(from: time[i])!, minTemperature: minTemperature[i], maxTemperature: maxTemperature[i], precipitationProbability: precipitationProbability[i], weatherCode: weatherCode[i])
        }
    }
}
