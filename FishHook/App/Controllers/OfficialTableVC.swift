//
//  OfficialVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/11/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class OfficialTableVC: UITableViewController {
    
    var aID: String?
    var catches = [Catch]()
    var currentUser: User?
    var db: Firestore!
    var storage: Storage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // Function for intial setup
    func setUp(){
        db = Firestore.firestore()
        storage = Storage.storage()
        currentUser = UserDefaults.standard.currentUser(forKey: "currentUser")
        
        if let user = currentUser {
            if user.admin {
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSelected(sender:)))
            }
        }
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
                        let imageID = map["imageID"] as? String
                        let userID = map["userID"] as! String
                        let userName = map["userName"] as! String
                        let fish = map["fish"] as! String
                        let metric = map["metric"] as! String
                        
                        self.catches.append(Catch(_id: docID, _aID: self.aID!, _userName: userName, _place: nil, _userID: userID, _metric: metric, _fish: fish, _image: nil, _imageID: imageID))
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
        cell.tag = indexPath.row
        
        let c = catches[indexPath.row]
        
        if let image = c.image {
            cell.catchIV.image = image
        } else if let id = c.imageID {
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/fish-hook-3ef8d.appspot.com/o/official%2F\(id).jpg?alt=media&token=c29ad4be-23a0-4bce-945a-00d1298bf8d8")
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    let image = UIImage(data: data)
                    c.image = image
                    
                    DispatchQueue.main.async {
                        if cell.tag == indexPath.row {
                            cell.catchIV.image = image
                        }
                    }
                }
            }.resume()
        } else {
            cell.catchIV.image  = UIImage(named: "OfficialCatch")
        }
        
        cell.fishLabel.text = c.fish
        cell.userNameLabel.text = c.userName
        cell.metricLabel.text = c.metric

        return cell
    }
    
    @IBAction func unwindFromAddCatch(segue: UIStoryboardSegue) {
        guard let aVC = segue.source as? AddOfficialCatchVC else {return}
        
        if let c = aVC.newCatch {
            catches.append(c)
            tableView.reloadData()
        }
    }
}
