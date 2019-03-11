//
//  FireStore.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/11/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FireStoreHelper {
    
    
    var db: Firestore {
        get {
            return Firestore.firestore()
        }
    }
    
   public func fetchDivisions(tID: String) -> [Division] {
        var divisions = [Division]()
        
        db.collection("divisions").whereField("tID", isEqualTo: tID).getDocuments { (documents, error) in
            
            guard let document = documents?.documents else {return}
            
            for doc in document {
                let map = doc.data()
                
                let dID = doc.documentID
                let name = map["name"] as! String
                let tID = map["tID"] as! String
                let sponsor = map["sponsor"] as? String
                divisions.append(Division(_id: dID, _tID: tID, _name: name, _sponsor: sponsor, _awards: nil))
            }
        }
        return divisions
    }
}
