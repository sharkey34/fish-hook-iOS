//
//  AdminTournamentsCollectionViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TournamentsCollectionAdminVC: UICollectionViewController {
    
    
    // TODO: Make this double for both Admins and regular users.
    
    var tournaments = [Tournaments]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = "Admin Dashboard"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tournaments.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AdminDashboardCollectionCell else {return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)}
    
        print(tournaments.count)
        print(indexPath.row)
        // Configure the cell
        if indexPath.row > tournaments.count || tournaments.count == 0 {
            // TODO: Add image
            cell.tournamentImage.image = UIImage(named: "Plus")
            cell.dateLabel.text = ""
            cell.dateLabel.textColor = UIColor.blue
        } else {
            // TODO: Normal setup
            // TODO: Get and set image from storage.
            cell.tournamentImage.image = UIImage(named: "DefaultTournament")
            cell.dateLabel.text = tournaments[indexPath.row].created
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: If add button selected then segue to tournament creation else go to details of tournament.
        if indexPath.row > tournaments.count || tournaments.count == 0 {
         
            performSegue(withIdentifier: "toTournament", sender: self)
            
        } else {
            // TODO ORRR make this the active tournament.
        }
    }
    
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
