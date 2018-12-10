//
//  matchHelpView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class matchHelpView: UIView {


    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var helpImage: UIImageView!
    
    @IBOutlet weak var helpTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("matchHelpView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
}
