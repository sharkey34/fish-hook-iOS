//
//  SelectSpeciesVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/25/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import Firebase

class SelectSpeciesVC: UITableViewController {
    
    var fishSpecies = [Fish]()
    var filteredSpecies = [Fish]()
    var db: Firestore?
    var fresh = false
    var salt = false
    
    weak var delegate: detailDelegate?
    
    // Creating a searchController.
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        checkType()
        getAndParseFishSpecies()
        searchControllerSetup()
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Fish.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelected(sender:)))
    }
    
    // Checking the watertypes selected
    func checkType(){
        if Global.tournament.waterType.count > 0 {
            for type in Global.tournament.waterType {
                switch type {
                case "Freshwater":
                    fresh = true
                case "Saltwater":
                    salt = true
                default:
                    break
                }
            }
        }
    }
    
    
    // Setting values based on what was selected
    func setUpValues(){
        print(Global.tournament.fishSpecies.count)
        if Global.tournament.fishSpecies.count > 0 {
            for fish in Global.tournament.fishSpecies.enumerated() {
                for filteredFish in filteredSpecies {
                    if fish.element.name == filteredFish.name {
                        filteredFish.checked = true
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    @objc func saveSelected(sender: UIBarButtonItem){
        
        // Validating at least one fish Species has been selected.
        guard Global.tournament.fishSpecies.count > 0 else {
            let alert = Utils.basicAlert(title: "No Fish Selected", message: "Please select the Fish Species that can be caught in your tournament.", Button: "OK")
            present(alert, animated: true, completion: nil)
            return
        }
       
        delegate?.pushDetail(cell: 3, indentifier: Segues.Divisions.rawValue)
    }
    
    
    // Retreiving fish species from the database
    func getAndParseFishSpecies(){
        db?.collection("fish").getDocuments(completion: { (document, error) in
            if let err = error {
                print("Error retreving fish species." + " " + err.localizedDescription)
                
                // alert the user.
                let alert = Utils.basicAlert(title: "Error retreving fish species", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
                
            } else {
                for doc in document!.documents {
                    
                    let name = doc.data()["name"] as! String
                    let type = doc.data()["type"] as! Int
                    
                    let newFish = Fish(_id: doc.documentID,_name: name, _type: type, _checked: false, _weight: nil, _length: nil)
                    
                    if self.fresh && !self.salt{
                        if newFish.type == 1 {
                            self.fishSpecies.append(newFish)
                        }
                    } else if self.salt && !self.fresh{
                        if newFish.type == 2 {
                            self.fishSpecies.append(newFish)
                        }
                    } else {
                        self.fishSpecies.append(newFish)
                    }
                }
                self.filteredSpecies = self.fishSpecies
                self.setUpValues()
            }
        })
    }
    
    func searchControllerSetup(){
        // Setting up search controller.
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor.white
        
        // Setting up the searchBar of search controller.
        if fresh && salt {
            searchController.searchBar.scopeButtonTitles = [Water.Both.rawValue , Water.Fresh.rawValue, Water.Salt.rawValue]
        }
        searchController.searchBar.delegate = self
        
        // Adding the searchBar to the tableViewController.
        navigationItem.searchController = searchController
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Possibly set custom row height
        return filteredSpecies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let fish = filteredSpecies[indexPath.row]
        
        cell.textLabel?.text = fish.name
        cell.accessoryType = fish.checked ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        let selected = filteredSpecies[indexPath.row]
        
        // If the fish is already checked then removing the item. Otherwise checking the item and adding to the array.
        if selected.checked {
            selected.checked = false
            cell.accessoryType = .none
            Global.tournament.fishSpecies.removeAll { (fish) -> Bool in
                if fish.name == selected.name {
                    return true
                } else {
                    return false
                }
            }
        } else {
            selected.checked = true
            cell.accessoryType = .checkmark
            Global.tournament.fishSpecies.append(selected)
        }
    }
}

extension SelectSpeciesVC: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Getting the text entered into the search bar.
        let enteredText = searchController.searchBar.text
        
        // Setting the filtered array equal to the fishspecies array.
        filteredSpecies = fishSpecies
        
        
        if fresh && salt {
            // Getting the scope index, the array of titles and then getting the exact title at the selected scope.
            let scopeIndex = searchController.searchBar.selectedScopeButtonIndex
            let scopeTitles = searchController.searchBar.scopeButtonTitles
            let scope = scopeTitles![scopeIndex]
            
            // Filtering by scope.
            if scope != Water.Both.rawValue {
                filteredSpecies = filteredSpecies.filter({$0.type == scopeIndex})
            }
        }
        
 
        // Filtering by entered text.
        if enteredText != ""{
            filteredSpecies = filteredSpecies.filter({$0.name.lowercased().range(of: enteredText!.lowercased()) != nil})
        }
        
        // Reloading the tableView.
        tableView.reloadData()
    }
    
    // Updating the results for the when the selected scope has changed.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}
