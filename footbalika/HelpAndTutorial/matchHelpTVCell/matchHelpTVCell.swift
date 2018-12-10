//
//  matchHelpTVCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class matchHelpTVCell: UITableViewCell {
    
    @IBOutlet weak var matchTitle: UILabel!
    
    @IBOutlet weak var matchTitleForeGround: UILabel!
    
    @IBOutlet weak var viewCoin: matchHelpView!
    
    @IBOutlet weak var viewMoney: matchHelpView!
    
    @IBOutlet weak var viewCup: matchHelpView!
    
    @IBOutlet weak var viewLevel: matchHelpView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
