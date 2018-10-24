//
//  clanDetailCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/1/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class clanDetailCell: UICollectionViewCell {

    @IBOutlet weak var mainView: DesignableView!
    
    @IBOutlet weak var clanDetailImage: UIImageView!
    
    @IBOutlet weak var clanDetailTitle: UILabel!
    
    @IBOutlet weak var clanDetailTitleForeGround: UILabel!
    
    @IBOutlet weak var clanDetailAmount: UILabel!
    
    @IBOutlet weak var clanDetailAmountForeGround: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
