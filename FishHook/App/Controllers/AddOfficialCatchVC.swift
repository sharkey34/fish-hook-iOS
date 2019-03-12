//
//  AddOfficialCatchVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/11/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddOfficialCatchVC: UIViewController {
    @IBOutlet weak var catchIV: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var metricTF: UITextField!
    @IBOutlet weak var fishTF: UITextField!
    
    var aID: String!
    var imagePicker = UIImagePickerController()
    var catchImage: UIImage?
    var db: Firestore!
    var catchID: String?
    var userID: String?
    var fullName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        imagePicker.delegate = self

    }
    
    // Opening camera when take picture is selected.
    @IBAction func takePicture(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func submit(_ sender: UIButton) {
        guard !metricTF.isNullOrWhitespace(), !fishTF.isNullOrWhitespace(), emailTF.isValidEmail() else {
            let alert = Utils.basicAlert(title: "Invalid Entries", message: "Please make sure the entries are valid and not empty.", Button: "OK")
            present(alert, animated: true, completion: nil)
            return
        }
        
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
                            
                            let first = map["first"] as! String
                            let last = map["last"] as! String
                            self.fullName = "\(first) \(last)"
                            self.addCatch()
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
    func addCatch(){
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
                self.addOfficialCatch()
            }
        }
    }
    
    // Adding all catch data to FireStore
    func addOfficialCatch(){
        
        db.collection("official").document(catchID!).setData(
            [
                "aID": aID,
                "userID": userID!,
                "userName": fullName!,
                "metric": metricTF.text!,
                "fish": fishTF.text!
            ]
        
        ) { (error) in
            if let err = error {
                let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                self.present(alert, animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddOfficialCatchVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Getting the image from the picker.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let original = info[.originalImage] as? UIImage {
            catchImage = original
        } else {
            // TODO: Present the user with an Alert
            print("No image Returned.")
        }
        dismiss(animated: true, completion: nil)
    }
}

