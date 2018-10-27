//
//  buyButton.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/5/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class buyButton: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var buyAction: RoundButton!
    
    @IBOutlet weak var priceImage: UIImageView!
    
    @IBOutlet weak var priceAmount: UILabel!
    
    @IBOutlet weak var priceAmountForeGround: UILabel!
    
    @objc func setPriceTitle(title : String , font : UIFont) {
        self.priceAmount.AttributesOutLine(font: font, title: title, strokeWidth: -5.0)
        self.priceAmountForeGround.font = font
        self.priceAmountForeGround.text = title
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
        Bundle.main.loadNibNamed("buyButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
}
