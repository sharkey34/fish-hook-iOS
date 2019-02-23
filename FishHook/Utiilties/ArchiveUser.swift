//
//  ArchiveUser.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/23/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation

extension UserDefaults{
    
    // Archiving User data to user defaults.
    func set(currentUser: User, forKey key: String) throws {
        let binaryData = try NSKeyedArchiver.archivedData(withRootObject: currentUser, requiringSecureCoding: false)
        self.set(binaryData, forKey: key)
    }
    
    // Unarchiving User Data from user defaults.
    func currentUser(forKey key: String) throws -> User?{
        if let binaryData = data(forKey: key){
            if let currentUser = try NSKeyedUnarchiver.unarchivedObject(ofClass: User.self, from: binaryData) {
                return currentUser
            }
        }
        return nil
    }
}

