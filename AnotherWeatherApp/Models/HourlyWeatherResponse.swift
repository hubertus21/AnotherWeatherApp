//
//  WeatherForecastResponse.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 16/04/2023.
//

import Foundation

struct HourlyWeatherResponse : Codable {
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
    
    func groupByHours() -> [HourlyForecast] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        return (0..<time.count).map { i in
            HourlyForecast(time: dateFormatter.date(from:time[i])!, temperature: temperature[i], relativeHumidity: relativeHumidity[i], precipitation: precipitation[i], apparentTemperature: apparentTemperature[i], weatherCode: weatherCode[i], pressureAtSeaLevel: pressureAtSeaLevel[i])
        }
    }
}
