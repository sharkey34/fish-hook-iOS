//
//  SummaryVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/25/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class SummaryVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var codeLabel: UILabel!
    
    var db: Firestore?
    var storage: Storage?
    var tournamentUID: String?
    var tournamentCode: String?
    var divisionID: String?
    var newTournament: Tournament?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        storage = Storage.storage()
        
        let docID = db?.collection("tournaments").document()
        tournamentUID = String(docID!.documentID)
        
        // Cast as String
        tournamentCode = tournamentUID?.prefix(6).lowercased()
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Summary.rawValue
        
        let button = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitSelected(sender:)))
        navigationItem.rightBarButtonItem = button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelected(sender:)))
        
        setLabelValues()
    }
    
    // Setting label values
    func setLabelValues() {
        // TODO: Check that needed things are filled out
        
        if isValidTournament() {
            guard let tCode = tournamentCode else {return}
            
            codeLabel.text = tCode
            image.image = Global.tournament.logo
            labels[0].text = Global.tournament.name
            
            // Setting waterType label.
            if Global.tournament.waterType.count > 1 {
                labels[1].text = "\(Global.tournament.waterType[0]), \(Global.tournament.waterType[1])"
            } else if Global.tournament.waterType.count == 1 {
                labels[1].text = "\(Global.tournament.waterType[0])"
            }
            
            var p:String
            switch Global.tournament.participants!.count {
            case 1:
                p = "\(Global.tournament.participants![0])"
            case 2:
                p = "\(Global.tournament.participants![0]), \(Global.tournament.participants![1])"
            default:
                p = "\(Global.tournament.participants![0]), \(Global.tournament.participants![1]), \(Global.tournament.participants![2])"
            }
            labels[2].text = p
            
            if Global.tournament.metrics.count == 1 {
                labels[3].text = "\(Global.tournament.metrics[0])"
            } else if Global.tournament.metrics.count == 2 {
                labels[3].text = "\(Global.tournament.metrics[0]), \(Global.tournament.metrics[1])"
            }
            labels[4].text = "\(Global.tournament.startDate!) at \(Global.tournament.startTime!)"
            labels[5].text = "\(Global.tournament.endDate!) at \(Global.tournament.endTime!)"
            labels[6].text = Global.tournament.fishSpecies.count.description
        }
    }
    
    @objc func submitSelected(sender: UIBarButtonItem) {
        // TODO: Get all the information from the local database.
        // TODO: Push all data to Firestore and create the tournament.
        if isValidTournament() {
            guard let tUID = tournamentUID, let tCode = tournamentCode else {return}
            
            let imageID = NSUUID().uuidString
            guard let storageRef = storage?.reference().child("tournament/\(imageID).jpg") else {return}
            
            // Local file you want to upload
            guard let imageData = Global.tournament.logo?.jpegData(compressionQuality: 0.1) else {return}
            
            // Create the file metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // Upload file and metadata to the object 'images/mountains.jpg'
            let uploadTask = storageRef.putData(imageData, metadata: metadata)
            
            uploadTask.observe(.progress) { snapshot in
                // Upload reported progress
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
                
                print(percentComplete.description)
            }
            saveTournament(uid: tUID, tCode: tCode, imageID: imageID)
        }
    }
    
    func saveTournament(uid: String, tCode: String, imageID: String){

        var fishID = [String]()
        for id in Global.tournament.fishSpecies{
            fishID.append(id.id)
        }
        
        db?.collection("tournaments").document(uid).setData(
            [
                "code": tCode,
                "logo": imageID,
                "name":Global.tournament.name!,
                "participants":Global.tournament.participants!,
                "fish": fishID,
                "waterType": Global.tournament.waterType,
                "metrics":Global.tournament.metrics,
                "startDate": Global.tournament.startDate!,
                "startTime": Global.tournament.startTime!,
                "endDate": Global.tournament.endDate!,
                "endTime" : Global.tournament.endTime!
            ]
            , completion: { (err) in
                
                self.addToUser(tUID: uid)
                // TODO: Save division
                self.saveDivisions(tUID: uid)
                
                if let error = err {
                    let alert = Utils.basicAlert(title: "Error", message: error.localizedDescription, Button: "OK")
                    self.present(alert, animated: true, completion: nil)
                }
        })
    }
    
    // Function to Save Divisions
    func saveDivisions(tUID: String){
        
        for division in Global.divisions {
            guard let divID = db?.collection("divisions").document().documentID else {return}
            
//            db?.collection("tournaments").document("CreatedTournamentID").collection("divisions")
            
            db?.collection("divisions").document(divID).setData(
                [
                    "tID": tUID,
                    "name": division.name!,
                    "sponsor": division.sponsor ?? ""
                ], completion: { (error) in
                    // Save Awards
                    self.saveAwards(division: division, divID: divID)
                    
                    if let err = error {
                        let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                        self.present(alert, animated: true, completion: nil)
                    }
            })
        }
        
        newTournament = Global.tournament
        // Going back to the Dashboard
        resetGlobal()
        performSegue(withIdentifier: "toDashboard", sender: self)
    }
    
    // Saving the awards for each division.
    func saveAwards(division: Division, divID: String){
        guard let divAwards = division.awards else {return}
        
        for award in divAwards{
            db?.collection("awards").addDocument(data:
                [
                    "dID": divID,
                    "name": award.name!,
                    "sponsor": award.sponsor ?? "",
                    "fish": award.fishSpecies!,
                    "prizes": award.prizes!
                ]
                , completion: { (error) in
                    if let err = error {
                        let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                        self.present(alert, animated: true, completion: nil)
                    }
            })
        }
    }
    
    func addToUser(tUID: String){
        // Getting the userID from Firebase
        guard let userID = Auth.auth().currentUser?.uid else {
            let alert = Utils.basicAlert(title: "Error", message: "Error saving the tournament", Button: "OK")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        // Adding tournament to user
        db?.collection("users").document(userID).updateData(
            [
                "tournaments": FieldValue.arrayUnion([tUID])
            ]
            , completion: { (err) in
                if let error = err {
                    let alert = Utils.basicAlert(title: "Error", message: error.localizedDescription, Button: "OK")
                    self.present(alert, animated: true, completion: nil)
                }
        })
    }
    
    // Resetting values
    func resetGlobal(){
        Global.tournament = Tournament(_id: nil, _name: nil, _logo: nil, _created: nil, _divisions: [Division](), _fishSpecies: [Fish](), _participants: [String](), _waterType: [String](), _metrics: [String](), _startDate: nil, _endDate: nil, _startTime: nil, _endTime: nil, _code: nil, _isActive: false, _imageID: nil)
        
        Global.divisions = [Division]()
        Global.awards = [Award]()
    }
    
    @objc func cancelSelected(sender: UIBarButtonItem) {
        // TODO: Dismissing the controller may be all that is needed
        dismiss(animated: true, completion: nil)
    }
    
    func isValidTournament() -> Bool {
        guard let _ = Global.tournament.name, let _ = Global.tournament.logo, let _ = Global.tournament.startDate, let _ = Global.tournament.endDate, let _ = Global.tournament.startTime, let _ = Global.tournament.endTime, let _ = Global.tournament.participants else {
            
            let alert = Utils.basicAlert(title: "Error", message: "One or more tournament items were improperly filled out.", Button: "OK")
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }
}
