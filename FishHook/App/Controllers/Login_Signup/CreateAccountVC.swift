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
    
    var db: Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        let tap = UITapGestureRecognizer(target: self, action: #selector(signUpTapped(sender:)))
        signUp.addGestureRecognizer(tap)
    }
    
    
    @objc
    func signUpTapped(sender: UITapGestureRecognizer){
        
       
        guard let first = first.text, let last = last.text, let email = email.text, let password = password.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            guard let _ = result, let uid = Auth.auth().currentUser?.uid, error == nil else {return}
     
            let currentUser = User(_uid: uid, _first: first, _last: last, _email: email)
            
            self.db!.collection("users").document(uid).setData(
                [
                    "first":first,
                    "last": last,
                    "email": email
                ],
                completion: { (error) in if let err = error {
                    let alert = Utils.basicAlert(title: "Account creation was unsuccessful", message: err.localizedDescription, Button: "OK")
                    self.present(alert, animated: true, completion: nil)
                } else {
                    do{
                        try UserDefaults.standard.set(currentUser: currentUser, forKey: "currentUser")
                        self.performSegue(withIdentifier: "createToAdmin", sender: self)
                    } catch {
                        print("Error saving current user to defaults.")
                    }
                }
            })
        }
    }
}
