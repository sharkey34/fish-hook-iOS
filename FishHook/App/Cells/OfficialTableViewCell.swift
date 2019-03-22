//
//  OfficialTableViewCell.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/11/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class OfficialTableViewCell: UITableViewCell {
    @IBOutlet weak var catchIV: UIImageView!
    @IBOutlet weak var metricLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var fishLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
