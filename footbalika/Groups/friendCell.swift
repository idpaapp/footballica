//
//  friendCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/1/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class friendCell: UITableViewCell {

    @IBOutlet weak var selectFriend: UIButton!
    @IBOutlet weak var friendAvatar: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendLogo: UIImageView!
    @IBOutlet weak var friendCup: UILabel!
    @IBOutlet weak var selectFriendName: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
