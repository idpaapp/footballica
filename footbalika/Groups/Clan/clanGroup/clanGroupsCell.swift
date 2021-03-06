//
//  clanGroupsCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/28/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class clanGroupsCell: UITableViewCell {

    @IBOutlet weak var clanImage: UIImageView!
    @IBOutlet weak var clanName: UILabel!
    @IBOutlet weak var clanMembers: UILabel!
    @IBOutlet weak var clanCup: UILabel!
    @IBOutlet weak var cupImage: UIImageView!
    @IBOutlet weak var clanSelect: RoundButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clanSelect.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
