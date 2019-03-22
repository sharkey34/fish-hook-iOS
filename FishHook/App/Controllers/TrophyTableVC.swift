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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        db = Firestore.firestore()
        storage = Storage.storage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSelected(sender:)))
        
        if let tabVC = tabBarController as? TabVC {
            currentUser = tabVC.currentUser
        }
    }
    
    @objc
    func addSelected(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toAddTrophy", sender: self)
    }
  
    
    // TABLE VIEW
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catches.count
    }
    
    
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
