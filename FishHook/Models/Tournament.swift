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
    
    
    init(id: String, name: String, image: UIImage, created: String) {
        self.id = id
        self.name = name
        self.image = image
        self.created = created
    }
}
