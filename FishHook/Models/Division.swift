//
//  Division.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/26/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

class Division: NSObject, NSCoding {

    var id: String?
    var name: String?
    var sponsor: String?
    var awards: [Award]?
    
    init(_id: String?, _name: String?, _sponsor: String?, _awards: [Award]?) {
        self.id = _id
        self.name = _name
        self.sponsor = _sponsor
        self.awards = _awards
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(sponsor, forKey: "sponsor")
        aCoder.encode(awards, forKey: "awards")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.sponsor = aDecoder.decodeObject(forKey: "sponsor") as? String
        self.awards = aDecoder.decodeObject(forKey: "awards") as? [Award]
    }
}
