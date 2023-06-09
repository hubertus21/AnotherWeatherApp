//
//  SearchViewModel.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 16/04/2023.
//

import Foundation
import RxSwift
import RxRelay

class SearchViewModel {
    private let api = OpenMeteoAPI()
    private let savedSearches = SavedSearchesDatabase()
    private let disposeBag = DisposeBag()
    
    var foundCities = BehaviorRelay<[City]>(value: [])
    var validCityName = BehaviorRelay(value: true)
    
    func setup(searchInput: Observable<String?>) {
        searchInput.compactMap{ $0 }
            .map { [unowned self] in
                self.checkCityWithRegex($0)
            }.bind(to: validCityName)
            .disposed(by: disposeBag)
        
        searchInput.compactMap { $0 }
            .filter { [unowned self] in
                self.checkCityWithRegex($0)
            }.flatMapLatest { [unowned self] in
                self.api.searchForCities(name: $0).asDriver(onErrorJustReturn: CitySearchResponse(results: [])).asObservable()
            }.map {
                $0.results
            }.map { [unowned self] in
                $0.isEmpty ? self.savedSearches.getChosenCities() : $0
            }.bind(to: foundCities)
            .disposed(by: disposeBag)
        
        foundCities.accept(savedSearches.getChosenCities())
    }
    
    func getDetailsViewModel(indexPath: IndexPath) -> WeatherDetailsViewModel? {
        let foundCities = foundCities.value
        return WeatherDetailsViewModel(city: foundCities[indexPath.row])
    }
    
    func saveCity(indexPath: IndexPath) {
        let foundCities = foundCities.value
        savedSearches.addChosen(city: foundCities[indexPath.row])
    }
    
    func checkCityWithRegex(_ name: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: #"^[A-Za-z]{1}[\w -.]+$"#)
        let range = NSMakeRange(0, name.utf16.count)
        return regex?.matches(in: name, range: range).count == 1
    }
}
