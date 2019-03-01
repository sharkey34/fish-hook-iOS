//
//  BasicDetailsVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/24/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class BasicDetailsVC: UIViewController {
    @IBOutlet weak var tournamentName: UITextField!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var waterType: [UISwitch]!
    @IBOutlet var metrics: [UISwitch]!
    
    var participants = [(Participants.Angler, false), (Participants.Captain, false), (Participants.Boat, false)]
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // Initial setup
    func setUp(){
        tableview.delegate = self
        tableview.dataSource = self
        imagePicker.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelected(sender:)))
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Basic.rawValue
    }
    
    @IBAction func addLogoTapped(_ sender: UIButton) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func saveSelected(sender: UIBarButtonItem){
        var name = false
        var type = false
        var metric = false
        var participant = false
        var tournamentLogo = false
        
        // Validating User entries
        if !tournamentName.isNullOrWhitespace() {
            name = true
        }
        
        for toggle in waterType {
            if toggle.isOn {
                type = true
            }
        }
        
        for toggle in metrics {
            if toggle.isOn {
                metric = true
            }
        }
        
        for p in participants {
            if p.1 {
                participant = true
            }
        }
        
        if let _ = logo.image {
            tournamentLogo = true
        }
        
        // TODO: Validate entries
        if name && type && metric && participant && tournamentLogo {
            // TODO: Save to database
            saveBasicDetails()
            
        } else {
            let alert = Utils.basicAlert(title: "Invalid Form", message: "Please make sure all fields are correctly filled and at least one switch is selected in each category.", Button: "OK")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveBasicDetails(){
        print("Saving to Database")
    }
}

// UITableView Callbacks
extension BasicDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Participants.Participants.rawValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = participants[indexPath.row].0.rawValue
        cell.accessoryType = participants[indexPath.row].1 ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Check the selected tableView item
    
        let checked = !(participants[indexPath.row].1)
        
        participants[indexPath.row].1 = checked
        tableView.cellForRow(at: indexPath)?.accessoryType = checked ? .checkmark : .none
    }
}

extension BasicDetailsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Getting the image from the picker and setting it in the imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let edited = info[.editedImage] as? UIImage {
            logo.image = edited
        } else if let original = info[.originalImage] as? UIImage {
            logo.image = original
        } else {
            // TODO: Present the user with an Alert
            print("No image selected.")
        }
        
        dismiss(animated: true, completion: nil)
    }
}
