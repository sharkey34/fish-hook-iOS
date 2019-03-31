//
//  Utils.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/26/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation
import UIKit

struct Utils {
    
    
    // Create functions to issue alerts
    static func basicAlert(title: String, message: String, Button: String) -> UIAlertController {
        
        // Create functions to create alerts.
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: Button, style: .default, handler: nil)
        alert.addAction(ok)
        
        return alert
    }
    
    // TODO:
    // Bolding specific part of string
    static func boldCharactersInRangeOf(text: String, boldText: String) -> NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string: text as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25.0)])
    
        let boldAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25.0)]
    
        attributedString.addAttribute(NSAttributedString.Key.font, value: boldAttribute, range: NSRangeFromString(boldText))
        
        return attributedString
    }
    
    // Resetting values
    static func resetGlobal(){
        Global.tournament = Tournament(_id: nil, _name: nil, _logo: nil, _created: nil, _divisions: [Division](), _fishSpecies: [Fish](), _participants: [String](), _waterType: [String](), _metrics: [String](), _startDate: nil, _endDate: nil, _startTime: nil, _endTime: nil, _code: nil, _isActive: false, _imageID: nil, _dates: [Date]())
        
        Global.edit = false
        Global.divisions = [Division]()
        Global.awards = [Award]()
    }
}
