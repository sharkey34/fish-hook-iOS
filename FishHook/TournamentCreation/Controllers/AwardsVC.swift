//
//  AwardsVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/27/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseStorage

class AwardsVC: UIViewController {
    @IBOutlet weak var awardName: UITextField!
    @IBOutlet weak var sponsorName: UITextField!
    @IBOutlet weak var fishSpecies: UITextField!
    @IBOutlet weak var prizeCount: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stepper: UIStepper!
    
    var prizes = [String]()
    var itemCount: Int = 0
    var editingAward: Award?
    var edit = false
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Awards.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelected(sender:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelected(sender:)))
        
        setEditingAwardValues()
    }
    
    
    // Setting initial values to editing award values
    func setEditingAwardValues(){
        guard let award = editingAward else {return}
        
        awardName.text = award.name
        
        if let sponsor = award.sponsor {
            sponsorName.text = sponsor
        }
        
        fishSpecies.text = award.fishSpecies
        prizeCount.text = award.prizes?.count.description
        
        if let p = award.prizes {
            prizes = p
            itemCount = prizes.count
            stepper.value = Double.init(itemCount)
        }
        
        edit = true
        tableView.reloadData()
    }
    
    @objc func saveSelected(sender: UIBarButtonItem) {
        
        // Getting all the final values entered in the prize cells
        guard let cells = tableView.visibleCells as? [PrizesTableViewCell] else {return}
        
        prizes.removeAll()
        for cell in cells {
            if !cell.prizeName.isNullOrWhitespace() {
                prizes.append(cell.prizeName.text!)
            }
        }
        
        // verify inputs.
        guard !awardName.isNullOrWhitespace(), !fishSpecies.isNullOrWhitespace(), prizes.count > 0 else {
            let alert = Utils.basicAlert(title: "Invalid Award Entries", message: "Please make sure to fill out all fields correctly. You must also have added at least one prize.", Button: "OK")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
     
        if edit {
            editingAward?.prizes = prizes
            editingAward?.name = awardName.text!
            editingAward?.sponsor = sponsorName.text
            editingAward?.fishSpecies = fishSpecies.text!
        } else {
            print(Global.awards.count)

            Global.awards.append(Award(_id: nil, _name: awardName.text!, _sponsor: sponsorName.text, _prizes: prizes, _fishSpecies: fishSpecies.text!))
            
            print(Global.awards.count)
        }
        edit = false
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelSelected(sender: UIBarButtonItem) {
        edit = false
        editingAward = nil
        navigationController?.popViewController(animated: true)
    }
    
    // Incrementing count and reloading tableview
    @IBAction func StepperChange(_ sender: UIStepper) {
        itemCount = Int(sender.value)
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
    
    // Setting cells values.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PrizesTableViewCell else {return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)}
        
        if edit && indexPath.row < prizes.count && firstLoad {
            cell.prizeName.text = prizes[indexPath.row]
            if indexPath.row == prizes.count - 1 {
                firstLoad = false
            }
        }
        let num = indexPath.row + 1
        cell.prizeNum.text = num.description
        cell.prizeName.delegate = self
        
        return cell
    }
}

extension AwardsVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard !textField.isNullOrWhitespace() else {
            let alert = Utils.basicAlert(title: "Invalid Prize", message: "Please make sure the entry is not left empty or does not contain only spaces.", Button: "OK")
            
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
}
