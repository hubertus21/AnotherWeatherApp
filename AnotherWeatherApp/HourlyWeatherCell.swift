//
//  HourlyWeatherCell.swift
//  AnotherWeatherApp
//
//  Created by Hubert Drogosz on 17/04/2023.
//

import Foundation
import UIKit

class HourlyWeatherCell : UICollectionViewCell {
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var temperatureLabel : UILabel!
    @IBOutlet weak var precipitationLabel : UILabel!
    
    func setup(temperature: Double, temperatureUnit: String, time: Date, precipitation: Double) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM HH:mm"
        
        timeLabel.text = dateFormatter.string(from: time)
        temperatureLabel.text = "\(temperature) \(temperatureUnit)"
        precipitationLabel.text = "\(precipitation) mm"
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        let red = min(max(temperature, 0),30)/30
        let blue = 1 - red
        self.backgroundColor = .init(red: red, green: 1, blue: blue , alpha: 0.8)
    }
    
}
