//
//  SavedSearches.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 16/04/2023.
//

import Foundation
import RxSwift
import RealmSwift

class SavedSearches {
    let realmDb : Realm
    
    init?() {
        guard let realmDb = try? Realm() else {
            return nil
        }
        self.realmDb = realmDb
    }
    
    func addChosen(city: City) {
        try? realmDb.write {
            realmDb.add(city)
        }
    }
    
    func getChosenCities() -> [City] {
        realmDb.objects(City.self).filter { _ in true }
    }
}
