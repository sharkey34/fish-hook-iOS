//
//  DivisionsCollectionViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore


class DivisionsCollectionVC: UICollectionViewController {
    
    var divisions = [Division]()
    var dID: String?
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        divisions.removeAll()
        // Fetch Divisions
        print(UserDefaults.standard.string(forKey: "activeTournament"))
        if let tID = UserDefaults.standard.string(forKey: "activeTournament") {
            print("tournament ID \(tID)")
            fetchDivisions(tID: tID)
        } else {
            let alert = Utils.basicAlert(title: "No Tournament Active", message: "Please add a tournament to continue", Button: "OK")
            present(alert, animated: true, completion: nil)
        }
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return divisions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DivsionCollectionViewCell else {return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)}
    
        // Configure the cell
        cell.divisionIV.image = UIImage(named: "Division")
        cell.divisionLabel.text = divisions[indexPath.row].name
        // TODO: Add Sponsored by.
        return cell
    }
    
    // Fetching Divisions from FireStore.
    func fetchDivisions(tID: String){
        db.collection("divisions").whereField("tID", isEqualTo: tID).getDocuments { (documents, error) in
            
            if let err = error {
                let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
  
            } else {
                guard let docs = documents?.documents else {return}
                print(docs.count)
                for doc in docs {
                    let map = doc.data()
                    let dID = doc.documentID
                    let name = map["name"] as! String
                    let tID = map["tID"] as! String
                    let sponsor = map["sponsor"] as? String
                    self.divisions.append(Division(_id: dID, _tID: tID, _name: name, _sponsor: sponsor, _awards: nil))
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    // Getting the selected dID and performing Segue
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dID = divisions[indexPath.row].id
        performSegue(withIdentifier: "toAwards", sender: self)
    }
    
    // Sending the selected division ID to the awards controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAwards" {
            guard let aVC = segue.destination as? AwardsCollectionVC else {return}
            aVC.dID = dID
        }
    }
}
