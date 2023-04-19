//
//  WeatherDetailsViewController.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 16/04/2023.
//

import Foundation
import UIKit
import RxSwift

class WeatherDetailsViewController : UIViewController {
    @IBOutlet weak var cityNameLabel : UILabel!
    @IBOutlet weak var currentTemperatureLabel : UILabel!
    @IBOutlet weak var apparentTemperatureLabel : UILabel!
    @IBOutlet weak var precipitationLabel : UILabel!
    @IBOutlet weak var weatherDescriptionLabel : UILabel!
    @IBOutlet weak var hourlyWeatherCollection : UICollectionView!
    @IBOutlet weak var dailyWeatherTable : UITableView!
    
    var viewModel: WeatherDetailsViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getForecast()
        cityNameLabel.text = viewModel?.city.name
        viewModel?.currentTemperature.map { $0?.description ?? "-" }.map{ "Temperature: \($0) \(self.viewModel?.temperatureUnit ?? "")" }.bind(to: currentTemperatureLabel.rx.text).disposed(by: disposeBag)
        viewModel?.currentTemperature.compactMap{ $0 }.map {
            if $0 < 10 {
                return .blue
            }else if $0 >= 10 && $0 <= 20 {
                return .black
            }else {
                return .red
            }
        }.bind(to: currentTemperatureLabel.rx.textColor).disposed(by: disposeBag)
        viewModel?.weatherDescription.bind(to: weatherDescriptionLabel.rx.text).disposed(by: disposeBag)
        
        viewModel?.precipitation.map { "Precipitation: \($0?.description ?? "-") mm" }.bind(to: precipitationLabel.rx.text).disposed(by: disposeBag)
        
        viewModel?.apparentTemperature.map { "Apparent temperature: \($0?.description ?? "-") \(self.viewModel?.temperatureUnit ?? "")" }.bind(to: apparentTemperatureLabel.rx.text).disposed(by: disposeBag)
        viewModel?.hourlyForecasts.bind(to: hourlyWeatherCollection.rx.items(cellIdentifier: "HourlyWeather", cellType: HourlyWeatherCell.self)) { _, element, cell in
            cell.setup(temperature: element.temperature, temperatureUnit: self.viewModel?.temperatureUnit ?? "", time: element.time, precipitation: element.precipitation)
        }.disposed(by: disposeBag)
        
        viewModel?.dailyForecasts.bind(to: dailyWeatherTable.rx.items(cellIdentifier: "DailyForecast", cellType: DailyForecastCell.self)) {
            _, element, cell in
            cell.setup(dailyForecast: element)
        }.disposed(by: disposeBag)
    }
}
