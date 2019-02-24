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

class LoginViewController: UIViewController {
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    private var ref: DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // looping through labels and setting tapGesture.
        for label in labels{
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(sender:)))
            label.addGestureRecognizer(tap)
        }
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
            let passwordAlert = Alert.basicAlert(title: "Forgot your Password?", message: "", Button: "Ok")
            self.present(passwordAlert, animated: true, completion: nil)
        case 1:
            // TODO: Properly validate entries.
            guard let emailText = email.text, let passwordText = password.text else {return}
            
            Auth.auth().signIn(withEmail: emailText, password: passwordText) { (result, error) in
                
                guard let _ = result, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                // TODO: Get the current user and save to User Defaults.
                
            }
            
            
        case 2:
            // TODO: Perform Segue to Create Account Controller
            performSegue(withIdentifier: "toCreateAccount", sender: self)
            print("No Account")
        default:
            print("Invalid Login Controller tag")
        }
    }
}
