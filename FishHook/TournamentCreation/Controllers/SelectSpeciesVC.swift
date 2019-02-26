//
//  SelectSpeciesVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/25/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class SelectSpeciesVC: UITableViewController {
    
    var fishSpecies = [Fish]()
    var filteredSpecies = [Fish]()
    
    
    // Creating a searchController.
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Fish.rawValue
        
        getAndParseFishSpecies()
        searchControllerSetup()
    }
    
    
    func getAndParseFishSpecies(){
          // TODO: Download Fish Species.
        
    }
    
    func searchControllerSetup(){
        // Setting up search controller.
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        
        // Setting up the searchBar of search controller.
        searchController.searchBar.scopeButtonTitles = [Water.Fresh.rawValue, Water.Salt.rawValue]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)


        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension SelectSpeciesVC: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        //        // Getting the text entered into the search bar.
        //        let enteredText = searchController.searchBar.text
        //
        //        // Getting the scope index, the array of titles and then getting the exact title at the selected scope.
        //        let selectedScope = searchController.searchBar.selectedScopeButtonIndex
        //        let scopeTitles = searchController.searchBar.scopeButtonTitles
        //        let scope = scopeTitles![selectedScope]
        //
        //        // Setting the filtered array equal to the locationArray.
        //        filteredLocations = locationArray
        //
        //        // Filtering by entered text.
        //        if enteredText != ""{
        //            filteredLocations = filteredLocations.filter({$0.city.lowercased().range(of: enteredText!.lowercased()) != nil})
        //        }
        //
        //        // Filtering by scope.
        //        if scope != "All"{
        //            filteredLocations = filteredLocations.filter({$0.state.range(of: scope) != nil})
        //        }
        //
        //        // Reloading the tableView.
        //        tableView.reloadData()
    }
    
    // Updating the results for the when the selected scope has changed.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}
