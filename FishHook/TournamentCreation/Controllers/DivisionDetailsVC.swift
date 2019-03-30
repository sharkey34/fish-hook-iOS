//
//  DivisionDetailsVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/26/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class DivisionDetailsVC: UIViewController {
    @IBOutlet weak var divisionName: UITextField!
    @IBOutlet weak var sponsorName: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var editingDivision: Division?
    var edit = false
    var editingAward: Award?
    
    // Doesn't necessarily need to have rewards for each division
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.DivisionDetails.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelected(sender:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelected(sender:)))
        
        if let division = editingDivision {
            edit = true
            setEditingDivisionValues(division: division)
        } else {
            edit = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // Setting intial values to the division being edited
    func setEditingDivisionValues(division: Division){
        if let name = division.name {
            divisionName.text = name
        }
        if let sponsor = division.sponsor {
            sponsorName.text = sponsor
        }
        Global.awards = division.awards!
    }
    
    @objc func saveSelected(sender: UIBarButtonItem) {
        //Validation
        guard !divisionName.isNullOrWhitespace(), Global.awards.count > 0 else {
            let alert = Utils.basicAlert(title: "Invalid Division Details", message: "Please enter valid information for this Division", Button: "OK")
            self.present(alert, animated: true, completion: nil)
            return
        }
        if !edit {
            Global.divisions.append(Division(_id: nil, _tID: nil, _name: divisionName.text!, _sponsor: sponsorName.text, _awards: Global.awards))
        } else {
            editingDivision?.name = divisionName.text!
            editingDivision?.sponsor = sponsorName.text
            editingDivision?.awards = Global.awards
        }
        Global.awards.removeAll()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelSelected(sender: UIBarButtonItem){
        Global.awards.removeAll()
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.Awards.rawValue {
            if let awardVC = segue.destination as? AwardsVC {
                awardVC.editingAward = editingAward
            }
        }
    }
}

// Table View functions
extension DivisionDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.awards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Global.awards[indexPath.row].name
        return cell
    }
    
    // Adding tableViewActions
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            Global.awards.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // edit item at indexPath
            self.editingAward = Global.awards[indexPath.row]
            self.performSegue(withIdentifier: Segues.Awards.rawValue, sender: self)
        }
        edit.backgroundColor = UIColor.green
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // edit item at indexPath
        self.editingAward = Global.awards[indexPath.row]
        self.performSegue(withIdentifier: Segues.Awards.rawValue, sender: self)
    }
}
