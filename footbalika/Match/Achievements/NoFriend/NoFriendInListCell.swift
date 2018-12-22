//
//  NoFriendInListCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 10/1/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class NoFriendInListCell: UITableViewCell {

    @IBOutlet weak var noFriendTitle: UILabel!
    
    @IBOutlet weak var noFriendTitleForeGround: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
