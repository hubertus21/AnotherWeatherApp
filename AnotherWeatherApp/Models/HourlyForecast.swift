//
//  HourlyForecast.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 16/04/2023.
//

import Foundation

struct HourlyForecast {
    var time : Date
    var temperature : Double
    var relativeHumidity : Double
    var precipitation : Double
    var apparentTemperature : Double
    var weatherCode : Int
    var pressureAtSeaLevel : Double
}
