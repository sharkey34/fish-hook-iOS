//
//  OfficialCatch.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/11/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation
import UIKit

class Catch {
    
    var id: String
    var aID: String?
    var userName: String
    var place: Int?
    var userID: String
    var metric: String
    var fish: String
    var image: UIImage?
    var imageID: String?
    var tID: String?
    var lat: String?
    var long: String?
    
    init(_id: String, _aID: String?, _userName: String, _place: Int?, _userID: String, _metric: String, _fish: String, _image: UIImage?, _imageID: String?, _tID: String?, _lat: String?, _long: String?) {
        self.id = _id
        self.aID = _aID
        self.userName = _userName
        self.place = _place
        self.userID = _userID
        self.metric = _metric
        self.fish = _fish
        self.image = _image
        self.imageID = _imageID
        self.tID = _tID
        self.lat = _lat
        self.long = _long
    }
}
