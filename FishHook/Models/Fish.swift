//
//  Fish.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/26/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

public class Fish: NSObject, NSCoding {
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
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: "type")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(checked, forKey: "checked")
        aCoder.encode(weight, forKey: "weight")
        aCoder.encode(Length, forKey: "length")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? "No Name"
        self.type = aDecoder.decodeObject(forKey: "type") as? Int ?? 0
        self.checked = aDecoder.decodeObject(forKey: "checked") as? Bool ?? false
        self.weight = aDecoder.decodeObject(forKey: "weight") as? Double
        self.Length = aDecoder.decodeObject(forKey: "length") as? Double

    }
}
