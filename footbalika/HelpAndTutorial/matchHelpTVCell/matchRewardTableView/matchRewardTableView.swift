//
//  matchRewardTableView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class matchRewardTableView: UIView {


    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var matchTitle: UILabel!
    
    @IBOutlet weak var matchTitleForeGround: UILabel!
    
    @IBOutlet weak var viewCoin: matchHelpView!
    
    @IBOutlet weak var viewMoney: matchHelpView!
    
    @IBOutlet weak var viewCup: matchHelpView!
    
    @IBOutlet weak var viewLevel: matchHelpView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("matchRewardTableView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
}
