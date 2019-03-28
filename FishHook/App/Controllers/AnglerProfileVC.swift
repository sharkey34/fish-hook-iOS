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
    
    var db: Firestore?
    var storage: Storage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()

    }
    
    func setUp(){
        db = Firestore.firestore()
        storage = Storage.storage()
        tableView.dataSource = self
        tableView.delegate = self
        
        let trophyTap = UITapGestureRecognizer(target: self, action: #selector(trophyTapped(sender:)))
        trophyBtn.addGestureRecognizer(trophyTap)
        
        let officialTap = UITapGestureRecognizer(target: self, action: #selector(officialTapped(sender:)))
        officialBtn.addGestureRecognizer(officialTap)
        
        
        
    }
    
    @objc
    func officialTapped(sender: UITapGestureRecognizer) {
        // TODO: Change query and appearance of button
    }
    
    @objc
    func trophyTapped(sender: UITapGestureRecognizer) {
        // TODO: Change query and appearance of button
    }
}


// Tableview extensions
extension AnglerProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AnglerProfileCell else {return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)}
        
        return cell
    }
}
