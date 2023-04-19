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
        guard let viewModel else { return }
        viewModel.getForecast()
        
        self.setupLabels()
        self.setupTableAndCollectionView()
    }
    
    private func setupLabels() {
        guard let viewModel else { return }
        let units = viewModel.units
        
        cityNameLabel.text = viewModel.city.name
        viewModel.weatherDescription.bind(to: weatherDescriptionLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.currentTemperature
            .map { "Temperature: \($0?.description ?? "-") \(units.temperature)" }
            .bind(to: currentTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.currentTemperature
            .compactMap { $0 }
            .map {
                self.colorForTemperature($0)
            }.bind(to: currentTemperatureLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.precipitation
            .map { "Precipitation: \($0?.description ?? "-") \(units.precipitation)" }
            .bind(to: precipitationLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.apparentTemperature
            .map { "Apparent temperature: \($0?.description ?? "-") \(units.temperature)" }
            .bind(to: apparentTemperatureLabel.rx.text).disposed(by: disposeBag)
    }
    
    private func setupTableAndCollectionView() {
        guard let viewModel else { return }
        let units = viewModel.units
        
        viewModel.hourlyForecasts.bind(to: hourlyWeatherCollection.rx.items(cellIdentifier: "HourlyWeather", cellType: HourlyWeatherCell.self)) { _, hourlyForecast, cell in
            cell.setup(hourlyForecast, units)
        }.disposed(by: disposeBag)
        
        viewModel.dailyForecasts.bind(to: dailyWeatherTable.rx.items(cellIdentifier: "DailyForecast", cellType: DailyForecastCell.self)) {
            _, dailyForecast, cell in
            cell.setup(dailyForecast, units)
        }.disposed(by: disposeBag)
    }
    
    fileprivate func colorForTemperature(_ temp: Double) -> UIColor {
        if temp < 10 {
            return .blue
        }else if temp >= 10 && temp <= 20 {
            return .black
        }else {
            return .red
        }
    }
}
