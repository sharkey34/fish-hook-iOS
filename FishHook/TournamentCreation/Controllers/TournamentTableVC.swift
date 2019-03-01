//
//  TournamentNavTableViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/25/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class TournamentTableVC: UITableViewController {
    
    private let titles = [TournamentSetup.Basic, TournamentSetup.Dates, TournamentSetup.Fish, TournamentSetup.Divisions, TournamentSetup.Summary]

    // TODO: Possible delete the initial basic and select the basic view right away and highlight then segue after.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tournament Setup"
    }

    override func viewWillAppear(_ animated: Bool) {
        // Setting tableview color and selecting the first cell.
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        tableView.backgroundColor = UIColor(displayP3Red: 25/255, green: 132/255, blue: 236/255, alpha: 1)
    }
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // TODO: Make fit for each device.
        tableView.rowHeight = view.frame.height / 10
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SplitTableViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        // cell setup
        cell.title.text = titles[indexPath.row].rawValue
        cell.selectionStyle = .blue
        cell.backgroundColor = UIColor(displayP3Red: 25/255, green: 132/255, blue: 236/255, alpha: 1)
        cell.title.textColor = UIColor.white
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Seguing to the proper view dependent on the cell selected.
        switch titles[indexPath.row] {
        case TournamentSetup.Basic:
            performSegue(withIdentifier: "toBasic", sender: self)
        case TournamentSetup.Dates:
            performSegue(withIdentifier: "toRunDates", sender: self)
        case TournamentSetup.Fish:
            performSegue(withIdentifier: "toFishSpecies", sender: self)
        case TournamentSetup.Divisions:
            performSegue(withIdentifier: "toDivisions", sender: self)
        case TournamentSetup.Summary:
            performSegue(withIdentifier: "toSummary", sender: self)
        default:
            performSegue(withIdentifier: "toBasic", sender: self)
        }
    }

}
