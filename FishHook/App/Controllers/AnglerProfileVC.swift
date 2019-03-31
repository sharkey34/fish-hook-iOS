//
//  AnglerProfileVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/26/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AnglerProfileVC: UIViewController {
    
    @IBOutlet weak var anglerProfileIV: UIImageView!
    @IBOutlet weak var captainIconIV: UIImageView!
    @IBOutlet weak var boatIconIV: UIImageView!
    @IBOutlet weak var captainNameLabel: UILabel!
    @IBOutlet weak var boatNameLabel: UILabel!
    @IBOutlet weak var anglerNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var trophyBtn: UIView!
    @IBOutlet weak var trophyLabel: UILabel!
    @IBOutlet weak var trophyHighlight: UIView!
    
    @IBOutlet weak var officialBtn: UIView!
    @IBOutlet weak var officialLabel: UILabel!
    @IBOutlet weak var officialHighlight: UIView!
    
    var db: Firestore!
    var storage: Storage!
    
    var officialSelected = false
    var trophySelected = false
    var currentUser: User!
    var officialCatches = [Catch]()
    var trophyCatches = [Catch]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // Initial Setup
    func setUp(){
        db = Firestore.firestore()
        storage = Storage.storage()
        tableView.dataSource = self
        tableView.delegate = self
        trophySelected = true
        
        fetchCatches(isTrophy: true)
        
        let trophyTap = UITapGestureRecognizer(target: self, action: #selector(trophyTapped(sender:)))
        trophyBtn.addGestureRecognizer(trophyTap)
        
        let officialTap = UITapGestureRecognizer(target: self, action: #selector(officialTapped(sender:)))
        officialBtn.addGestureRecognizer(officialTap)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped(sender:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        anglerNameLabel.text = currentUser.userName
        
        if let captain = currentUser.captain {
            captainNameLabel.text = captain
            captainIconIV.image = UIImage(named: "CaptainIcon")
        } else {
            captainNameLabel.text = ""
            captainIconIV.image = nil
        }
        
        if let boat = currentUser.boat {
            boatNameLabel.text = boat
            boatIconIV.image = UIImage(named: "BoatIcon")
        } else {
            boatNameLabel.text = ""
            boatIconIV.image = nil
        }

        if let image = currentUser.profileImage {
            anglerProfileIV.image = image
        } else if let imageID = currentUser.imageID {
            downlodImage(imageID: imageID)
        } else {
            anglerProfileIV.image = UIImage(named: "ProfilePlaceholder")
        }
    }
    
    // Downloading Image
    func downlodImage(imageID: String){
        if let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/fish-hook-3ef8d.appspot.com/o/profile%2F\(imageID).jpg?alt=media&token=c29ad4be-23a0-4bce-945a-00d1298bf8d8") {
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    let image = UIImage(data: data)
                    
                    // Setting profile image
                    DispatchQueue.main.async {
                        self.anglerProfileIV.image = image
                        self.currentUser.profileImage = image
                    }
                }
            }.resume()
        }
    }
    
    @objc
    func editTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toAnglerEdit", sender: self)
    }
    
    // Changing attributes and fetching catches
    @objc
    func officialTapped(sender: UITapGestureRecognizer) {
        if !officialSelected {
            trophySelected = false
            officialSelected = true

            // Getting Official Catches
            if officialCatches.count <= 0 {
                tableView.reloadData()
                fetchCatches(isTrophy: false)
            } else {
                print("reload")
                tableView.reloadData()
            }
            
            // Setting Trophy
            trophyHighlight.backgroundColor = UIColor.clear
            trophyLabel.text = "Trophy Catches"
            
            // Setting Official
            officialHighlight.backgroundColor = UIColor(displayP3Red: 237/255, green: 255/255, blue: 0/255, alpha: 1)
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 25)!]
            let bold = NSAttributedString(string: "Official Catches", attributes: attributes)
            officialLabel.text = bold.string
        }
    }
    
    // Changing attributes and fetching catches
    @objc
    func trophyTapped(sender: UITapGestureRecognizer) {
        if !trophySelected {
            trophySelected = true
            officialSelected = false

            // Getting Trophy Catches
            if trophyCatches.count <= 0 {
                tableView.reloadData()
                fetchCatches(isTrophy: true)
            } else {
                print("reload")
                tableView.reloadData()
            }
            
            
            // Set Official
            officialHighlight.backgroundColor = UIColor.clear
            officialLabel.text = "Official Catches"
            
            // Setting tophy values
            trophyHighlight.backgroundColor = UIColor(displayP3Red: 237/255, green: 255/255, blue: 0/255, alpha: 1)
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 25)!]
            let bold = NSAttributedString(string: "Trophy Catches", attributes: attributes)
            trophyLabel.text = bold.string
        }
    }
    
    func fetchCatches(isTrophy: Bool) {
        
        var type: String!
        var catches: [Catch]!
        
        if isTrophy {
            type = "trophy"
            catches = trophyCatches
        } else {
            type = "official"
            catches = officialCatches
        }
        
        db.collection(type).whereField("userID", isEqualTo: currentUser.uid).getDocuments(source: .default) { (documents, error) in
            
            if let err = error {
                let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
                print(err.localizedDescription)
                return
            }
            
            if let docs = documents?.documents {
                for doc in docs {
                    let map = doc.data()
                    let id = doc.documentID
                    let tID = map["tID"] as! String
                    let userName = map["userName"] as! String
                    let lat = map["lat"] as? Double
                    let long = map["long"] as? Double
                    let userID = map["userID"] as! String
                    let imageID = map["image"] as! String
                    let fish = map["fish"] as! String
                    let metric = map["metric"] as! String
                    
                    catches.append(Catch(_id: id, _aID: nil, _userName: userName, _place: nil, _userID: userID, _metric: metric, _fish: fish, _image: nil, _imageID: imageID, _tID: tID, _lat: lat, _long: long))
                }
                
                DispatchQueue.main.async {
                    if catches.count <= 0 {
                        let alert = Utils.basicAlert(title: "No Catches", message: "There are no catches to display", Button: "OK")
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        
                        if isTrophy {
                            self.trophyCatches = catches
                        } else {
                            self.officialCatches = catches
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // Sending currentUser to edit Vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnglerEdit" {
            if let editVC = segue.destination as? EditProfileVC {
                editVC.currentUser = currentUser
            }
        }
    }
}


// Tableview extensions
extension AnglerProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.rowHeight = view.frame.height / 2
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if trophySelected {
            return trophyCatches.count
        } else {
            return officialCatches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AnglerProfileCell else {return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)}
        
        cell.tag = indexPath.row
        var cellCatch: Catch!
        var type: String?
        
        if trophySelected {
            cellCatch = trophyCatches[indexPath.row]
            type = "trophy"
        } else if officialSelected {
            cellCatch = officialCatches[indexPath.row]
            type = "official"
        }
        
        if let image = cellCatch.image {
            cell.catchIV.image = image
        } else {
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/fish-hook-3ef8d.appspot.com/o/\(type!)%2F\(cellCatch.imageID!).jpg?alt=media&token=c29ad4be-23a0-4bce-945a-00d1298bf8d8")
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    cellCatch.image = image
                    
                    DispatchQueue.main.async {
                        if cell.tag == indexPath.row {
                            cell.catchIV.image = image
                        }
                    }
                }
            }.resume()
        }
        cell.fishLabel.text = cellCatch.fish
        cell.metricLabel.text = cellCatch.metric
        cell.userNameLabel.text = cellCatch.userName
        
        return cell
    }
}
