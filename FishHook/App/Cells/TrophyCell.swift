//
//  TrophyCell.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/21/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class TrophyCell: UITableViewCell {
    @IBOutlet weak var trophyIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fishLabel: UILabel!
    @IBOutlet weak var metricLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}