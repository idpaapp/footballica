//
//  todayCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/21/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class todayCell: UITableViewCell {
    @IBOutlet weak var submitPrediction: RoundButton!
    @IBOutlet weak var submitTitle: UILabel!
    @IBOutlet weak var submitTitleForeGround: UILabel!
    @IBOutlet weak var team1Prediction: UITextField!
    @IBOutlet weak var team2Prediction: UITextField!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var team1Logo: UIImageView!
    @IBOutlet weak var team2Logo: UIImageView!
    @IBOutlet weak var team1Title: UILabel!
    @IBOutlet weak var team2Title: UILabel!
    @IBOutlet weak var team1Resault: UITextField!
    @IBOutlet weak var team2Resault: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.submitTitle.AttributesOutLine(font: fonts().iPhonefonts18, title: "ثبت پیش بینی", strokeWidth: -6.0)
        self.submitTitleForeGround.text = "ثبت پیش بینی"
        self.submitTitleForeGround.font = fonts().iPhonefonts18
        team1Title.adjustsFontSizeToFitWidth = true
        team1Title.minimumScaleFactor = 0.1
        team2Title.adjustsFontSizeToFitWidth = true
        team2Title.minimumScaleFactor = 0.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
