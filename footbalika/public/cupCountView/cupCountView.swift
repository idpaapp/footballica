//
//  cupCountView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/26/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class cupCountView: UIView {


    @IBOutlet var contentView: UIView!
    
    
    @IBOutlet weak var cupImage: UIImageView!
    
    
    @IBOutlet weak var cupCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cupCountLabel.setLabelBackGroundImage(image: publicImages().label_back_dark!)
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
        Bundle.main.loadNibNamed("cupCountView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
    

}
