//
//  minMaxView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/5/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class minMaxView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var minMaxLabel: UILabel!
    
    @IBOutlet weak var setMax: RoundButton!
    
    @IBOutlet weak var setMin: RoundButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.minMaxLabel.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
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
        Bundle.main.loadNibNamed("minMaxView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }

}
