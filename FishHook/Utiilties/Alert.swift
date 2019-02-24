//
//  Alerts.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/23/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    // Create functions to issue alerts
    static func basicAlert(title: String, message: String, Button: String) -> UIAlertController{
        
        // Create functions to create alerts.
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: Button, style: .default, handler: nil)
        alert.addAction(ok)
        
        return alert
    }
}
