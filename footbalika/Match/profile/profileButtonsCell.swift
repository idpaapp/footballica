//
//  profileButtonsCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/11/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class profileButtonsCell: UITableViewCell {

    @IBOutlet weak var playRequest: RoundButton!
    @IBOutlet weak var cancelFriendship: RoundButton!
    @IBOutlet weak var friendshipRequest: RoundButton!
    @IBOutlet weak var completingProfile: RoundButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
