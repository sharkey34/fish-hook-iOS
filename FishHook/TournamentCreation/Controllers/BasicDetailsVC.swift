//
//  BasicDetailsVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/24/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class BasicDetailsVC: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var tournamentName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Basic.rawValue
    }
    
    
    @IBAction func addLogoTapped(_ sender: UIButton) {
        
        // TODO: Allow the user to upload a photo from the gallary.
        
    }
}
