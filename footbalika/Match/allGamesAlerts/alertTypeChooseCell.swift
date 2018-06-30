//
//  alertTypeChooseCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/9/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class alertTypeChooseCell: UITableViewCell {

    @IBOutlet weak var mainBackGround: UIView!
    
    @IBOutlet weak var user: UIButton!
    
    @IBOutlet weak var userAvatar: UIImageView!
    
    @IBOutlet weak var alertTitle: UILabel!
    
    @IBOutlet weak var alertBody: UILabel!
    
    @IBOutlet weak var alertDate: UILabel!
    
    @IBOutlet weak var accept: RoundButton!
    
    @IBOutlet weak var cancel: RoundButton!
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainBackGround.layer.cornerRadius = 15
        self.mainBackGround.layer.borderColor = UIColor.init(red: 99/255, green: 106/255, blue: 124/255, alpha: 1.0).cgColor
        self.mainBackGround.layer.borderWidth = 1.0
        self.mainBackGround.layer.shadowColor = UIColor.black.cgColor
        self.mainBackGround.layer.shadowRadius = 2.0
        self.mainBackGround.layer.shadowOpacity = 0.5
        self.mainBackGround.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.alertDate.minimumScaleFactor = 0.5
        self.alertDate.adjustsFontSizeToFitWidth = true
        self.alertTitle.adjustsFontSizeToFitWidth = true
        self.alertTitle.minimumScaleFactor = 0.5
        self.alertBody.adjustsFontSizeToFitWidth = true
        self.alertBody.minimumScaleFactor = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
