//
//  waitingBall.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/22/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

public class waitingBall: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var waitingImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override public func draw(_ rect: CGRect) {
        self.waitingImage.layer.cornerRadius = 20
    }
    
    
    public func showWaiting() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        UIApplication.shared.keyWindow!.addSubview(self)
        UIApplication.shared.keyWindow!.bringSubview(toFront: self)
//        self.waitingImage.image = UIImage.gif(name: "progress")
        self.waitingImage.loadGif(name: "progress")
        
        self.isOpaque = false
    }
    
    public func hideWaiting() {
        self.removeFromSuperview()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("waitingBall", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
    
}
