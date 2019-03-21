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
import CoreData

class TournamentsCollectionVC: UICollectionViewController {
    
    var db: Firestore?
    var storage: Storage?
    var currentUser: User?
    var tournaments = [Tournament]()
    var deleteImages = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        fetchTournamentIDS()
    }
    
    // initial setup.
    func setUp(){
        db = Firestore.firestore()
        storage = Storage.storage()
        currentUser = UserDefaults.standard.currentUser(forKey: "currentUser")
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = "Dashboard"
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    //ACTIONS
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        for iv in deleteImages {
            iv.isHidden = !isEditing
        }
    }
    
    
    // Setting up the tournament alert to activate the tournament.
    func tournamentSelected(index: Int, cell: DashboardCollectionCell) -> UIAlertController {
        let alertController = UIAlertController(title: "Activate", message: "Would you like to activate this tournament?", preferredStyle: .alert)
        
        let activate = UIAlertAction(title: "Activate", style: .default) { (action) in
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(self.tournaments[index].id, forKey: "activeTournament")
                cell.activeLabel.text = "Activated"
                cell.activeView.backgroundColor = UIColor.green
                cell.activeView.layer.cornerRadius = 10
                self.collectionView.reloadData()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(activate)
        alertController.addAction(cancel)
        return alertController
    }
    
    // COLLECTIONVIEW
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tournaments.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DashboardCollectionCell else {return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)}
        
        cell.tag = indexPath.row

        // Configure the cell
        if indexPath.row == tournaments.count {
            cell.tournamentImage.image = UIImage(named: "Plus")
            cell.dateLabel.text = ""
            cell.activeLabel.text = ""
            cell.deleteIV.isHidden = true
            cell.activeView.backgroundColor = UIColor.white
        } else {
            let t = tournaments[indexPath.row]
            let dates = "\(t.startDate!) - \(t.endDate!)"
            // Normal setup
            // Get and set image from storage.
            // Setting up tap Gesture recognizer.
            deleteImages.append(cell.deleteIV)
            cell.deleteIV.isHidden = !isEditing
            
            if let logo = t.logo {
                cell.tournamentImage.image = logo
            } else if let id = t.imageID {
                let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/fish-hook-3ef8d.appspot.com/o/tournament%2F\(id).jpg?alt=media&token=c29ad4be-23a0-4bce-945a-00d1298bf8d8")
                
                URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    if let data = data {
                        let image = UIImage(data: data)
                        self.tournaments[indexPath.row].logo = image

                        DispatchQueue.main.async {
                            if cell.tag == indexPath.row {
                                cell.tournamentImage.image = image
                            }
                        }
                    }
                }.resume()
            } else {
                cell.tournamentImage.image = UIImage(named: "DefaultTournament")
            }
            cell.dateLabel.text = dates
        
            // TODO: Check isActivated porperty instead
            if let code = t.id, let activeCode = UserDefaults.standard.string(forKey: "activeTournament"){
                if code == activeCode {
                    cell.activeLabel.text = "Activated"
                    cell.activeView.backgroundColor = UIColor.green
                    cell.activeView.layer.cornerRadius = 10
                } else {
                    cell.activeLabel.text = ""
                    cell.activeView.backgroundColor = UIColor.white
                    cell.activeView.layer.cornerRadius = 10
                }
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: If add button selected then segue to tournament creation else go to details of tournament.
        guard let user = currentUser, let cell = collectionView.cellForItem(at: indexPath) as? DashboardCollectionCell else {return}
        
        if indexPath.row == tournaments.count || tournaments.count == 0 {
            if user.admin {
                performSegue(withIdentifier: "toTournament", sender: self)
            } else {
                presentAddModal()
            }
        } else {
            if isEditing {
                let active = cell.activeLabel.text == "Activated" ? true:false
                deleteSelected(index: indexPath.row, active: active)
            } else {
                if cell.activeLabel.text != "Activated"{
                    print("Active index \(indexPath.row)")
                    let alert = tournamentSelected(index: indexPath.row, cell: cell)
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Alerting the user
    func deleteSelected(index: Int, active: Bool){
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this tournament?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (error) in
            
            let id = self.tournaments[index].id
            
            if let tID = id {
                self.deleteTournament(id: tID, index: index, active: active)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
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
    
    
    // FIREBASE
    
    // Getting the tournaments by the code entered
    // TODO: Check against registered participants as well.
    func fetchTournamentByCode(code: String){
        db?.collection("tournaments").whereField("code", isEqualTo: code).getDocuments(completion: { (doc, err) in
            // TODO: Retrieve the tournament document.
            
            if let documents = doc?.documents {
                
                for document in documents {
                    let map = document.data()
                    
                    let id = document.documentID
                    let code = map["code"] as! String
                    let name = map["name"] as! String
                    let imageID = map["logo"] as? String
                    let participants = map["participants"] as! [String]
                    let waterType = map["waterType"] as! [String]
                    let metrics = map["metrics"] as! [String]
                    let startDate = map["startDate"] as! String
                    let startTime = map["startTime"] as! String
                    let endDate = map["endDate"] as! String
                    let endTime = map["endTime"] as! String
                    
                    self.tournaments.append(Tournament(_id: id, _name: name, _logo: nil, _created: nil, _divisions: [Division](), _fishSpecies: [Fish](), _participants: participants, _waterType: waterType, _metrics: metrics, _startDate: startDate, _endDate: endDate, _startTime: startTime, _endTime: endTime, _code: code, _isActive: false, _imageID: imageID))
                    
                    self.addTournamentToUser(id: id)
                    UserDefaults.standard.set(id, forKey: "activeTournament")
                    self.collectionView.reloadData()
                    
                    return
                }
            } else if let error = err {
                let alert = Utils.basicAlert(title: "Error", message: error.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    // Adding the tournaments to the user in firestore.
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
                
                if userTournamentIDs.count <= 0 {
                    UserDefaults.standard.set(nil, forKey: "activeTournament")
                } else {
                    self.fetchTournaments(tournamentIDS: userTournamentIDs)
                }
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
                
                let id = doc?.documentID
                if let map = doc?.data() {
                    let code = map["code"] as! String
                    let name = map["name"] as! String
                    let imageID = map["logo"] as? String
                    let participants = map["participants"] as! [String]
                    let waterType = map["waterType"] as! [String]
                    let metrics = map["metrics"] as! [String]
                    let startDate = map["startDate"] as! String
                    let startTime = map["startTime"] as! String
                    let endDate = map["endDate"] as! String
                    let endTime = map["endTime"] as! String
                    
                    let newTournament = Tournament(_id: id, _name: name, _logo: nil, _created: nil, _divisions: [Division](), _fishSpecies: [Fish](), _participants: participants, _waterType: waterType, _metrics: metrics, _startDate: startDate, _endDate: endDate, _startTime: startTime, _endTime: endTime, _code: code, _isActive: false, _imageID: imageID)
                    
                    self.tournaments.append(newTournament)
                    self.collectionView.reloadData()
                } else if let error = err {
                    let alert = Utils.basicAlert(title: "Error", message: error.localizedDescription, Button: "OK")
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    // Function to delete cell
    func deleteTournament(id: String, index: Int, active: Bool) {
        
        db?.collection("tournaments").document(id).delete(completion: { (error) in

            if let err = error {
                let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
            } else {
                if active {
                    UserDefaults.standard.set(nil, forKey: "activeTournament")
                }
                self.deleteImages.removeAll()
                self.tournaments.remove(at: index)
                self.collectionView.reloadData()
            }
        })
    }
    
    // NAVIGATION
    
    // Hopefully setting the active tournament to the newly created tournament.
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) {
        
        // TODO: Pass created tournament back and add it to the tournaments array
        
        guard let sVC = segue.source as? SummaryVC else {return}
        
        if let t = sVC.newTournament {
            tournaments.append(t)
            self.collectionView.reloadData()
        }
    }
}
