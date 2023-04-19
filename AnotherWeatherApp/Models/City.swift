//
//  City.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 16/04/2023.
//

import Foundation
import RealmSwift

class City : Object, Codable {
    @Persisted var name : String
    @Persisted var latitude : Double
    @Persisted var longitude : Double
    @Persisted var admin1 : String?
    @Persisted var admin2 : String?
    @Persisted var admin3 : String?
    @Persisted var admin4 : String?
    @Persisted var countryCode : String
    
    var locationDescription: String {
        [name, admin4, admin3, admin2, admin1, countryCode]
            .compactMap({ $0 })
            .joined(separator: ", ")
    }
}
