//
//  BasicDetailsVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/24/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class BasicDetailsVC: UIViewController {
    @IBOutlet weak var tournamentName: UITextField!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var fresh: UISwitch!
    @IBOutlet weak var salt: UISwitch!
    @IBOutlet weak var weight: UISwitch!
    @IBOutlet weak var length: UISwitch!
    @IBOutlet weak var tableview: UITableView!
    
    var participants = [(Participants.Angler, false), (Participants.Captain, false), (Participants.Boat, false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        tableview.delegate = self
        tableview.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSelected(sender:)))
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Basic.rawValue
    }
    
    
    @IBAction func addLogoTapped(_ sender: UIButton) {
        // TODO: Allow the user to upload a photo from the gallary.
    }
    
    @objc func doneSelected(sender: UIBarButtonItem){
        // TODO: Validate entries
        // TODO: Save data to realm Database
        
    }
}

// UITableView Callbacks
extension BasicDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Participants.Participants.rawValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = participants[indexPath.row].0.rawValue
        cell.accessoryType = participants[indexPath.row].1 ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Check the selected tableView item
    
        let checked = !(participants[indexPath.row].1)
        
        participants[indexPath.row].1 = checked
        tableView.cellForRow(at: indexPath)?.accessoryType = checked ? .checkmark : .none
    }
}
