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
                    "admin": self.adminSwitch.isOn
                ],
                completion: { (error) in if let err = error {
                    
                    // TODO: Change to custom toast or something of the like since this will not display.
                    let alert = Utils.basicAlert(title: "Account creation was unsuccessful", message: err.localizedDescription, Button: "OK")
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // Saving currentUser to UserDefaults
                    let currentUser = User(_uid: uid, _admin: self.adminSwitch.isOn, _first: firstName, _last: lastName, _email: emailText)
                    UserDefaults.standard.set(currentUser: currentUser, forKey: "currentUser")
                    UserDefaults.standard.set(nil, forKey: "activeTournament")
                    self.performSegue(withIdentifier: "createToDashboard", sender: self)
                }
            })
        }
    }
}
