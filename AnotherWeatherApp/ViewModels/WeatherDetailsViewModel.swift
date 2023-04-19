//
//  WeatherDetailsViewModel.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 16/04/2023.
//

import Foundation
import RxSwift

class WeatherDetailsViewModel {
    private let api = OpenMeteoAPI()
    private var hourlyUnits : [String: String] = [:]
    let city : City
    
    var temperatureUnit : String {
        hourlyUnits["temperature_2m"] ?? ""
    }
    
    var currentTemperature = BehaviorSubject<Double?>(value: nil)
    var apparentTemperature = BehaviorSubject<Double?>(value: nil)
    var precipitation = BehaviorSubject<Double?>(value: nil)
    var weatherDescription = BehaviorSubject<String>(value: "")
    var hourlyForecasts = BehaviorSubject<[HourlyForecast]>(value: [])
    var dailyForecasts = BehaviorSubject<[DailyForecast]>(value: [])
    let disposeBag = DisposeBag()
    
    init(city: City) {
        self.city = city
    }
    
    func getForecast() {
        api.getDailyForecast(latitude: city.latitude, longitude: city.longitude).subscribe(onNext: {
            print($0)
            self.dailyForecasts.onNext($0.daily.toDailyForecasts())
        }).disposed(by: disposeBag)
        
        api.getHourlyForecast(latitude: city.latitude, longitude: city.longitude).subscribe(onNext: { response in
            let forecasts = response.hourly.toHourlyForecasts()
            let currentHour = Calendar.current.component(.hour, from: Date())
            let currentForecast = forecasts[currentHour]
            
            self.hourlyUnits = response.hourlyUnits
            self.hourlyForecasts.onNext(forecasts)
            self.currentTemperature.onNext(currentForecast.temperature)
            self.apparentTemperature.onNext(currentForecast.apparentTemperature)
            self.weatherDescription.onNext(WMOCodeTranslator.describe(wmoCode: currentForecast.weatherCode))
            self.precipitation.onNext(currentForecast.precipitation)
        }).disposed(by: disposeBag)
    }
    
    
}
