//
//  gamesCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class gamesCell: UITableViewCell {

    @IBOutlet weak var playersView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var mainTopView: UIView!
    
    @IBOutlet weak var subMainTopView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var turnLabel: UILabel!
    
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var player1Level: UILabel!
    
    @IBOutlet weak var player1Name: UILabel!
    
    @IBOutlet weak var player1Cup: UILabel!
    
    @IBOutlet weak var player2Level: UILabel!
    
    @IBOutlet weak var player2Name: UILabel!
    
    @IBOutlet weak var player2Cup: UILabel!
    
    @IBOutlet weak var player1Select: UIButton!
    
    @IBOutlet weak var player2Select: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainView.layer.cornerRadius = 10
        self.mainView.layer.shadowColor = UIColor.black.cgColor
        self.mainView.layer.shadowRadius = 5.0
        self.mainView.layer.shadowOpacity = 0.5
        self.mainView.layer.shadowOffset = CGSize.init(width: 0, height: 5.0)
        self.mainTopView.layer.cornerRadius = 10
        self.subMainTopView.layer.cornerRadius = 10
        self.timeLabel.minimumScaleFactor = 0.5
        self.timeLabel.adjustsFontSizeToFitWidth = true
        self.turnLabel.minimumScaleFactor = 0.5
        self.turnLabel.adjustsFontSizeToFitWidth = true
        self.playersView.layer.cornerRadius = 10
        self.player1Name.adjustsFontSizeToFitWidth = true
        self.player2Name.adjustsFontSizeToFitWidth = true
        self.player1Name.minimumScaleFactor = 0.5
        self.player2Name.minimumScaleFactor = 0.5
        self.turnLabel.adjustsFontSizeToFitWidth = true
        self.turnLabel.minimumScaleFactor = 0.5
        turnLabel.font = fonts().iPhonefonts
        timeLabel.font = fonts().iPhonefonts
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
