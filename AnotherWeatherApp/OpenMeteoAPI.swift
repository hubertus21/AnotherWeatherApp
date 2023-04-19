//
//  OpenMeteoAPI.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 16/04/2023.
//

import Foundation
import Alamofire
import RxSwift

class OpenMeteoAPI {
    let searchUrl = "https://geocoding-api.open-meteo.com/v1/search"
    let forecastUrl = "https://api.open-meteo.com/v1/forecast"
    
    let units = WeatherUnits(temperature: "°C", relativeHumidity: "%", precipitationProbability: "%", precipitation: "mm")
    
    func searchForCities(name: String) -> Observable<CitySearchResponse> {
        let params = [
            "name" : name,
            "count" : "100",
            "language" : "en"
        ]
        return getAndDecodeJson(searchUrl, params)
    }
    
    func getHourlyForecast(latitude: Double, longitude: Double) -> Observable<HourlyWeatherResponse> {
        let params = [
            "latitude" : latitude.description,
            "longitude" : longitude.description,
            "hourly" : "temperature_2m,relativehumidity_2m,apparent_temperature,precipitation,weathercode,pressure_msl"
        ]
        return getAndDecodeJson(forecastUrl, params)
    }
    
    func getDailyForecast(latitude: Double, longitude: Double) -> Observable<DailyWeatherResponse> {
        let params = [
            "latitude" : latitude.description,
            "longitude" : longitude.description,
            "timezone" : "UTC",
            "forecast_days" : "16",
            "daily" : "weathercode,temperature_2m_max,temperature_2m_min,precipitation_probability_max"
        ]
        return getAndDecodeJson(forecastUrl, params)
    }
    
    fileprivate func getAndDecodeJson<T : Decodable>(_ url: String, _ params: [String : String]) -> Observable<T> {
        return .create({ subscription in
            AF.request(url, parameters: params).response { dataResponse in
                let decoder = JSONDecoder()
                do {
                    print("DEBUG", String(data: dataResponse.data!, encoding: .utf8))
                    let result = try decoder.decode(T.self, from: dataResponse.data ?? Data())
                    subscription.onNext(result)
                }catch {
                    subscription.onError(error)
                }
            }
            
            return Disposables.create()
        })
    }
}
