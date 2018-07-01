//
//  profile2Cell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/10/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class profile2Cell: UITableViewCell {

    @IBOutlet weak var mainBackGround: UIView!
    
    @IBOutlet weak var secondBackGround: UIView!
    
    @IBOutlet weak var secondProfileTitle: UILabel!
    
    @IBOutlet weak var secondProfileTitleForeGround: UILabel!
    
    @IBOutlet weak var winCount: UITextField!
    
    @IBOutlet weak var cleanSheetCount: UITextField!
    
    @IBOutlet weak var loseCount: UITextField!
    
    @IBOutlet weak var mostScores: UITextField!
    
    @IBOutlet weak var drawCount: UITextField!
    
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
