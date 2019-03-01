//
//  CreateDivisionVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/25/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CreateDivisionVC: UICollectionViewController {
    
    var divisions = [Division]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Divisions.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelected(sender:)))

        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    @objc func saveSelected(sender: UIBarButtonItem) {
        
        // Validating
        guard divisions.count > 0 else {
            
            let alert = Utils.basicAlert(title: "No Divisions added", message: "Please add at least one General divison for your tournament.", Button: "OK")
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // TODO: Add divisions to Realm()
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return divisions.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CreateDivisionCell else {return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)}
    
        if divisions.count == 0 || indexPath.row > divisions.count {
            cell.image.image = UIImage(named: "Plus")
            cell.title.text = ""
        } else {
            // TODO: Add default image.
            cell.title.text = divisions[indexPath.row].name
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Segue when the add button is selected.
        
        performSegue(withIdentifier: "toDivisionDetails", sender: self)
    }
}
