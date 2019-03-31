//
//  CreateAccountViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/21/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateAccountVC: UIViewController {
    @IBOutlet weak var signUp: UILabel!
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var adminSwitch: UISwitch!
    
    var db: Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    subscribeUnsubscribe(bool: true)
     setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    // TODO: Add UITextfield Delegate method didEndEditing to check if entry is currently valid in real-time and display error to user.
    
    func setUp(){
        // Setting up Firestore and addign a tap gesture to the signup button.
        db = Firestore.firestore()
        let tap = UITapGestureRecognizer(target: self, action: #selector(signUpTapped(sender:)))
        signUp.addGestureRecognizer(tap)
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        view.addGestureRecognizer(viewTap)
    }
    
    @objc
    func viewTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    func signUpTapped(sender: UITapGestureRecognizer){
        
        // Validating inputs are not null or all spaces and validating password is of valid length and email is valid.
        guard !first.isNullOrWhitespace(), !last.isNullOrWhitespace(), !email.isNullOrWhitespace(),
            email.isValidEmail(), !password.isNullOrWhitespace(), password.isValidPassword() else {
                
                let alert = Utils.basicAlert(title: "Invalid Entry", message: "One or more entries are invalid. Please fix and try agiain", Button: "OK")
                
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        let emailText = email.text!
        let firstName = first.text!
        let lastName = last.text!
        let passwordText = password.text!
        
        // Firebase Auth to create the user.
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
            
            guard let _ = result, let uid = Auth.auth().currentUser?.uid, error == nil else {
                
                if let err = error {
                    let alert = Utils.basicAlert(title: "Error", message: err.localizedDescription, Button: "OK")
                    self.present(alert,animated: true,completion: nil)
                }
                return
            }
            // Saving Data to Firestore
            self.db!.collection("users").document(uid).setData(
                [
                    "first":firstName,
                    "last": lastName,
                    "email": emailText,
                    "userName": "\(firstName) \(lastName)",
                    "admin": self.adminSwitch.isOn
                ],
                completion: { (error) in if let err = error {
                    
                    // TODO: Change to custom toast or something of the like since this will not display.
                    let alert = Utils.basicAlert(title: "Account creation was unsuccessful", message: err.localizedDescription, Button: "OK")
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // Saving currentUser to UserDefaults
                    let currentUser = User(_profileImage: nil, _imageID: nil,_uid: uid, _admin: self.adminSwitch.isOn, _first: firstName, _last: lastName, _email: emailText, _boat: nil, _captain: nil, _about: nil, _phone: nil, _address: nil, _organization:  nil, _userName: "\(firstName) \(lastName)")
                    UserDefaults.standard.set(currentUser: currentUser, forKey: "currentUser")
                    
                    //TODO: Issue here
                    UserDefaults.standard.set(nil, forKey: "activeTournament")
                    self.navigationController?.isNavigationBarHidden = true
                }
                self.performSegue(withIdentifier: "createToDashboard", sender: self)
            })
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
