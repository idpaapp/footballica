//
//  noFriendCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class noFriendCell: UITableViewCell {

    @IBOutlet weak var noFriendTitle: UILabel!
    @IBOutlet weak var noFriendTitleForeGround: UILabel!
    @IBOutlet weak var noFriendButton: UIButton!
    @IBOutlet weak var noFriendButtonTitle: UILabel!
    @IBOutlet weak var noFriendButtonTitleForeGround: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UIDevice().userInterfaceIdiom == .phone {
            noFriendTitleForeGround.font = fonts().iPhonefonts
            noFriendButtonTitleForeGround.font = fonts().iPhonefonts
        } else {
            noFriendTitleForeGround.font = fonts().iPadfonts
            noFriendButtonTitleForeGround.font = fonts().iPadfonts
        }
        noFriendTitle.adjustsFontSizeToFitWidth = true
        noFriendTitle.minimumScaleFactor = 0.5
        noFriendTitleForeGround.adjustsFontSizeToFitWidth = true
        noFriendTitleForeGround.minimumScaleFactor = 0.5
        noFriendButtonTitle.adjustsFontSizeToFitWidth = true
        noFriendButtonTitle.minimumScaleFactor = 0.5
        noFriendButtonTitleForeGround.adjustsFontSizeToFitWidth = true
        noFriendButtonTitleForeGround.minimumScaleFactor = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
