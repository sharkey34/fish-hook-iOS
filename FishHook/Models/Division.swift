//
//  Division.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/26/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

class Division {
    
    var id: String?
    var name: String
    var sponsor: String?
    var awards: [Award]?
    
    
    init(_id: String?, _name: String, _sponsor: String?, _awards: [Award]?) {
        self.id = _id
        self.name = _name
        self.sponsor = _sponsor
        self.awards = _awards
    }
}
