//
//  menuView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/4/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

public class menuView: UIView {

    @IBOutlet weak var topTitleForeGround: UILabel!
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var closeButton: RoundButton!
    @IBOutlet weak var dismissBack: UIButton!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var menuWidth: NSLayoutConstraint!
    
    override public func draw(_ rect: CGRect) {
        self.topView.layer.cornerRadius = 15
        self.mainView.layer.cornerRadius = 15
        self.subView.layer.cornerRadius = 15
        self.menuTableView.layer.cornerRadius = 15
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
        Bundle.main.loadNibNamed("menuView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
    
}
