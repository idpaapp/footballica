//
//  menuAlert2Buttons.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class menuAlert2Buttons: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var wholeViewWidth: NSLayoutConstraint!
    @IBOutlet weak var wholeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topForeGroundLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override public func draw(_ rect: CGRect) {
        self.topView.layer.cornerRadius = 10
        self.mainView.layer.cornerRadius = 10
        self.subView.layer.cornerRadius = 10
        self.mainTitle.minimumScaleFactor = 00.5
        self.mainTitle.adjustsFontSizeToFitWidth = true
        self.isOpaque = false
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
        Bundle.main.loadNibNamed("menuAlert2Buttons", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
    
}
