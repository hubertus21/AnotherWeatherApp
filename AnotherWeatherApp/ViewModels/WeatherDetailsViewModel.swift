//
//  WeatherDetailsViewModel.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 16/04/2023.
//

import Foundation
import RxSwift
import RxRelay

class WeatherDetailsViewModel {
    private let api = OpenMeteoAPI()
    private var hourlyUnits : [String: String] = [:]
    let city : City
    
    var currentTemperature = BehaviorRelay<Double?>(value: nil)
    var apparentTemperature = BehaviorRelay<Double?>(value: nil)
    var precipitation = BehaviorRelay<Double?>(value: nil)
    var weatherDescription = BehaviorRelay<String>(value: "")
    var hourlyForecasts = BehaviorRelay<[HourlyForecast]>(value: [])
    var dailyForecasts = BehaviorRelay<[DailyForecast]>(value: [])
    let disposeBag = DisposeBag()
    
    var units : WeatherUnits {
        api.units
    }
    
    init(city: City) {
        self.city = city
    }
    
    func getForecast() {
        api.getHourlyForecast(latitude: city.latitude, longitude: city.longitude).subscribe(onNext: { response in
            let forecasts = response.hourly.groupByHours()
            let currentHour = Calendar.current.component(.hour, from: Date())
            let currentForecast = forecasts[currentHour]
            
            self.hourlyForecasts.accept(forecasts)
            self.currentTemperature.accept(currentForecast.temperature)
            self.apparentTemperature.accept(currentForecast.apparentTemperature)
            self.weatherDescription.accept(WMOCodeTranslator.describe(wmoCode: currentForecast.weatherCode))
            self.precipitation.accept(currentForecast.precipitation)
        }).disposed(by: disposeBag)
        
        api.getDailyForecast(latitude: city.latitude, longitude: city.longitude).subscribe(onNext: {
            print($0)
            self.dailyForecasts.accept($0.daily.groupByDay())
        }).disposed(by: disposeBag)
    }
}
