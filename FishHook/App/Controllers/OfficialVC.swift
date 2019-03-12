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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()

        currentUser = UserDefaults.standard.currentUser(forKey: "currentUser")
        
        if currentUser.admin {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSelected(sender:)))
        }
    }
    
    // Fetch Catches from database
    func fetchOfficialCatches(){
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
        tableView.rowHeight = view.frame.height / 2.5
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
 

}
