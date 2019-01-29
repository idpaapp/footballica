//
//  clanRewardsCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/14/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class clanRewardsCell: UITableViewCell {

    @IBOutlet weak var rewardImage: UIImageView!
    
    @IBOutlet weak var rewardTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rewardTitle.setAdjustToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
