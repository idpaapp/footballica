//
//  publicMassageFullView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/28/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class publicMassageFullView: UIView {

    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var mainView: windows!
    
    @IBOutlet weak var massageImage: UIImageView!
    
    @IBOutlet weak var massageTitle: UILabel!
    
    @IBOutlet weak var massageTitleForeGround: UILabel!
    
    @IBOutlet weak var massageTexts: UILabel!
    
    
    @IBOutlet weak var massageOkButton: actionLargeButton!
    
    
    override func awakeFromNib() {
        massageOkButton.setTitles(actionTitle: "خب", action1Title: "", action2Title: "", action3Title: "")
        massageOkButton.setButtons(hideAction: false, hideAction1: true, hideAction2: true, hideAction3: true)
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
        Bundle.main.loadNibNamed("publicMassageFullView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }

}
