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
    
    var itemCount: Int = 0
    var prizes = [String]()
    var newAward: Award?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Awards.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelected(sender:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelected(sender:)))
    }
    
    @objc func saveSelected(sender: UIBarButtonItem) {
        
        // TODO: Add check for prize.count eqaul to number of cells that way we can alert the user if a prize cell is left empty.
        
        // Getting all the final values entered in the prize cells
        guard let cells = tableView.visibleCells as? [PrizesTableViewCell] else {return}
        
        for cell in cells {
            if !cell.prizeName.isNullOrWhitespace() {
                prizes.append(cell.prizeName.text!)
            }
        }
        
        // TODO: verify inputs.
        guard !awardName.isNullOrWhitespace(), !fishSpecies.isNullOrWhitespace(), prizes.count > 0 else {
            let alert = Utils.basicAlert(title: "Invalid Award Entries", message: "Please make sure to fill out all fields correctly. You must also have added at least one prize.", Button: "OK")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        // Save to Realm and dismiss controller
        
        newAward = Award(_name: awardName.text!, _sponsor: sponsorName.text, _prizes: prizes, _fishSpecies: fishSpecies.text!)
        
        performSegue(withIdentifier: "unwindToDetails", sender: self)
    }
    
    
    @objc func cancelSelected(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToDetails", sender: self)
    }
    
    // Incrementing count and reloading tableview
    @IBAction func StepperChange(_ sender: UIStepper) {
        itemCount = Int(sender.value)
        prizeCount.text = itemCount.description
        tableView.reloadData()
    }
    
//    // Passing Data
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("willShow DivisionDetails")
//        guard let dVC = segue.destination as? DivisionDetailsVC else {return}
//
//        if let award = newAward {
//            dVC.awards.append(award)
//        }
//    }
}

// Tableview callbacks
extension AwardsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemCount
    }
    
    // Setting cells values.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PrizesTableViewCell else {return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)}
        
        let num = indexPath.row + 1
        
        cell.prizeNum.text = num.description
        cell.prizeName.delegate = self
        
        return cell
    }
}

// Textfield Extension
extension AwardsVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Add an edit button or some way to allow the user to edit the textfields
        
        guard !textField.isNullOrWhitespace() else {
            let alert = Utils.basicAlert(title: "Invalid Prize", message: "Please make sure the entry is not left empty or does not contain only spaces.", Button: "OK")
            
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
}
