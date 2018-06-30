//
//  profile1Cell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/9/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class profile1Cell: UITableViewCell {

    @IBOutlet weak var firstProfileTitleForeGround: UILabel!
    
    @IBOutlet weak var firstProfileTitle: UILabel!
    
    @IBOutlet weak var mainBackGround: UIView!
    
    @IBOutlet weak var secondBackGround: UIView!
    
    @IBOutlet weak var profileAvatar: UIImageView!
    
    @IBOutlet weak var profileLevel: UILabel!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileId: UILabel!
    
    @IBOutlet weak var profileCup: UILabel!
    
    @IBOutlet weak var profileLogo: UIImageView!
        
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
