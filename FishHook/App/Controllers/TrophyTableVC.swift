//
//  TrophyTableVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/21/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class TrophyTableVC: UITableViewController {
    
    var aID: String?
    var catches = [Catch]()
    var currentUser: User?
    var db: Firestore!
    var storage: Storage!
    var tID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchTrophies()
        navigationItem.title = "Trophy Wall"
    }
    
    func setUp(){
        tID = UserDefaults.standard.string(forKey: "activeTournament")
        db = Firestore.firestore()
        storage = Storage.storage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSelected(sender:)))
        
        if let tabVC = tabBarController as? TabVC {
            currentUser = tabVC.currentUser
        }
    }
    
    // Fetching trophies from firestore
    func fetchTrophies(){
        guard let id = tID else {return}
        
        db.collection("trophy").whereField("tID", isEqualTo: id).getDocuments(source: .default) { (documents, error) in
        
            if let err = error {
                let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let docs = documents?.documents {
                for doc in docs {
                    let map = doc.data()
                    let id = doc.documentID
                    let tID = map["tID"] as! String
                    let userName = map["name"] as! String
                    let lat = map["lat"] as! String
                    let long = map["long"] as! String
                    let userID = map["userID"] as! String
                    let imageID = map["image"] as! String
                    let fish = map["fish"] as! String
                    let metric = map["metric"] as! String
                    
                    self.catches.append(Catch(_id: id, _aID: nil, _userName: userName, _place: nil, _userID: userID, _metric: metric, _fish: fish, _image: nil, _imageID: imageID, _tID: tID, _lat: lat, _long: long))
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
    
    @objc
    func addSelected(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toAddTrophy", sender: self)
    }
  
    
    // TABLE VIEW
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.rowHeight = view.frame.height / 2
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catches.count
    }
    
    
    
    // Setting the cells values
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TrophyCell else {
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)}
        
        cell.tag = indexPath.row
        let c = catches[indexPath.row]
        
        if let image = c.image {
            cell.trophyIV.image = image
        } else if let id = c.imageID {
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/fish-hook-3ef8d.appspot.com/o/trophy%2F\(id).jpg?alt=media&token=c29ad4be-23a0-4bce-945a-00d1298bf8d8")
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    let image = UIImage(data: data)
                    c.image = image
                    
                    DispatchQueue.main.async {
                        if cell.tag == indexPath.row {
                            cell.trophyIV.image = image
                        }
                    }
                }
            }.resume()
        } else {
            cell.trophyIV.image  = UIImage(named: "OfficialCatch")
        }
        cell.fishLabel.text = c.fish
        cell.nameLabel.text = c.userName
        cell.metricLabel.text = c.metric
        
        return cell
    }
    
    // SEUGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let trophyVC = segue.destination as? AddTrophyCatchVC else {return}
        trophyVC.currentUser = currentUser
    }
    
    @IBAction func unwindToTrophyTable(segue: UIStoryboardSegue) {
        
        guard let addVC = segue.source as? AddTrophyCatchVC else {return}
        
        if let newCatch = addVC.newCatch {
            catches.append(newCatch)
            tableView.reloadData()
        }
    }
}
