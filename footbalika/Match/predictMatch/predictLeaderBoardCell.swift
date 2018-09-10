//
//  predictLeaderBoardCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/21/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class predictLeaderBoardCell: UITableViewCell {
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScore: UILabel!
    
    @IBOutlet weak var selectLeaderBoardUser: RoundButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.number.adjustsFontSizeToFitWidth = true
        self.number.minimumScaleFactor = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
