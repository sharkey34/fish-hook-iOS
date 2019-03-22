//
//  AdminTabViewController.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/22/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class TabVC: UITabBarController {
    
    var currentUser: User?


    override func viewDidLoad() {
        super.viewDidLoad()

        currentUser = UserDefaults.standard.currentUser(forKey: "currentUser")
        // Do any additional setup after loading the view.
        tabBar.unselectedItemTintColor = UIColor.white
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
