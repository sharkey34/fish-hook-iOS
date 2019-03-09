//
//  CreateDivisionVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/25/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class CreateDivisionVC: UICollectionViewController {
    
    var divisions = [Division]()
    
    // Core Data variables.
    private var managedContext: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    private var newTournament: NSManagedObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Core Data Setup
        managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "NewTournament", in: managedContext)
        newTournament = NSManagedObject(entity: entity, insertInto: managedContext)
    
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Divisions.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelected(sender:)))

        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Temporary
//        divisions = Global.divisions
//        self.collectionView.reloadData()
    }
    
    @objc func saveSelected(sender: UIBarButtonItem) {
        
        // Validating
        guard divisions.count > 0 else {
            
            let alert = Utils.basicAlert(title: "No Divisions added", message: "Please add at least one General divison for your tournament.", Button: "OK")
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // TODO: Add divisions to CoreData
        newTournament.setValue(divisions, forKey: "divisions")
        
        let alert = Utils.basicAlert(title: "Saved", message: "All Divisions and their details have been saved", Button: "OK")
        present(alert, animated: true, completion: nil)
        
        for div in divisions {
            print(div.awards?.count)
        }
        
        loadAndTest()
//        Global.tournament.divisions = Global.divisions
        
    }
    
    
        // Loading data from CoreData
        func loadAndTest(){
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NewTournament")
            do{
                let data: [NSManagedObject] = try managedContext.fetch(fetchRequest)
    
                for obj in data {
                    
                    guard let d = obj.value(forKey: "divisions") as? [Division] else {return}
                    
                    for dv in d {
                        print(dv.name)
                        
                        let a = dv.awards
                        
                        guard let award = a else {return}
                        
                        for aw in award {
                            print(aw.name)
                        }
                    }
                    
                }
            } catch {
                assertionFailure()
            }
        }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return divisions.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CreateDivisionCell else {return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)}
    
        if divisions.count == 0 || indexPath.row == divisions.count {
            cell.image.image = UIImage(named: "Plus")
            cell.title.text = ""
        } else {
            // Add default image.
            cell.image.image = UIImage(named: "Division")
            cell.title.text = divisions[indexPath.row].name
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Segue when the add button is selected.
        performSegue(withIdentifier: "toDivisionDetails", sender: self)
    }
    
    
    @IBAction func unwindFromDivisionDetails(segue: UIStoryboardSegue) {
        
        guard let dvVC = segue.source as? DivisionDetailsVC else {return}
        
        if let newDivision = dvVC.newDivision {
            divisions.append(newDivision)
            self.collectionView.reloadData()
        }
    }
}
