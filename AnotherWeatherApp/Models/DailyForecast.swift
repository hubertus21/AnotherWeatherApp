//
//  DailyForecast.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 19/04/2023.
//

import Foundation

struct DailyForecast {
    var time : Date
    var minTemperature : Double
    var maxTemperature : Double
    var precipitationProbability : Int?
    var weatherCode : Int
}
