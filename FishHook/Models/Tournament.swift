//
//  Tournament.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/24/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation
import UIKit

class Tournament {
    
    var id: String?
    var code: String?
    var name: String?
    var participants: [String]?
    var waterType = [String]()
    var metrics = [String]()
    var logo: UIImage?
    var created: String?
    var divisions = [Division]()
    var fishSpecies = [Fish]()
    var startDate: String?
    var endDate: String?
    var startTime: String?
    var endTime: String?
    
    init(_id: String?, _name: String?, _logo: UIImage?, _created: String?, _divisions: [Division], _fishSpecies: [Fish], _participants: [String], _waterType: [String], _metrics: [String], _startDate: String?, _endDate: String?, _startTime: String?, _endTime: String?, _code: String? ) {
        self.id = _id
        self.name = _name
        self.logo = _logo
        self.created = _created
        self.divisions = _divisions
        self.fishSpecies = _fishSpecies
        self.participants = _participants
        self.waterType = _waterType
        self.metrics = _metrics
        self.startDate = _startDate
        self.endDate = _endDate
        self.startTime = _startTime
        self.endTime = _endTime
        self.code = _code
    }
}
