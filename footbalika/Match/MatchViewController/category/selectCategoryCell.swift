//
//  selectCategoryCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/17/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class selectCategoryCell: UITableViewCell {

    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var questionForeGroundTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        questionTitle.adjustsFontSizeToFitWidth = true
        questionTitle.minimumScaleFactor = 0.5
        questionForeGroundTitle.minimumScaleFactor = 0.5
    questionForeGroundTitle.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
