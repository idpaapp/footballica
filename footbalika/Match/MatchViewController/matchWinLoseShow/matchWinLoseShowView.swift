//
//  matchWinLoseShowView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/25/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class matchWinLoseShowView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var mainWindow: windows!
    
    @IBOutlet weak var winLoseTable: matchHelpTVCell!
    
    @IBOutlet weak var okButton: actionLargeButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        Bundle.main.loadNibNamed("matchWinLoseShowView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
    }

}
