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
        
        
        return cell
    }
    
    // SEUGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let trophyVC = segue.destination as? AddTrophyCatchVC else {return}
        trophyVC.currentUser = currentUser
    }
}
