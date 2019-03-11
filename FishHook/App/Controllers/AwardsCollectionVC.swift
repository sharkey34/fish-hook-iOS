//
//  AwardsCollectionVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/11/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore


class AwardsCollectionVC: UICollectionViewController {
    
    var dID: String?
    var aID: String?
    var awards = [Award]()
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()

        // TODO: Fetching the awards.
        fetchAwards()
    }
    
    // Fetching the awards for the chosen division from fireStore.
    func fetchAwards(){
        guard let id = dID else {return}
        db.collection("awards").whereField("dID", isEqualTo: id).getDocuments { (documents, error) in
            if let err = error {
                let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated:  true, completion: nil)
            }
            guard let docs = documents?.documents else {return}
            
            for doc in docs {
                let map = doc.data()
                let id = doc.documentID
                let name = map["name"] as! String
                let fish = map["fish"] as! String
                let prizes = map["prizes"] as! [String]
                let sponsor = map["sponsor"] as? String
                
                self.awards.append(Award(_id: id, _name: name, _sponsor: sponsor, _prizes: prizes, _fishSpecies: fish))
            }
            self.collectionView.reloadData()
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return awards.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AwardsCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }
        // Configure the cell
        cell.awardsIV.image = UIImage(named: "Awards")
        cell.awardsLabel.text = awards[indexPath.row].name
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Transition to official posts for the specific division and award.
        
        aID = awards[indexPath.row].id
        performSegue(withIdentifier: "toOfficial", sender: self)
    }
    
    // Sending Award Id to official Leaderboard.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toOfficial" {
            guard let oVC = segue.destination as? OfficialVC else {return}
            oVC.aID = aID
        }
    }
}
