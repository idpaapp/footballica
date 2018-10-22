//
//  topNewsCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/30/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class topNewsCell: UITableViewCell {

    @IBOutlet weak var topNewsTitle: UILabel!
    
    @IBOutlet weak var topNewsClanCup: UILabel!
    
    @IBOutlet weak var topNewsTime: UILabel!
    
    @IBOutlet weak var topNewsView: DesignableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
