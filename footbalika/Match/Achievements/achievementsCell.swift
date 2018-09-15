//
//  achievementsCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/13/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class achievementsCell: UITableViewCell {

    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var bg2: UIView!
    @IBOutlet weak var bg3: UIView!
    @IBOutlet weak var progressBarBackGroundView: UIView!
    @IBOutlet weak var progressBarBackGroundView2: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var progressTitle: UILabel!
    @IBOutlet weak var acievementTitle: UILabel!
    @IBOutlet weak var achievementDesc: UILabel!
    @IBOutlet weak var achievementProgress: UIProgressView!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var acievementTitleForeGround: UILabel!
    @IBOutlet weak var progressTitleForeGround: UILabel!
    @IBOutlet weak var receiveGift: RoundButton!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var moneyImage: UIImageView!
    @IBOutlet weak var achievementImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bg1.layer.cornerRadius = 10
        self.bg2.layer.cornerRadius = 10
        self.bg3.layer.cornerRadius = 10
        if UIDevice().userInterfaceIdiom == .phone {
        self.progressBarBackGroundView.layer.cornerRadius = 5
        self.progressBarBackGroundView2.layer.cornerRadius = 5
        } else {
        self.progressBarBackGroundView.layer.cornerRadius = 10
        self.progressBarBackGroundView2.layer.cornerRadius = 10
        }
        self.achievementDesc.adjustsFontSizeToFitWidth = true
        self.achievementDesc.minimumScaleFactor = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
