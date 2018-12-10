//
//  itemReawrdView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/17/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class itemReawrdView: UIView {


    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var shinyImage: UIImageView!
    
    @IBOutlet weak var receiveGift: RoundButton!
    
    @IBOutlet weak var buttonTitle: UILabel!
    
    @IBOutlet weak var buttonTitleForeGround: UILabel!
    
    @IBOutlet weak var headerTitle: UILabel!
    
    
    @IBOutlet weak var headerTitleForeGround: UILabel!
    
    @IBOutlet weak var rewardsTV: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("itemReawrdView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }

}
