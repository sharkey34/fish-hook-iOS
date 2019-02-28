//
//  AwardsVC.swift
//  FishHook
//
//  Created by Eric Sharkey on 2/27/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class AwardsVC: UIViewController {
    @IBOutlet weak var awardName: UITextField!
    @IBOutlet weak var sponsorName: UITextField!
    @IBOutlet weak var fishSpecies: UITextField!
    @IBOutlet weak var prizeCount: UITextField!
    
    var prizes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func StepperChange(_ sender: UIStepper) {
    }
}

extension AwardsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PrizesTableViewCell else {return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)}
        
        cell.prizeNum.text = indexPath.row.description
        cell.prizeName.text = prizes[indexPath.row]
        
        return cell
    }
}
