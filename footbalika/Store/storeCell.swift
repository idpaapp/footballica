//
//  storeCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/13/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class storeCell: UICollectionViewCell {
    
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeLabelForeGround: UILabel!
    
    @IBOutlet weak var storeSelect: RoundButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.storeLabel.minimumScaleFactor = 0.5
        self.storeLabel.adjustsFontSizeToFitWidth = true
        self.storeLabelForeGround.minimumScaleFactor = 0.5
    self.storeLabelForeGround.adjustsFontSizeToFitWidth = true
    }
    
}
