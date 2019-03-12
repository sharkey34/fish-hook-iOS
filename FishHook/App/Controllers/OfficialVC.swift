//
//  OfficialVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/11/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore

class OfficialVC: UITableViewController {
    
    var aID: String?
    var currentUser: User!
    var db: Firestore!
    var catches = [Catch]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()

        currentUser = UserDefaults.standard.currentUser(forKey: "currentUser")
        
        if currentUser.admin {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSelected(sender:)))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch Catches
        catches.removeAll()
        fetchOfficialCatches()
    }
    
    // Fetch Catches from database
    func fetchOfficialCatches(){
        guard let id = aID else {return}
        
        db.collection("official").whereField("aID", isEqualTo: id).getDocuments(source: .default) { (documents, error) in
            
            if let err = error {
                let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                if let docs = documents?.documents {
                    
                    for doc in docs {
                        let map = doc.data()
                        let docID = doc.documentID
                        let userID = map["userID"] as! String
                        let userName = map["userName"] as! String
                        let fish = map["fish"] as! String
                        let metric = map["metric"] as! String
                        
                        self.catches.append(Catch(_id: docID, _aID: self.aID!, _userName: userName, _place: nil, _userID: userID, _metric: metric, _fish: fish, _image: nil))
                    }
                    if self.catches.count <= 0 {
                        let alert = Utils.basicAlert(title: "No Catches", message: "There have been no catches added. Please select the add button and add a catch.", Button: "OK")
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // Sending the Award ID to the add catch Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddCatch" {
            guard let acVC = segue.destination as? AddOfficialCatchVC else {return}
            acVC.aID = aID
        }
    }
    
    // Performing the Segue to the Catch Controller.
    @objc func addSelected(sender: UIBarButtonItem){
        performSegue(withIdentifier: "toAddCatch", sender: self)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.rowHeight = view.frame.height / 2
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OfficialTableViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        
        // Configure the cell...
        cell.catchIV.image  = UIImage(named: "OfficialCatch")
        cell.fishLabel.text = catches[indexPath.row].fish
        cell.userNameLabel.text = catches[indexPath.row].userName
        cell.metricLabel.text = catches[indexPath.row].metric

        return cell
    }
}
