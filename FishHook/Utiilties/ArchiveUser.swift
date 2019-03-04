//
//  ArchiveUser.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/23/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

extension UserDefaults{
    
    
    func set(currentUser: User, forKey key: String){
        let binaryData = NSKeyedArchiver.archivedData(withRootObject: currentUser)
        self.set(binaryData, forKey: key)
    }
    
    func currentUser(forKey key: String) -> User?{
        if let binaryData = data(forKey: key){
            if let currentUser = NSKeyedUnarchiver.unarchiveObject(with: binaryData) as? User {
                return currentUser
            }
        }
        return nil
    }
}

