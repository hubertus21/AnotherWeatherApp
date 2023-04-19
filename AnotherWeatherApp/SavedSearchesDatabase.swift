//
//  SavedSearchesDatabase.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 16/04/2023.
//

import Foundation
import RxSwift
import RealmSwift

class SavedSearchesDatabase {
    let realmDb : Realm?
    
    init() {
        self.realmDb = try? Realm()
    }
    
    func addChosen(city: City) {
        try? realmDb?.write {
            realmDb?.add(city)
        }
    }
    
    func getChosenCities() -> [City] {
        realmDb?.objects(City.self).filter { _ in true } ?? []
    }
}
