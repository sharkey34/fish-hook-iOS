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
    var itemCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func StepperChange(_ sender: UIStepper) {
        itemCount = Int(sender.value)
        prizeCount.text = itemCount!.description
        tableView.reloadData()
    }
}

// Tableview callbacks
extension AwardsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = itemCount {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PrizesTableViewCell else {return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)}
        
        cell.prizeNum.text = indexPath.row.description
        cell.prizeName.delegate = self
        
        return cell
    }
}

extension AwardsVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Get the text from the textField
        
        print(textField.text)
    }
}
