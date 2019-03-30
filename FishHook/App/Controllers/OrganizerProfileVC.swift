//
//  OrganizerProfileVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/29/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import FirebaseStorage

class OrganizerProfileVC: UIViewController {
    
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var bannerIV: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var aboutTV: UITextView!
    @IBOutlet weak var orgLabel: UILabel!
    
    var currentUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // Initial setup
    func setUp(){  
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped(sender:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailLabel.text = currentUser.email
        phoneLabel.text = currentUser.phone
        locationLabel.text = currentUser.address
        aboutTV.text = currentUser.about
        orgLabel.text = currentUser.organization
        
        if let image = currentUser.profileImage {
            profileIV.image = image
        } else if let imageID = currentUser.imageID {
            downlodImage(imageID: imageID)
        } else {
            profileIV.image = UIImage(named: "ProfilePlaceholder")
        }
    }
    
    // Downloading Image
    func downlodImage(imageID: String){
        if let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/fish-hook-3ef8d.appspot.com/o/profile%2F\(imageID).jpg?alt=media&token=c29ad4be-23a0-4bce-945a-00d1298bf8d8") {
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    let image = UIImage(data: data)
                    
                    // Setting profile image
                    DispatchQueue.main.async {
                        self.profileIV.image = image
                        self.currentUser.profileImage = image
                    }
                }
            }.resume()
        }
    }
    
    
    @objc
    func editTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toOrganizerEdit", sender: self)
    }
    
    // Sending currentUser to edit Vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOrganizerEdit" {
            if let editVC = segue.destination as? EditProfileVC {
                editVC.currentUser = currentUser
            }
        }
    }
}
