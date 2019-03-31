//
//  AddOfficialCatchVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/11/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class AddOfficialCatchVC: UIViewController {
    @IBOutlet weak var catchIV: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var metricTF: UITextField!
    @IBOutlet weak var fishTF: UITextField!
    
    var aID: String!
    var imagePicker = UIImagePickerController()
    var db: Firestore!
    var catchID: String?
    var userName: String?
    var userID: String?
    var storage: Storage?
    var newCatch: Catch?
    var imageID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeUnsubscribe(bool: true)
      setUp()
    }
    
    func setUp(){
        storage = Storage.storage()
        db = Firestore.firestore()
        imagePicker.delegate = self

        navigationItem.title = "Add Catch"
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        catchIV.addGestureRecognizer(tap)
    }
    
    // Opening camera when take picture is selected.
    @IBAction func takePicture(_ sender: UIButton) {
        addImage()
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        addImage()
    }
    
    // Selecting image from camera alerting user if access is not available
    func addImage(){        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = Utils.basicAlert(title: "Access not granted", message: "Please navigate to settings and grant access to the camera.", Button: "OK")
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        guard !metricTF.isNullOrWhitespace(), !fishTF.isNullOrWhitespace(), emailTF.isValidEmail(), let catchImage = catchIV.image else {
            let alert = Utils.basicAlert(title: "Invalid Entries", message: "Please make sure the entries are valid and not empty.", Button: "OK")
            present(alert, animated: true, completion: nil)
            return
        }
        imageID = NSUUID().uuidString
        guard let id = imageID else {return}
        self.uploadImage(imageID: id, image: catchImage)
        
        // Getting catchID
        catchID = db.collection("official").document().documentID
        // Getting the entered user and fullname
        db.collection("users").whereField("email", isEqualTo: emailTF.text!).getDocuments(source: .default, completion: { (documents, error) in
            if let err = error {
                let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
            } else {
                if let docs = documents?.documents {
                    
                    if docs.count > 0 {
                        for doc in docs {
                            self.userID = doc.documentID
                            let map = doc.data()
                            self.userName = map["userName"] as? String
                            self.addCatch(imageID: id)
                        }
                    }else {
                        let alert = Utils.basicAlert(title: "Error", message: "No user with that email found. Please double check you entered the correct email.", Button: "OK")
                        self.present(alert, animated: true, completion: nil)
                }
                }
            }
        })
    }
    
    // Adding the catch to the user.
    func addCatch(imageID: String){
        guard let id = catchID else {return}
        db.collection("users").document(userID!).updateData(
            [
                "catches": FieldValue.arrayUnion([id])
            ]
        ) { (error) in
            if let err = error {
                let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
            } else {
                self.addOfficialCatch(imageID: imageID)
            }
        }
    }
    
    // Adding all catch data to FireStore
    func addOfficialCatch(imageID: String){
        
        newCatch = Catch(_id: catchID!, _aID: aID, _userName: userName!, _place: nil, _userID: userID!, _metric: metricTF.text!, _fish: fishTF.text!, _image: catchIV.image!, _imageID: imageID, _tID: nil, _lat: nil, _long: nil)
        
        db.collection("official").document(catchID!).setData(
            [
                "aID": aID,
                "imageID": imageID,
                "userID": userID!,
                "userName": userName!,
                "metric": metricTF.text!,
                "fish": fishTF.text!
            ]
        
        ) { (error) in
            if let err = error {
                let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "toLeaderboard", sender: self)
            }
        }
    }
    
    func uploadImage(imageID: String, image: UIImage){
        guard let storageRef = storage?.reference().child("official/\(imageID).jpg") else {return}
        
        // Local file you want to upload
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {return}
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload file and metadata
        let uploadTask = storageRef.putData(imageData, metadata: metadata)
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            
            print(percentComplete.description)
        }
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

extension AddOfficialCatchVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Getting the image from the picker.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let edited = info[.editedImage] as? UIImage {
            catchIV.image = edited
        } else if let original = info[.originalImage] as? UIImage {
            catchIV.image = original
        } else {
            // TODO: Present the user with an Alert
            print("No image selected.")
        }
        dismiss(animated: true, completion: nil)
    }
}


