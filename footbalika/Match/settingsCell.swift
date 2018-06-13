//
//  settingsCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/22/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class settingsCell: UITableViewCell {

    @IBOutlet weak var switchBackGround: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingLabelForeGround: UILabel!
    @IBOutlet weak var switchSet: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        switchBackGround.layer.cornerRadius = 16
        switchSet.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        
    }
    
    @objc func switchChanged(_ sender : UISwitch!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.switchSet.isOn {
            if let ThumbImg = UIImage(named: "ic_green_ball") {
                self.switchSet.thumbTintColor = UIColor(patternImage: ThumbImg)
            }
        } else {
            if let ThumbImg = UIImage(named: "ic_red_ball") {
                self.switchSet.thumbTintColor = UIColor(patternImage: ThumbImg)
                }
            }
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
