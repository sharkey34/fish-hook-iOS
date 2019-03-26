//
//  Weather.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/25/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

struct MarineWeather {
    
    var temp: String?
    var weatherDesc: String?
    var windSpeed: String?
    var windDirection: String?
    var visibility: String?
    var swellHeight: String?
    var waterTemp: String?
    
    
    init(_temp: String?, _weatherDesc: String?, _windSpeed: String?, _visibility: String?, _windDirection: String?, _swellHeight: String?, _waterTemp: String?) {
        
        self.temp = _temp
        self.weatherDesc = _weatherDesc
        self.windSpeed = _windSpeed
        self.windDirection = _windDirection
        self.visibility = _visibility
        self.swellHeight = _swellHeight
        self.waterTemp = _waterTemp
    }
}
