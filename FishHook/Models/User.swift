//
//  User.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/23/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    // properties
    var uid: String
    var firstName: String
    var lastName: String
    var email: String
    
    // Super init
    init(uid:String,first:String,last:String,email:String) {
        self.uid = uid
        self.firstName = first
        self.lastName = last
        self.email = email
    }
    
    // Decoding and assigning properties
    required init?(coder aDecoder: NSCoder) {
        self.uid = aDecoder.decodeObject(forKey: "uid") as! String
        self.firstName = aDecoder.decodeObject(forKey: "first") as! String
        self.lastName = aDecoder.decodeObject(forKey: "last") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
    }
    
    // Encoding properties
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(firstName, forKey: "first")
        aCoder.encode(lastName, forKey: "last")
        aCoder.encode(email, forKey: "email")        
    }
}
