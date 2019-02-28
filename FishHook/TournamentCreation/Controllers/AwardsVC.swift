//
//  AwardsVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/27/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class AwardsVC: UIViewController {
    @IBOutlet weak var awardName: UITextField!
    @IBOutlet weak var sponsorName: UITextField!
    @IBOutlet weak var fishSpecies: UITextField!
    @IBOutlet weak var prizeCount: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var prizes = [String]()
    var itemCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Awards.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSelected(sender:)))

    }
    
    @objc func doneSelected(sender: UIBarButtonItem) {
        // TODO: verify inputs.
        // TODO: Save to Realm and dismiss controller
    }
    
    @IBAction func StepperChange(_ sender: UIStepper) {
        
        // TODO: Check and remove item from array when cell deleted.
        let count = Int(sender.value)

        if itemCount > count  && prizes.count == count && count > 0{
            prizes.remove(at: count - 1)
            print(prizes)
        }
        
        itemCount = count
        prizeCount.text = itemCount.description
        tableView.reloadData()
    }
}

// Tableview callbacks
extension AwardsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PrizesTableViewCell else {return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)}
        
        let num = indexPath.row + 1
        
        cell.prizeNum.text = num.description
        cell.prizeName.delegate = self
        
        return cell
    }
}

extension AwardsVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Add an edit button or some way to allow the user to edit the textfields
        if let text = textField.text {
            
            prizes.append(text)
            textField.isEnabled = false
        }
    }
}
