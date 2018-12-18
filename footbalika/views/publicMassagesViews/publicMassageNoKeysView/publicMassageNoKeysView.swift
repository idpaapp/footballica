//
//  publicMassageNoKeysView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class publicMassageNoKeysView: UIView {


    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var massageImage: UIImageView!
    
    @IBOutlet weak var massageCloseButton: RoundButton!
    
    @IBOutlet weak var massageOkButton: actionLargeButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("publicMassageNoKeysView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
}
