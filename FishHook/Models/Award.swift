//
//  Award.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/26/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

class Award: NSObject, NSCoding {

    var name: String?
    var sponsor: String?
    var fishSpecies: String?
    var prizes: [String]?
    
    init(_name: String?, _sponsor: String?, _prizes: [String]?, _fishSpecies: String?) {
        self.name = _name
        self.sponsor = _sponsor
        self.prizes = _prizes
        self.fishSpecies = _fishSpecies
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(sponsor, forKey: "sponsor")
        aCoder.encode(fishSpecies, forKey: "fish")
        aCoder.encode(prizes, forKey: "prizes")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.sponsor = aDecoder.decodeObject(forKey: "sponsor") as? String
        self.fishSpecies = aDecoder.decodeObject(forKey: "fish") as? String
        self.prizes = aDecoder.decodeObject(forKey: "prizes") as? [String]
    }
}
