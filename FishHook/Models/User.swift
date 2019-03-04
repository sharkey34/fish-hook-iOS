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
    var admin: Bool
    var firstName: String
    var lastName: String
    var email: String
    
    // Super init
    init(_uid:String,_admin: Bool, _first:String,_last:String,_email:String) {
        self.uid = _uid
        self.admin = _admin
        self.firstName = _first
        self.lastName = _last
        self.email = _email
    }
    
    // Decoding and assigning properties
    required init?(coder aDecoder: NSCoder) {

        self.uid = (aDecoder.decodeObject(forKey: "uid") as! String)
        self.admin = (aDecoder.decodeBool(forKey: "admin"))
        self.firstName = (aDecoder.decodeObject(forKey: "first") as! String)
        self.lastName = (aDecoder.decodeObject(forKey: "last") as! String)
        self.email = (aDecoder.decodeObject(forKey: "email") as! String)
    }
    
    // Encoding properties
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(admin, forKey: "admin")
        aCoder.encode(firstName, forKey: "first")
        aCoder.encode(lastName, forKey: "last")
        aCoder.encode(email, forKey: "email")        
    }
}
