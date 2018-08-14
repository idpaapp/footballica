//
//  todayCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/21/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class todayCell: UITableViewCell {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var team1Logo: UIImageView!
    @IBOutlet weak var team2Logo: UIImageView!
    @IBOutlet weak var team1Title: UILabel!
    @IBOutlet weak var team2Title: UILabel!
    @IBOutlet weak var team1Resault: UILabel!
    @IBOutlet weak var team2Resault: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
