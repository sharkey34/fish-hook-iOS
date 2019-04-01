//
//  LoginViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        subscribeUnsubscribe(bool: true)
    }
    
    // Performing intial setup.
    func setUp(){
        db = Firestore.firestore()
        
        // Setting time to take a Firebase Timestamp instead of a System Date
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        view.addGestureRecognizer(tap)
                
        // looping through labels and setting tapGesture.
        for label in labels{
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(sender:)))
            label.addGestureRecognizer(tap)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc
    func viewTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    func labelTapped(sender: UITapGestureRecognizer) {
        
        guard let tag = sender.view?.tag else {return}
        
        switch tag {
        case 0:
            // TODO: Give the user the ability to create a new password.
            
//            Auth.auth().sendPasswordReset(withEmail: email) { error in
//                // ...
//            }
            let passwordAlert = Utils.basicAlert(title: "Forgot your Password?", message: "", Button: "Ok")
            self.present(passwordAlert, animated: true, completion: nil)
        case 1:
            
            // Properly validating entries.
            guard !email.isNullOrWhitespace(), email.isValidEmail(), !password.isNullOrWhitespace(), password.isValidPassword() else {
                
                let alert = Utils.basicAlert(title: "Invalid Entry", message: "Email and/or password are invalid.", Button: "OK")
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let emailText = email.text!
            let passwordText = password.text!
            
            Auth.auth().signIn(withEmail: emailText, password: passwordText) { (result, error) in
                
                // Alerting the user if there is a Firestore error.
                guard let _ = result, error == nil else {
                    print(error!.localizedDescription)
                    let alert = Utils.basicAlert(title: "Firestore Error", message: error!.localizedDescription, Button: "OK")
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                if let uid = Auth.auth().currentUser?.uid {
                    
                    let ref = self.db.collection("users").document(uid)
                    ref.getDocument(completion: { (document, error) in
                        
                        if let doc = document, document!.exists{
                            // Mapping the data and save the user information to currentUser.
                            if let map = doc.data(){
                                
                                let imageID = map["imageID"] as? String
                                let email = map["email"] as! String
                                let first = map["first"] as! String
                                let last = map["last"] as! String
                                let admin = map["admin"] as! Bool
                                let boat = map["boat"] as? String
                                let captain = map["captain"] as? String
                                let about = map["about"] as? String
                                let phone = map["phone"] as? String
                                let address = map["address"] as? String
                                let userName = map["userName"] as? String
                                let org = map["org"] as? String
            
                                UserDefaults.standard.set(currentUser: User(_profileImage:nil, _imageID: imageID,_uid: uid, _admin: admin, _first: first, _last: last, _email: email, _boat: boat, _captain: captain, _about: about, _phone: phone, _address: address, _organization: org, _userName: userName), forKey: "currentUser")
                                
                            }
                            self.performSegue(withIdentifier: "loginToDashboard", sender: self)
                        }
                    })
                }
            }
        case 2:
            // TODO: Perform Segue to Create Account Controller
            performSegue(withIdentifier: "toCreateAccount", sender: self)
        default:
            print("Invalid Login Controller tag")
        }
    }
    
    @objc func show(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 3
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
