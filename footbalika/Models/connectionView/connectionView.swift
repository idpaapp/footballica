//
//  connectionView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/11/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

public class connectionView: UIView {

    @IBOutlet weak var connectionViewConstraint: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override public func draw(_ rect: CGRect) {
        self.mainView.layer.cornerRadius = 10
    }
    
    public func showWarning() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.connectionViewConstraint.constant = 40
        UIApplication.shared.keyWindow!.addSubview(self)
        UIApplication.shared.keyWindow!.bringSubview(toFront: self)
        self.isOpaque = false
        UIView.animate(withDuration: 0.5) {
            self.connectionViewConstraint.constant = 0
        }
    }
    
    public func hideWarning() {
        UIView.animate(withDuration: 0.5, animations: {
            self.connectionViewConstraint.constant = 40
        }, completion: { (finish) in
            self.removeFromSuperview()
        })
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("connectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }

}
