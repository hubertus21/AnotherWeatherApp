//
//  DailyForecastCell.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 18/04/2023.
//

import Foundation
import UIKit

class DailyForecastCell : UITableViewCell {
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var weatherDescriptionLabel : UILabel!
    @IBOutlet weak var temperaturesLabel : UILabel!
    @IBOutlet weak var precipitationProbabilityLabel : UILabel!
    
    func setup(_ dailyForecast : DailyForecast, _ units: WeatherUnits) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        dateLabel.text = dateFormatter.string(from: dailyForecast.time)
        
        weatherDescriptionLabel.text = WMOCodeTranslator.describe(wmoCode: dailyForecast.weatherCode)
        temperaturesLabel.text = "Temp: \(dailyForecast.minTemperature.description) - \(dailyForecast.maxTemperature.description) \(units.temperature)"
        precipitationProbabilityLabel.text = "Precipitation: \(dailyForecast.precipitationProbability?.description ?? "-") \(units.precipitationProbability)"
        
        let red = min(max(dailyForecast.maxTemperature, 0), 30) / 30
        let blue = 1 - red
        self.backgroundColor = .init(red: red, green: 1, blue: blue , alpha: 0.5)
    }
}
