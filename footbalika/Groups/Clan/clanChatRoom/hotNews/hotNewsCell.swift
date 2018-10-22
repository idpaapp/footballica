//
//  hotNewsCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/30/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class hotNewsCell: UITableViewCell {

    @IBOutlet weak var hotNewsTitle: UILabel!
    
    @IBOutlet weak var hotNewsDate: UILabel!
    
    @IBOutlet weak var hotNewsClanCup: UILabel!
    
    @IBOutlet weak var hotNewsView: DesignableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
