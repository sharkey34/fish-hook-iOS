//
//  LoginViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var labels: [UILabel]!
    
    
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
            // TODO: Possibly display dialog to help user retrieve account information.
            print("Forgot your password?")
        case 1:
            // TODO: Validated entries with firebase.
            print("Login")
        case 2:
            // TODO: Perform Segue to Create Account Controller
            performSegue(withIdentifier: "toCreateAccount", sender: self)
            print("No Account")
        default:
            print("Invalid Login Controller tag")
        }
    }
}
