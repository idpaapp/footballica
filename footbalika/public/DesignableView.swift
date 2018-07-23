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
    
    
    ///////shadow
    @IBInspectable var shadowColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = shadowColor.cgColor
        }
    }
    
    
//    open var shadowColor: UIColor? {
//        get {
//            guard let v = layer.shadowColor else {
//                return nil
//            }
//            
//            return UIColor(cgColor: v)
//        }
//        set(value) {
//            layer.shadowColor = value?.cgColor
//        }
//    }
    
    /// A property that accesses the backing layer's shadowOffset.
    @IBInspectable
    open var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set(value) {
            layer.shadowOffset = value
        }
    }
    
    /// A property that accesses the backing layer's shadowOpacity.
    @IBInspectable
    open var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set(value) {
            layer.shadowOpacity = value
        }
    }
    
    /// A property that accesses the backing layer's shadowRadius.
    @IBInspectable
    open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(value) {
            layer.shadowRadius = value
        }
    }
    
    /// A property that accesses the backing layer's shadowPath.
    @IBInspectable
    open var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set(value) {
            layer.shadowPath = value
        }
    }
        
}
