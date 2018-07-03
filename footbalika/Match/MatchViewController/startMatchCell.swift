//
//  startMatchCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class startMatchCell: UITableViewCell {

    @IBOutlet weak var matchTitle: UILabel!
    
    @IBOutlet weak var matchResult: UILabel!
    
    @IBOutlet weak var br1: UIImageView!
    
    @IBOutlet weak var br2: UIImageView!
    
    @IBOutlet weak var br3: UIImageView!
    
    @IBOutlet weak var br4: UIImageView!
    
    @IBOutlet weak var bl1: UIImageView!
    
    @IBOutlet weak var bl2: UIImageView!
    
    @IBOutlet weak var bl3: UIImageView!
    
    @IBOutlet weak var bl4: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        matchTitle.minimumScaleFactor = 0.5
        matchTitle.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
