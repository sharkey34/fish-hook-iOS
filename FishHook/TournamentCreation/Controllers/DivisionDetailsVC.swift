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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.DivisionDetails.rawValue
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
