//
//  gameChargeTimerBox.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 10/3/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class gameChargeTimerBox: UIView {


    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var timerTitle: UILabel!
    
    @IBOutlet weak var timerTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.timerTitle.text = "باقی مانده از بازی بی نهایت"
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
        Bundle.main.loadNibNamed("gameChargeTimerBox", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
}
