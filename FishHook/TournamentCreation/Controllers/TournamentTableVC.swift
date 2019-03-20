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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tournament Setup"
        
        // Setting initial Basic Details Controllers Delegate
        if let controllers = splitViewController?.viewControllers {
            if let nav = controllers[1] as? UINavigationController {
                if let basic = nav.topViewController as? BasicDetailsVC {
                    basic.delegate = self
                }
            }
        }
        
        if let splitView = self.navigationController?.splitViewController, !splitView.isCollapsed {
            self.navigationItem.leftBarButtonItem = splitView.displayModeButtonItem
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelected(sender:)))
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func cancelSelected(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // cell setup
        cell.textLabel?.text = titles[indexPath.row].rawValue
        cell.backgroundColor = UIColor(displayP3Red: 25/255, green: 132/255, blue: 236/255, alpha: 1)
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Seguing to the proper view dependent on the cell selected.
        switch titles[indexPath.row] {
        case TournamentSetup.Basic:
            performSegue(withIdentifier: Segues.Basic.rawValue, sender: self)
        case TournamentSetup.Dates:
            performSegue(withIdentifier: Segues.Dates.rawValue, sender: self)
        case TournamentSetup.Fish:
            performSegue(withIdentifier: Segues.Fish.rawValue, sender: self)
        case TournamentSetup.Divisions:
            performSegue(withIdentifier: Segues.Divisions.rawValue, sender: self)
        case TournamentSetup.Summary:
            performSegue(withIdentifier: Segues.Summary.rawValue, sender: self)
        default:
            performSegue(withIdentifier: Segues.Basic.rawValue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nav = segue.destination as? UINavigationController else {return}
        
        switch segue.identifier {
        case Segues.Basic.rawValue:
            guard let detailsVC = nav.topViewController as? BasicDetailsVC else {return}
            // Display mode button
            detailsVC.delegate = self
            detailsVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            detailsVC.navigationItem.leftItemsSupplementBackButton = true
            break
        case Segues.Dates.rawValue:
            guard let runDatesVC = nav.topViewController as? RunDatesVC else {return}
            // Display mode button
            runDatesVC.delegate = self
            runDatesVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            runDatesVC.navigationItem.leftItemsSupplementBackButton = true
            break
        case Segues.Fish.rawValue:
            guard let speciesVC = nav.topViewController as? SelectSpeciesVC else {return}
            // Display mode button
            speciesVC.delegate = self
            speciesVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            speciesVC.navigationItem.leftItemsSupplementBackButton = true
            break
        case Segues.Divisions.rawValue:
            guard let divisionsVC = nav.topViewController as? CreateDivisionVC else {return}
            // Display mode button
            divisionsVC.delegate = self
            divisionsVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            divisionsVC.navigationItem.leftItemsSupplementBackButton = true
            break
        case Segues.Summary.rawValue:
            guard let summaryVC = nav.topViewController as? SummaryVC else {return}
            // Display mode button
            summaryVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            summaryVC.navigationItem.leftItemsSupplementBackButton = true
            break
        default:
            guard let detailsVC = nav.topViewController as? BasicDetailsVC else {return}
            // Display mode button
            detailsVC.delegate = self
            detailsVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            detailsVC.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}

extension TournamentTableVC: detailDelegate {
    func pushDetail(cell: Int, indentifier: String) {
        
        let indexPath = IndexPath(row: cell, section: 0)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: indentifier, sender: self)
    }
}
