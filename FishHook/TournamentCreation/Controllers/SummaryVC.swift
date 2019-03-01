//
//  SummaryVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/25/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class SummaryVC: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 13/255, green: 102/255, blue: 163/255, alpha: 1)
        navigationItem.title = TournamentSetup.Summary.rawValue
        
        let button = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitSelected(sender:)))
        navigationItem.rightBarButtonItem = button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelected(sender:)))
    }
    
    @objc func submitSelected(sender: UIBarButtonItem) {
        // TODO: Get all the information from the local database.
        // TODO: Push all data to Firestorea and create the tournament.
    }
    
    @objc func cancelSelected(sender: UIBarButtonItem) {
        // TODO: Dismissing the controller may be all that is needed
        dismiss(animated: true, completion: nil)
    }
}
