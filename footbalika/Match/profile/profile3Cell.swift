//
//  profile3Cell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/10/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class profile3Cell: UITableViewCell {

    @IBOutlet weak var mainBackGround: UIView!
    @IBOutlet weak var secondBackGround: UIView!
    @IBOutlet weak var maximumWinCount: UITextField!
    @IBOutlet weak var maximumScores: UITextField!
    @IBOutlet weak var thirdProfileTitle: UILabel!
    @IBOutlet weak var thirdProfileTitleForeGround: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainBackGround.layer.cornerRadius = 15
        secondBackGround.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
