//
//  Award.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/26/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

public class Award: NSObject {

    var id: String?
    var name: String?
    var sponsor: String?
    var fishSpecies: String?
    var prizes: [String]?
    
    init(_id: String?, _name: String?, _sponsor: String?, _prizes: [String]?, _fishSpecies: String?) {
        self.id = _id
        self.name = _name
        self.sponsor = _sponsor
        self.prizes = _prizes
        self.fishSpecies = _fishSpecies
    }
}
