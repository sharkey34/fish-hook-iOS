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
    var editingDivision: Division?
    weak var delegate: detailDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Divisions.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelected(sender:)))
        
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Temporary
        editingDivision = nil
        divisions = Global.divisions
        self.collectionView.reloadData()
    }
    
    @objc func saveSelected(sender: UIBarButtonItem) {
        // Validating
        guard divisions.count > 0 else {
            let alert = Utils.basicAlert(title: "No Divisions added", message: "Please add at least one General divison for your tournament.", Button: "OK")
            self.present(alert, animated: true, completion: nil)
            return
        }
        Global.tournament.divisions = Global.divisions
        delegate?.pushDetail(cell: 4, indentifier: Segues.Summary.rawValue)
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
            // TODO: Add default image.
            cell.image.image = UIImage(named: "Division")
            editingDivision = nil
            cell.title.text = divisions[indexPath.row].name
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Segue when the add button is selected.
        if divisions.count == 0 || indexPath.row == divisions.count {
            performSegue(withIdentifier: Segues.Details.rawValue, sender: self)
        } else {
            presentActionSheet(indexPath: indexPath)
        }
    }
    
    // Creating and presenting the actionSheet
    func presentActionSheet(indexPath: IndexPath){
        let alertController = UIAlertController(title: nil, message: "Edit or Delete", preferredStyle: .actionSheet)
        
        // Setting the editingDivision value and performing segue
        let edit = UIAlertAction(title: "Edit", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do some action here.
            DispatchQueue.main.async {
                self.editingDivision = self.divisions[indexPath.row]
                self.performSegue(withIdentifier: Segues.Details.rawValue, sender: self)
            }
        })
        
        // Deleting the item and reloading the collectionView
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            DispatchQueue.main.async {
                Global.divisions.remove(at: indexPath.row)
                self.divisions = Global.divisions
                self.collectionView.reloadData()
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(edit)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        
        // Checking the current device.
        let device = UIDevice.current
        
        if device.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if let controller = alertController.popoverPresentationController {
                let cell = collectionView.cellForItem(at: indexPath) as! CreateDivisionCell
                controller.sourceView = cell.contentView
                controller.sourceRect = CGRect(x: cell.contentView.bounds.midX, y: cell.contentView.bounds.maxY, width: 0, height: 0)
                controller.permittedArrowDirections = [.up]
            }
        }
        present(alertController, animated: true, completion: nil)
    }
    
    // Sending the selected division to details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.Details.rawValue {
            if let detailsVC = segue.destination as? DivisionDetailsVC {
                detailsVC.editingDivision = editingDivision
            }
        }
    }
}
