//
//  Fish.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/26/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

class Fish {
    var name: String
    var type: Int
    var checked: Bool
    var weight: Double?
    var Length: Double?
    
    init(_name: String, _type: Int, _checked: Bool, _weight: Double?, _length: Double?) {
        self.name = _name
        self.type = _type
        self.checked = _checked
        self.weight = _weight
        self.Length = _length
    }
}
