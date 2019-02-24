//
//  CreateAccountViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/21/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var signUp: UILabel!
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(signUpTapped(sender:)))
        
        signUp.addGestureRecognizer(tap)
    }
    
    
    @objc
    func signUpTapped(sender: UITapGestureRecognizer){
        
       
        guard let first = first.text, let last = last.text, let email = email.text, let password = password.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            guard let _ = result, error == nil else {return}
            
            
            // Save to database.
            
            
        }
        
        // TODO: Create new Firebase user.
        performSegue(withIdentifier: "createToAdmin", sender: self)
    }
}
