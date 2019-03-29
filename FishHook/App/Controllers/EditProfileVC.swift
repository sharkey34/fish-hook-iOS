//
//  EditProfileVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/29/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet var entries: [UITextField]!
    @IBOutlet weak var aboutTV: UITextView!
    
    var imagePicker = UIImagePickerController()
    var currentUser: User!
    var db: Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp(){
        db = Firestore.firestore()
        imagePicker.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        profileIV.addGestureRecognizer(tap)
        
        if let image = currentUser.profileImage {
            profileIV.image = image
        }
        
        if currentUser.admin {
            adminSetUp()
        } else {
            participantSetUp()
        }
    }
    
    // Setting up Admin values
    func adminSetUp(){
        
        entries[0].placeholder = currentUser.organization ?? "Organizer Name"
        entries[1].placeholder = currentUser.phone ?? "Phone Number"
        entries[2].placeholder = currentUser.address ?? "Organization Address"
        
        aboutTV.isHidden = false
        aboutTV.isEditable = true
    }
    
    // Setting up participant values
    func participantSetUp(){
        
        entries[0].placeholder = currentUser.userName
        entries[1].placeholder = currentUser.boat ?? "Boat name"
        entries[2].placeholder = currentUser.captain ?? "Captain name"
        
        aboutTV.isHidden = true
        aboutTV.isEditable = false
    }
    
    // Selecting image from camera alerting user if access is not available
    func addImage(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = Utils.basicAlert(title: "Access not granted", message: "Please navigate to settings and grant access to your photo library.", Button: "OK")
            present(alert, animated: true, completion: nil)
        }
    }

    // ACTIONS
    
    @IBAction func uploadTapped(_ sender: UIButton) {
        addImage()
    }
    
    @objc
    func imageTapped(sender: UITapGestureRecognizer) {
        addImage()
    }
    
    
    @IBAction func submitTapped(_ sender: UIButton) {
        
    }
}

// ImagePicker delegate extension
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Getting the image from the picker and setting it in the imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let edited = info[.editedImage] as? UIImage {
            profileIV.image = edited
        } else if let original = info[.originalImage] as? UIImage {
            profileIV.image = original
        } else {
            // TODO: Present the user with an Alert
            print("No image selected.")
        }
        dismiss(animated: true, completion: nil)
    }
}
