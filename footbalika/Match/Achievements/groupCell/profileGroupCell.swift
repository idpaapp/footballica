//
//  profileGroupCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/26/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class profileGroupCell: UITableViewCell {

    @IBOutlet weak var profileGroupCellTitle: UILabel!
    
    @IBOutlet weak var profileGroupCellTitleForeGround: UILabel!
    
    @IBOutlet weak var groupImage: UIImageView!
    
    @IBOutlet weak var cupCountShow: cupCountView!
    
    @IBOutlet weak var showGroupButton: actionLargeButton!
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var memberRoll: UILabel!
    
    @IBOutlet weak var promoteDemoteView: actionLargeButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    @objc func setupView() {
        self.showGroupButton.setButtons(hideAction: true, hideAction1: false, hideAction2: true, hideAction3: true)
        self.showGroupButton.setTitles(actionTitle: "", action1Title: "گروه ", action2Title: "", action3Title: "")
        self.profileGroupCellTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "گروه", strokeWidth: 5.0)
        self.profileGroupCellTitleForeGround.font = fonts().iPhonefonts
        self.profileGroupCellTitleForeGround.text = "گروه"
        self.promoteDemoteView.setButtons(hideAction: true, hideAction1: false, hideAction2: true, hideAction3: false)
        self.promoteDemoteView.setTitles(actionTitle: "", action1Title: "ارتقاء سطح", action2Title: "" , action3Title: "کاهش سطح")
    self.promoteDemoteView.action1.setBackgroundImage(publicImages().accept_btn, for: UIControlState.normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



