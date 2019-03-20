//
//  TournamentCreationViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit
import CoreData

class CreateTournamentVC: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Test
        self.preferredDisplayMode = .allVisible
        if let nav = self.viewControllers.last as? UINavigationController {
            nav.topViewController?.navigationItem.leftBarButtonItem = self.displayModeButtonItem
        }
        
        // Hiding the navigationBar
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }
}
