//
//  AnglerProfileCell.swift
//  FishHook
//
//  Created by Eric Sharkey on 3/26/19.
//  Copyright © 2019 Eric Sharkey. All rights reserved.
//

import UIKit

class AnglerProfileCell: UITableViewCell {
    @IBOutlet weak var catchIV: UIImageView!
    @IBOutlet weak var metricLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var fishLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
