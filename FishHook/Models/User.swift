//
//  User.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/23/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject, NSCoding {
    
    // properties
    var profileImage: UIImage?
    var imageID: String?
    var uid: String
    var admin: Bool
    var firstName: String
    var lastName: String
    var email: String
    var boat: String?
    var captain: String?
    var about: String?
    var phone: String?
    var address: String?
    var organization: String?
    var userName: String
    
    // Super init
    init(_profileImage: UIImage?,_imageID: String?,_uid:String,_admin: Bool, _first:String,_last:String,_email:String, _boat: String?, _captain: String?, _about: String?, _phone: String?, _address: String?, _organization: String?) {
        self.profileImage = _profileImage
        self.imageID = _imageID
        self.uid = _uid
        self.admin = _admin
        self.firstName = _first
        self.lastName = _last
        self.email = _email
        self.boat = _boat
        self.captain = _captain
        self.about = _about
        self.phone = _phone
        self.address = _address
        self.organization = _organization
        self.userName = "\(firstName) \(lastName)"
    }
    
    // Encoding properties
    func encode(with aCoder: NSCoder) {
        aCoder.encode(profileImage, forKey: "profileImage")
        aCoder.encode(imageID, forKey: "imageID")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(admin, forKey: "admin")
        aCoder.encode(firstName, forKey: "first")
        aCoder.encode(lastName, forKey: "last")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(boat, forKey: "boat")
        aCoder.encode(captain, forKey: "captain")
        aCoder.encode(about, forKey: "about")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(organization, forKey: "org")
        aCoder.encode(userName, forKey: "userName")

    }
    
    // Decoding and assigning properties
    required init?(coder aDecoder: NSCoder) {
        self.profileImage = aDecoder.decodeObject(forKey: "profileImage") as? UIImage
        self.imageID = aDecoder.decodeObject(forKey: "imageID") as? String
        self.uid = aDecoder.decodeObject(forKey: "uid") as! String
        self.admin = aDecoder.decodeBool(forKey: "admin")
        self.firstName = aDecoder.decodeObject(forKey: "first") as! String
        self.lastName = aDecoder.decodeObject(forKey: "last") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.boat = aDecoder.decodeObject(forKey: "boat") as? String
        self.captain = aDecoder.decodeObject(forKey: "captain") as? String
        self.about = aDecoder.decodeObject(forKey: "about") as? String
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
        self.address = aDecoder.decodeObject(forKey: "address") as? String
        self.organization = aDecoder.decodeObject(forKey: "org") as? String
        self.userName = aDecoder.decodeObject(forKey: "userName") as! String
    }
}
