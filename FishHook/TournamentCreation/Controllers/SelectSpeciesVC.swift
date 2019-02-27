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
    var selectedSpecies = [Fish]()
    var db: Firestore?
    
    // Creating a searchController.
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Fish.rawValue
        
        getAndParseFishSpecies()
        searchControllerSetup()
    }
    
    
    func getAndParseFishSpecies(){
        db?.collection("fish").getDocuments(completion: { (document, error) in
            if let err = error {
                print("Error retreving fish species." + " " + err.localizedDescription)
                // TODO: alert the user.
            } else {
                for doc in document!.documents {
                    
                    let name = doc.data()["name"] as! String
                    let type = doc.data()["type"] as! Int
                    
                    let newFish = Fish(_name: name, _type: type, _checked: false, _weight: nil, _length: nil)
                    self.fishSpecies.append(newFish)
                }
                self.filteredSpecies = self.fishSpecies
                self.tableView.reloadData()
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
        searchController.searchBar.scopeButtonTitles = [Water.Both.rawValue , Water.Fresh.rawValue, Water.Salt.rawValue]
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
            selectedSpecies.removeAll { (fish) -> Bool in
                if fish.name == selected.name {
                    return true
                } else {
                    return false
                }
            }
        } else {
            selected.checked = true
            cell.accessoryType = .checkmark
            selectedSpecies.append(selected)
        }
    }
}

extension SelectSpeciesVC: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
                // Getting the text entered into the search bar.
                let enteredText = searchController.searchBar.text
        
                // Getting the scope index, the array of titles and then getting the exact title at the selected scope.
                let scopeIndex = searchController.searchBar.selectedScopeButtonIndex
                let scopeTitles = searchController.searchBar.scopeButtonTitles
                let scope = scopeTitles![scopeIndex]
        
                // Setting the filtered array equal to the locationArray.
                filteredSpecies = fishSpecies
        
                // Filtering by entered text.
                if enteredText != ""{
                    filteredSpecies = filteredSpecies.filter({$0.name.lowercased().range(of: enteredText!.lowercased()) != nil})
                }
        
                // Filtering by scope.
                if scope != Water.Both.rawValue {
                    filteredSpecies = filteredSpecies.filter({$0.type == scopeIndex})
                }
                // Reloading the tableView.
                tableView.reloadData()
    }
    
    // Updating the results for the when the selected scope has changed.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}
