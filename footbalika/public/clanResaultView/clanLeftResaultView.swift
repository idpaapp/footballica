//
//  clanLeftResaultView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/22/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class clanLeftResaultView: UIView {

    @IBOutlet var contentView: UIView!
    
    
    @IBOutlet weak var clanImage: UIImageView!
    
    @IBOutlet weak var clanResault: UILabel!
    
    @IBOutlet weak var clanName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("clanLeftResaultView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }

}
