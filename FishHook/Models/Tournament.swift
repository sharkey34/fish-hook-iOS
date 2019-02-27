//
//  Tournament.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/24/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation
import UIKit

class Tournaments {
    
    var id: String
    var name: String
    var image: UIImage?
    var created: String
    
    
    init(_id: String, _name: String, _image: UIImage, _created: String) {
        self.id = _id
        self.name = _name
        self.image = _image
        self.created = _created
    }
}
