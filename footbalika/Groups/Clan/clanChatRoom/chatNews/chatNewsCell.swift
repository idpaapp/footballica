//
//  chatNewsCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/28/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class chatNewsCell: UITableViewCell {

    @IBOutlet weak var newsBackGround: DesignableView!
    
    @IBOutlet weak var newsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
