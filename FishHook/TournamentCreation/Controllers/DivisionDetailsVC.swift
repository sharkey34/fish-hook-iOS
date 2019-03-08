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
    var awards = [Award]()
    var newDivision: Division?
    
    // Doesn't necessarily need to have rewards for each division
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.DivisionDetails.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelected(sender:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelected(sender:)))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Temporary
//        awards = Global.awards
        tableView.reloadData()
    }
    
    @objc func saveSelected(sender: UIBarButtonItem) {

        //TODO: Validation
        guard !divisionName.isNullOrWhitespace(), awards.count > 0 else {
            
            let alert = Utils.basicAlert(title: "Invalid Division Details", message: "Please enter valid information for this Division", Button: "OK")
            
            self.present(alert, animated: true, completion: nil)
            return
        }
    
        // TODO: Save to Realm and Dismiss controller maybe pass back in an Unwind Segue.
        
//
//        Global.divisions.append(Division(_id: nil, _name: divisionName.text!, _sponsor: sponsorName.text, _awards: Global.awards))
//        Global.awards.removeAll()
            newDivision = Division(_id: nil, _name: divisionName.text!, _sponsor: sponsorName.text, _awards: Global.awards)
        
        performSegue(withIdentifier: "unwindToCreate", sender: self)
    
//        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelSelected(sender: UIBarButtonItem){
        performSegue(withIdentifier: "unwindToCreate", sender: self)
    }
    
    
    // Sending Division
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cdVC = segue.destination as? CreateDivisionVC else {return}
        
        print("willShow CreateDivision")
        
        if let createdDivision = newDivision {
            cdVC.divisions.append(createdDivision)
        }
    }
    
    
    
    @IBAction func unwindToDetails(segue: UIStoryboardSegue) {
        
    }
}


extension DivisionDetailsVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return awards.count
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = awards[indexPath.row].name
        return cell
    }
}
