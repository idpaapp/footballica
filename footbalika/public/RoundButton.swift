//
//  RoundButton.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/13/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    @objc func buttonDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
    
    @objc func buttonUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
        
    @objc func buttonUpAndDown(_ sender: UIButton) {
        soundPlay().playClick()
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion : { (finish)  in
            UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform.identity
            })
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
    }
    
    @IBInspectable
    open var cornerEdges : CGFloat = 0
    @IBInspectable  var topLeft: Bool = false
    @IBInspectable  var topRight: Bool = false
    @IBInspectable  var bottomLeft: Bool = false
    @IBInspectable  var bottomRight: Bool = false
    @IBInspectable  var cornerEdgesAllow: Bool = true
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        if cornerEdgesAllow == true {
            var options = UIRectCorner()
            if topLeft {
                options =  options.union(.topLeft)
            }
            if topRight {
                options =  options.union(.topRight)
            }
            if bottomLeft {
                options =  options.union(.bottomLeft)
            }
            if bottomRight {
                options =  options.union(.bottomRight)
            }
            
            let path = UIBezierPath(roundedRect:self.bounds,
                                    byRoundingCorners: options ,
                                    cornerRadii: CGSize(width: self.cornerEdges, height: self.cornerEdges))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        self.addTarget(self, action: #selector(buttonUp), for: .touchUpOutside)
        self.addTarget(self, action: #selector(buttonUpAndDown), for: .touchUpInside)
        
    }
    
}
