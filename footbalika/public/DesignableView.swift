//
//  DesignableView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/11/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableView: UIView {
    
        @IBInspectable var borderColor: UIColor = UIColor.white {
            didSet {
                self.layer.borderColor = borderColor.cgColor
            }
        }
        
        @IBInspectable var borderWidth: CGFloat = 2.0 {
            didSet {
                self.layer.borderWidth = borderWidth
            }
        }
        
        @IBInspectable var cornerRadius: CGFloat = 0.0 {
            didSet {
                self.layer.cornerRadius = cornerRadius
            }
        }
        
}
