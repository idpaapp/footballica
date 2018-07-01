//
//  profile4Cell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/10/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class profile4Cell: UITableViewCell {

    @IBOutlet weak var mainBackGround: UIView!
    @IBOutlet weak var secondBackGround: UIView!
    @IBOutlet weak var stadiumImage: UIImageView!
    @IBOutlet weak var fourthProfileTitleForeGround: UILabel!
    @IBOutlet weak var fourthProfileTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainBackGround.layer.cornerRadius = 15
        secondBackGround.layer.cornerRadius = 15
        stadiumImage.layer.cornerRadius = 15
        stadiumImage.layer.borderWidth = 5.0
        stadiumImage.layer.borderColor = UIColor.init(white: 255/255, alpha: 0.3).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
