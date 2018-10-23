//
//  groupMemberCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/1/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class groupMemberCell: UITableViewCell {

    @IBOutlet weak var countNumber: UILabel!
    @IBOutlet weak var memberAvatar: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var memberRole: UILabel!
    @IBOutlet weak var memberCup: UILabel!
    @IBOutlet weak var memberClanCup: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
