//
//  menuCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/4/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class menuCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuLeftView: UIView!
    @IBOutlet weak var menuLeftImage: UIImageView!
    @IBOutlet weak var menuLeftLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var selectMenu: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 15
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor.init(red: 128/255, green: 150/255, blue: 171/255, alpha: 1.0).cgColor
        menuLeftView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
