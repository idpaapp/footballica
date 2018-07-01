//
//  leaderBoardCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/6/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class leaderBoardCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerCup: UILabel!
    @IBOutlet weak var playerCupBackGround: UIView!
    @IBOutlet weak var playerLogo: UIImageView!
    @IBOutlet weak var selectLeaderBoard: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        mainView.layer.cornerRadius = 15
        mainView.layer.shadowRadius = 3.0
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0, height: 1)
        mainView.layer.borderColor = UIColor.init(red: 123/255, green: 145/255, blue: 165/255, alpha: 1.0).cgColor
        mainView.layer.borderWidth = 1.0
        playerCupBackGround.layer.cornerRadius = 15
        self.playerName.adjustsFontSizeToFitWidth = true
        self.playerName.minimumScaleFactor = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
