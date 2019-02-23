//
//  CreateAccountViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/21/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var signUp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(signUpTapped(sender:)))
        
        signUp.addGestureRecognizer(tap)
    }
    
    
    @objc
    func signUpTapped(sender: UITapGestureRecognizer){
        
        
        // TODO: Create new Firebase user.
        performSegue(withIdentifier: "createToAdmin", sender: self)
    }
}
