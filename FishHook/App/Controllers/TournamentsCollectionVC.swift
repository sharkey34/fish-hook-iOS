//
//  AdminTournamentsCollectionViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

private let reuseIdentifier = "Cell"

class TournamentsCollectionVC: UICollectionViewController {
    
    var db: Firestore?
    var storage: Storage?
    var currentUser: User?
    var editingTournaments = false
    
    // TODO: Make this double for both Admins and regular users.
    var tournaments = [Tournament]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        db = Firestore.firestore()
        storage = Storage.storage()
        currentUser = UserDefaults.standard.currentUser(forKey: "currentUser")

        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = "Dashboard"
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
           navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editSelected(sender:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tournaments.count > 0 {
            tournaments.removeAll()
        }
        fetchTournamentIDS()
    }
    
    @objc func editSelected(sender: UIBarButtonItem){
//        editingTournaments = !editingTournaments
//
//        if editingTournaments {
//            for cell in collectionView.visibleCells {
//                cell.backgroundColor = UIColor.red
//            }
//        } else {
//            for cell in collectionView.visibleCells {
//                cell.backgroundColor = UIColor.white
//            }
//        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tournaments.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AdminDashboardCollectionCell else {return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)}
        // Configure the cell
        if indexPath.row == tournaments.count || tournaments.count == 0 {
            // Add image
            cell.tournamentImage.image = UIImage(named: "Plus")
            cell.dateLabel.text = ""
        } else {
            let t = tournaments[indexPath.row]
            let dates = "\(t.startDate!) - \(t.endDate!)"
            // Normal setup
            // TODO: Get and set image from storage.
            cell.tournamentImage.image = UIImage(named: "DefaultTournament")
            cell.dateLabel.text = dates
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: If add button selected then segue to tournament creation else go to details of tournament.
        guard let user = currentUser else {return}
        
        if user.admin {
            if indexPath.row == tournaments.count || tournaments.count == 0 {
                performSegue(withIdentifier: "toTournament", sender: self)
            } else {
                // TODO ORRR make this the active tournament.
            }
        } else {
            // TODO: Pop up modal for user to add a tournament.
            if indexPath.row == tournaments.count || tournaments.count == 0 {
                presentAddModal()
            } else {
                // TODO ORRR make this the active tournament.
            }
        }
    }
    
    
    // Setting up and presenting modal to add a tournament
    func presentAddModal(){
        let addController = UIAlertController(title: "Add Tournament Code", message: "", preferredStyle: .alert)
        
        addController.addTextField { (textField) in
            textField.placeholder = "Tournament Code"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let codeOptional = addController.textFields?.first?.text
            
            if let code = codeOptional {
                self.fetchTournamentByCode(code: code)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        addController.addAction(cancelAction)
        addController.addAction(addAction)
        
        present(addController, animated: true, completion: nil)
    }
    
    
    func addTournamentToUser(id: String){
        guard let uid = currentUser?.uid else {return}
        
        // Adding tournament code to user
        db?.collection("users").document(uid).updateData(
            [
                "tournaments": FieldValue.arrayUnion([id])
            ], completion: { (err) in
                if let error = err {
                    let alert = Utils.basicAlert(title: "Error", message: error.localizedDescription, Button: "OK")
                    self.present(alert, animated: true, completion: nil)
                }
        })
    }
    
    func fetchTournamentByCode(code: String){
        
        db?.collection("tournaments").whereField("code", isEqualTo: code).getDocuments(completion: { (doc, err) in
            // TODO: Retrieve the tournament document.
            
            if let documents = doc?.documents {
                
                for document in documents {
                    let map = document.data()
                    
                    let id = document.documentID
                    let code = map["code"] as! String
                    let name = map["name"] as! String
                    let participants = map["participants"] as! [String]
                    let waterType = map["waterType"] as! [String]
                    let metrics = map["metrics"] as! [String]
                    let startDate = map["startDate"] as! String
                    let startTime = map["startTime"] as! String
                    let endDate = map["endDate"] as! String
                    let endTime = map["endTime"] as! String
                    
                    self.tournaments.append(Tournament(_id: id, _name: name, _logo: nil, _created: nil, _divisions: [Division](), _fishSpecies: [Fish](), _participants: participants, _waterType: waterType, _metrics: metrics, _startDate: startDate, _endDate: endDate, _startTime: startTime, _endTime: endTime, _code: code))
                    self.addTournamentToUser(id: id)
                    
                    self.collectionView.reloadData()
                    
                    return
                }
            } else if let error = err {
                let alert = Utils.basicAlert(title: "Error", message: error.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    // Getting the ids for the user.
    func fetchTournamentIDS(){
        var userTournamentIDs = [String]()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        db?.collection("users").document(userID).getDocument(completion: { (doc, err) in
            if let map = doc?.data() {
                guard let ids = map["tournaments"] as? [String] else {return}

                for id in ids {
                    userTournamentIDs.append(id)
                }
                self.fetchTournaments(tournamentIDS: userTournamentIDs)
                
            } else if let error = err {
                let alert = Utils.basicAlert(title: "Error", message: error.localizedDescription, Button: "OK")
                self.present(alert,animated: true,completion: nil)
            }
        })
    }
    
    // Fetching tournaments from the ids
    func fetchTournaments(tournamentIDS: [String]){
        for tournament in tournamentIDS {
            db?.collection("tournaments").document(tournament).getDocument(completion: { (doc, err) in
                
                if let map = doc?.data() {
                    
                    let code = map["code"] as! String
                    let name = map["name"] as! String
                    let participants = map["participants"] as! [String]
                    let waterType = map["waterType"] as! [String]
                    let metrics = map["metrics"] as! [String]
                    let startDate = map["startDate"] as! String
                    let startTime = map["startTime"] as! String
                    let endDate = map["endDate"] as! String
                    let endTime = map["endTime"] as! String
                    
                    self.tournaments.append(Tournament(_id: nil, _name: name, _logo: nil, _created: nil, _divisions: [Division](), _fishSpecies: [Fish](), _participants: participants, _waterType: waterType, _metrics: metrics, _startDate: startDate, _endDate: endDate, _startTime: startTime, _endTime: endTime, _code: code))
                    
                    self.collectionView.reloadData()
                } else if let error = err {
                    let alert = Utils.basicAlert(title: "Error", message: error.localizedDescription, Button: "OK")
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
}
