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
    
    @objc func submitSelected(sender: UIBarButtonItem) {
        // TODO: Get all the information from the local database.
        // TODO: Push all data to Firestore and create the tournament.
        if isValidTournament() {
            guard let tUID = tournamentUID, let tCode = tournamentCode else {return}
            
            // TODO: Add image to storage
            db?.collection("tournaments").document(tUID).setData(
                [
                    "code": tCode,
                    "name":Global.tournament.name!,
                    "participants":Global.tournament.participants!,
                    "waterType": Global.tournament.waterType,
                    "metrics":Global.tournament.metrics,
                    "startDate": Global.tournament.startDate!,
                    "startTime": Global.tournament.startTime!,
                    "endDate": Global.tournament.endDate!,
                    "endTime" : Global.tournament.endTime!
                ]
                , completion: { (err) in
                    if let error = err {
                        let alert = Utils.basicAlert(title: "Error", message: error.localizedDescription, Button: "OK")
                        self.present(alert, animated: true, completion: nil)
                    }
            })
            
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
            // Going back to the Dashboard
            dismiss(animated: true, completion: nil)
        }
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
    
    
//    // Loading data from CoreData
//    func loadAndTest(){
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TournamentData")
//        do{
//            let data: [NSManagedObject] = try managedContext.fetch(fetchRequest)
//
//            for obj in data {
//
//
//                print(obj.value(forKey: "tName") as? String)
//
//                var participants = obj.value(forKey: "participants") as? [String]
//
//                print(participants)
//
//
//            }
//        } catch {
//            assertionFailure()
//        }
//    }
}
