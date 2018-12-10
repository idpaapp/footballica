//
//  changeUserNameAndPasswordCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 6/4/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class changeUserNameAndPasswordCell: UITableViewCell {

    @IBOutlet weak var changeUserName: RoundButton!
    
    @IBOutlet weak var changePassword: RoundButton!
    
    @IBOutlet weak var changePasswordTitle: UILabel!
    
    @IBOutlet weak var changePasswordTitleForeGround: UILabel!
    
    @IBOutlet weak var changeUserNameTitle: UILabel!
    
    @IBOutlet weak var changeUserNameTitleForeGround: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        changePasswordTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "تغییر کلمه عبور", strokeWidth: 8.0)
        changePasswordTitleForeGround.font = fonts().iPadfonts25
        changePasswordTitleForeGround.text =  "تغییر کلمه عبور"
        changeUserNameTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "تغییر نام کاربری", strokeWidth: 8.0)
        changeUserNameTitleForeGround.font = fonts().iPadfonts25
        changeUserNameTitleForeGround.text = "تغییر نام کاربری"
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
