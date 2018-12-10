//
//  clanRewardsView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/13/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class clanRewardsView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var userClanView: clanScoreView!
    
    @IBOutlet weak var otherClanView: clanScoreView!
    
    @IBOutlet weak var userClanScore: UILabel!
    
    @IBOutlet weak var otherClanScore: UILabel!
    
    @IBOutlet weak var cupCount: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("clanRewardsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
}
