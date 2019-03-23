//
//  WeatherVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let key = getKeys() {
            print(key)
            
        }
    }
    
    // Getting the api key from the plist
    func getKeys() -> String? {
        guard let keyPath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {return nil}
        
        let keys = NSDictionary(contentsOfFile: keyPath)
        guard let dict = keys else {return nil}
        
        
        return dict.object(forKey: "WeatherAPI") as? String

    }
}
