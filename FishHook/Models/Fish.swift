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
    
    init(name: String, type: Int, checked: Bool, weight: Double?, length: Double?) {
        self.name = name
        self.type = type
        self.checked = checked
        self.weight = weight
        self.Length = length
    }
}
