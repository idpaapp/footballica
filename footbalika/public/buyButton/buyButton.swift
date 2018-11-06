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
    
    @IBOutlet weak var freeTitle: UILabel!
    
    @IBOutlet weak var freeTitleForeGround: UILabel!
    
    @IBOutlet weak var priceStackView: UIStackView!
    
    @objc func setPriceTitle(title : String , font : UIFont) {
        self.priceAmount.AttributesOutLine(font: font, title: title, strokeWidth: -5.0)
        self.priceAmountForeGround.font = font
        self.priceAmountForeGround.text = title
        self.freeTitle.AttributesOutLine(font: font, title: title, strokeWidth: -5.0)
        self.freeTitleForeGround.font = font
        self.freeTitleForeGround.text = title
    }
    
    @objc func setPriceImage(priceImage : UIImage) {
        self.priceImage.image = priceImage
    }
    
    @objc func handleTitle(isFree : Bool) {
        if isFree {
           setHideOrShows(firstGroup: true, secondGroup: false)
        } else {
            setHideOrShows(firstGroup: false, secondGroup: true)
        }
    }
    
    @objc func setHideOrShows(firstGroup : Bool , secondGroup : Bool) {
        self.priceStackView.isHidden = firstGroup
        self.priceAmountForeGround.isHidden = firstGroup
        self.freeTitle.isHidden = secondGroup
        self.freeTitleForeGround.isHidden = secondGroup
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
