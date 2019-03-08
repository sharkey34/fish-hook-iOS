//
//  Global.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/1/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

struct Global {
    static var tournament = Tournament(_id: nil, _name: nil, _logo: nil, _created: nil, _divisions: [Division](), _fishSpecies: [Fish](), _participants: [String](), _waterType: [String](), _metrics: [String](), _startDate: nil, _endDate: nil, _startTime: nil, _endTime: nil, _code: nil)
    
    static var divisions = [Division]()
    
    static var awards = [Award]()
}