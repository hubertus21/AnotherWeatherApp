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
    func searchForCities(name: String) -> Observable<CityQuery> {
        return .create({ subscription in
            let params = [
                "name" : name,
                "count" : "100",
                "language" : "en"
            ]
            AF.request("https://geocoding-api.open-meteo.com/v1/search", parameters: params).response { dataResponse in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let result = try decoder.decode(CityQuery.self, from: dataResponse.data!)
                    subscription.onNext(result)
                }catch {
                    subscription.onError(error)
                }
            }
            
            return Disposables.create()
        })
    }
    
    func getHourlyForecast(latitude: Double, longitude: Double) -> Observable<WeatherForecastResponse> {
        return .create({ subscription in
            let params = [
                "latitude" : latitude.description,
                "longitude" : longitude.description,
                "hourly" : "temperature_2m,relativehumidity_2m,apparent_temperature,precipitation,weathercode,pressure_msl"
            ]
            AF.request("https://api.open-meteo.com/v1/forecast", parameters: params).response { dataResponse in
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(WeatherForecastResponse.self, from: dataResponse.data!)
                    subscription.onNext(result)
                }catch {
                    subscription.onError(error)
                }
            }
            
            return Disposables.create()
        })
    }
    
    func getDailyForecast(latitude: Double, longitude: Double) -> Observable<WeatherDailyForecastResponse> {
        return .create({ subscription in
            let params = [
                "latitude" : latitude.description,
                "longitude" : longitude.description,
                "timezone" : "UTC",
                "forecast_days" : "16",
                "daily" : "weathercode,temperature_2m_max,temperature_2m_min,precipitation_probability_max"
            ]
            AF.request("https://api.open-meteo.com/v1/forecast", parameters: params).response { dataResponse in
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(WeatherDailyForecastResponse.self, from: dataResponse.data!)
                    subscription.onNext(result)
                }catch {
                    subscription.onError(error)
                }
            }
            
            return Disposables.create()
        })
    }
}
