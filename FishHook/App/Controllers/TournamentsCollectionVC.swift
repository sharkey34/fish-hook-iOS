//
//  AdminTournamentsCollectionViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class TournamentsCollectionVC: UICollectionViewController {
    
    var db: Firestore!
    var currentUser: User?
    var tournaments = [Tournament]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        fetchTournamentIDS()
    }
    
    // initial setup.
    func setUp(){
        db = Firestore.firestore()
        
        if let tabVC = tabBarController as? TabVC {
            currentUser = tabVC.currentUser
        }
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Tournament Dashboard"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ProfileIcon"), style: .plain, target: self, action: #selector(profileSelected(sender:)))
    }
    
    
    //ACTIONS
    
    @objc
    func profileSelected(sender: UIBarButtonItem){
        
        if currentUser!.admin {
            performSegue(withIdentifier: Segues.OrganizerProfile.rawValue, sender: self)
        } else {
            performSegue(withIdentifier: Segues.AnglerProfile.rawValue, sender: self)
        }
    }
    
    // Creating and presenting the actionSheet
    func presentActionSheet(indexPath: IndexPath,  cell: DashboardCollectionCell){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        guard let user = currentUser else {return}
        
        // Activating new tournament
        if cell.activeLabel.text != "Activated"{
            let activate = UIAlertAction(title: "Activate", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                DispatchQueue.main.async {
                    UserDefaults.standard.set(self.tournaments[indexPath.row].id, forKey: "activeTournament")
                    cell.activeLabel.text = "Activated"
                    cell.activeView.backgroundColor = UIColor.green
                    cell.activeView.layer.cornerRadius = 10
                    self.collectionView.reloadData()
                }
            })
            alertController.addAction(activate)
        }
        
        if user.admin {
            // Setting the editingDivision value and performing segue
            let edit = UIAlertAction(title: "Edit", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                //  Do some action here.
                DispatchQueue.main.async {
                    let tournament = self.tournaments[indexPath.row]
                    Global.tournament = tournament
                    Global.divisions = tournament.divisions
                    Global.edit = true
                    self.performSegue(withIdentifier: "toTournament", sender: self)
                }
            })
            alertController.addAction(edit)
        }
        
        // Deleting the item and reloading the collectionView
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            DispatchQueue.main.async {
                let active = cell.activeLabel.text == "Activated" ? true:false
                self.deleteSelected(index: indexPath.row, active: active)
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(delete)
        alertController.addAction(cancel)
        
        // Checking the current device.
        let device = UIDevice.current
        
        if device.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if let controller = alertController.popoverPresentationController {
                controller.sourceView = cell.contentView
                controller.sourceRect = CGRect(x: cell.contentView.bounds.midX, y: cell.contentView.bounds.maxY, width: 0, height: 0)
                controller.permittedArrowDirections = [.up]
            }
        }
        present(alertController, animated: true, completion: nil)
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
                self.tournaments.remove(at: index)
                self.collectionView.reloadData()
            }
        })
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
//            cell.deleteIV.isHidden = true
            cell.activeView.backgroundColor = UIColor.white
        } else {
            let t = tournaments[indexPath.row]
            let dates = "\(t.startDate!) - \(t.endDate!)"
            // Normal setup
            // Get and set image from storage.
            // Setting up tap Gesture recognizer.
            if let logo = t.logo {
                cell.tournamentImage.image = logo
            } else if let id = t.imageID {
                if let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/fish-hook-3ef8d.appspot.com/o/tournament%2F\(id).jpg?alt=media&token=c29ad4be-23a0-4bce-945a-00d1298bf8d8") {
                    
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
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
                }
            } else {
                cell.tournamentImage.image = UIImage(named: "DefaultTournament")
                cell.deleteIV.image = UIImage(named: "Delete")
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
            presentActionSheet(indexPath: indexPath, cell: cell)
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
                    let dates = map["dates"] as! [Timestamp]
                    
                    var convertedDates = [Date]()
                    for date in dates {
                        convertedDates.append(date.dateValue())
                    }
                    self.tournaments.append(Tournament(_id: id, _name: name, _logo: nil, _created: nil, _divisions: [Division](), _fishSpecies: [Fish](), _participants: participants, _waterType: waterType, _metrics: metrics, _startDate: startDate, _endDate: endDate, _startTime: startTime, _endTime: endTime, _code: code, _isActive: false, _imageID: imageID, _dates: convertedDates))
                    
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
        
        db.collection("users").document(userID).getDocument(completion: { (doc, err) in
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
            db.collection("tournaments").document(tournament).getDocument(completion: { (doc, err) in
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
                    let fishIDs = map["fish"] as! [String]
                    let dates = map["dates"] as! [Timestamp]
                    
                    var convertedDates = [Date]()
                    for date in dates {
                        convertedDates.append(date.dateValue())
                    }
                                        
                    let newTournament = Tournament(_id: id, _name: name, _logo: nil, _created: nil, _divisions: [Division](), _fishSpecies: [Fish](), _participants: participants, _waterType: waterType, _metrics: metrics, _startDate: startDate, _endDate: endDate, _startTime: startTime, _endTime: endTime, _code: code, _isActive: false, _imageID: imageID, _dates:convertedDates)
                    
                    self.tournaments.append(newTournament)
                    self.fetchDivisions(tournament: newTournament)
                    self.fetchFish(fishIDs: fishIDs, tournament: newTournament)
                } else if let error = err {
                    let alert = Utils.basicAlert(title: "Error", message: error.localizedDescription, Button: "OK")
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    // fetching the fish for each tournament
    func fetchFish(fishIDs: [String], tournament: Tournament) {
        
        for id in fishIDs {
            db.collection("fish").document(id).getDocument(source: .default) { (document, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let doc = document {
                    if let map = doc.data(){
                        let id = doc.documentID
                        let name = map["name"] as! String
                        let type = map["type"] as! Int
                        
                        
                        tournament.fishSpecies.append(Fish(_id: id, _name: name, _type: type, _checked: true, _weight: nil, _length: nil))
                    }
                }
            }
        }
    }
    
    // Fetching divisions for each Tournament
    func fetchDivisions(tournament: Tournament){
        guard let tID = tournament.id else {return}
        
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
                    
                    let newDivision = Division(_id: dID, _tID: tID, _name: name, _sponsor: sponsor, _awards: [Award]())
                    tournament.divisions.append(newDivision)
                    self.fetchAwards(division: newDivision)
                }
            }
        }
    }
    
    // Fetching Awards for each Division
    func fetchAwards(division: Division) {
        
        guard let id = division.id else {return}
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
                
                let newAward = Award(_id: id, _name: name, _sponsor: sponsor, _prizes: prizes, _fishSpecies: fish)
                division.awards?.append(newAward)
            }
            self.collectionView.reloadData()
        }
    }
    
    
    // Passing the currentUser to the Profiles
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let user = currentUser else {return}
        
        if segue.identifier == Segues.AnglerProfile.rawValue {
            if let anglerVC = segue.destination as? AnglerProfileVC {
                anglerVC.currentUser = user
            }
        } else if segue.identifier == Segues.OrganizerProfile.rawValue {
            if let organizerVC = segue.destination as? OrganizerProfileVC {
                organizerVC.currentUser = user
            }
        }
    }
    
    // NAVIGATION
    
    // Hopefully setting the active tournament to the newly created tournament.
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) {
        
        // TODO: Pass created tournament back and add it to the tournaments array
        
        guard let sVC = segue.source as? SummaryVC else {return}
        
        if let t = sVC.newTournament {
            if Global.edit {
                tournaments.removeAll()
                fetchTournamentIDS()
            } else {
                tournaments.append(t)
            }
            self.collectionView.reloadData()
        }
        Utils.resetGlobal()
    }
}
