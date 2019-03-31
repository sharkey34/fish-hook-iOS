//
//  EditProfileVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/29/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet var entries: [UITextField]!
    @IBOutlet weak var aboutTV: UITextView!
    @IBOutlet weak var aboutLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    var currentUser: User!
    var db: Firestore?
    var storage: Storage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeUnsubscribe(bool: true)
        setUp()
    }
    
    // Initial Setup
    func setUp(){
        db = Firestore.firestore()
        storage = Storage.storage()
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
        entries[0].text = currentUser.organization ?? "Organizer Name"
        entries[1].text = currentUser.phone ?? "Phone Number"
        entries[1].keyboardType = .phonePad
        entries[2].text = currentUser.address ?? "Organization Address"
        entries[2].textContentType = .fullStreetAddress
        aboutTV.text = currentUser.about ?? "No Information"
        
        aboutTV.isHidden = false
        aboutTV.isEditable = true
    }
    
    // Setting up participant values
    func participantSetUp(){
        entries[0].text = currentUser.userName
        entries[1].text = currentUser.boat ?? "Boat name"
        entries[2].text = currentUser.captain ?? "Captain name"
        aboutLabel.text = nil
        
        aboutTV.isHidden = true
        aboutTV.isEditable = false
    }

    // ACTIONS
    
    @IBAction func uploadTapped(_ sender: UIButton) {
        addImage()
    }
    
    @objc
    func imageTapped(sender: UITapGestureRecognizer) {
        addImage()
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
    
    @IBAction func submitTapped(_ sender: UIButton) {
        // TODO: Save to Firebase and Storage
        // TODO: Update model
        
        if validateEntries() {
            if currentUser.admin {
                currentUser.about = aboutTV.text
                currentUser.organization = entries[0].text
                currentUser.phone = entries[1].text
                currentUser.address = entries[2].text
            } else {
                currentUser.userName = entries[0].text!
                currentUser.boat = entries[1].text
                currentUser.captain = entries[2].text
            }
            currentUser.profileImage = profileIV.image

            uploadImage()
        } else {
            let alert = Utils.basicAlert(title: "Invalid Entries", message: "One or more entries are invalid, make sure not entries are left blank", Button: "OK")
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    // Uploading image to storage
    func uploadImage(){
        var imageID = NSUUID().uuidString
        
        if let id = currentUser.imageID {
            imageID = id
        }
        
        guard let storageRef = storage?.reference().child("profile/\(imageID).jpg") else {return}
        
        // Local file you want to upload
        guard let imageData = profileIV.image!.jpegData(compressionQuality: 0.1) else {return}
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = storageRef.putData(imageData, metadata: metadata)
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            
            print(percentComplete.description)
        }
        updateUser(imageID: imageID)
    }
    
    // Updating user information in Firebase
    func updateUser(imageID: String) {
        var values: [String:Any] = [:]
        
        if currentUser.admin {
            values.updateValue(entries[0].text!, forKey: "org")
            values.updateValue(entries[1].text!, forKey: "phone")
            values.updateValue(entries[2].text!, forKey: "address")
        } else {
            values.updateValue(entries[0].text!, forKey: "userName")
            values.updateValue(entries[1].text!, forKey: "boat")
            values.updateValue(entries[2].text!, forKey: "captain")
        }
        values.updateValue(imageID, forKey: "imageID")
        currentUser.imageID = imageID
        
        // Updating user data in Firestore
        db?.collection("users").document(currentUser.uid).updateData(values
            , completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    DispatchQueue.main.async {
                        let alert = Utils.basicAlert(title: "Error", message: error.localizedDescription, Button: "OK")
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                self.navigationController?.popViewController(animated: true)
        })
    }
    
    // Validating Entries
    func validateEntries() -> Bool {
        if currentUser.admin {
            guard !entries[0].isNullOrWhitespace(), !entries[1].isNullOrWhitespace(), !entries[2].isNullOrWhitespace(), let _ = profileIV.image else {return false}
        } else {
            guard !entries[0].isNullOrWhitespace(), let _ = profileIV.image else {return false}
        }
        return true
    }
    
    @objc func show(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    
    @objc func hide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // Subscribing and unsubscribing to keyboard observers.
    func subscribeUnsubscribe(bool: Bool){
        if bool == true {
            NotificationCenter.default.addObserver(self, selector: #selector(show(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(hide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
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
