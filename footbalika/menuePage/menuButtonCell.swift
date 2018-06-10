//
//  menuButtonCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class menuButtonCell: UICollectionViewCell {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var imageToTitleConstraint: NSLayoutConstraint!
    
    var rotateTimer : Timer!
    var menuIndex = Int()
    override func awakeFromNib() {
        super.awakeFromNib()
        menuTitle.minimumScaleFactor = 0.5
        menuTitle.adjustsFontSizeToFitWidth = true
        rotateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(rotateAction), userInfo: nil, repeats: true)
    }
    
    var rotatesDirection = 1
    @objc func rotateAction() {
        if menuIndex == 2 {
            if self.isSelected {
                if rotatesDirection == 0 {
                    rotatesDirection = 1
                } else {
                    rotatesDirection = 0
                }
                self.menuImage.rotate360Degrees(duration: 1.0, rotateDirection: rotatesDirection)
            }
        }
    }
    
    override var isSelected: Bool{
        didSet {
            if self.isSelected
            {
                UIView.animate(withDuration: 0.5, animations: {
                    self.menuImage.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    self.backGroundView.backgroundColor = UIColor.init(red: 99/255, green: 118/255, blue: 136/255, alpha: 1.0)
                })
                UIView.animate(withDuration: 5, animations: {
                    if UIDevice().userInterfaceIdiom == .phone  {
                    self.imageToTitleConstraint.constant = 10
                    } else {
                    self.imageToTitleConstraint.constant = 20
                    }
                })
            }
                
            else
            {
                UIView.animate(withDuration: 0.5, animations: {
                    self.menuImage.transform = CGAffineTransform.identity
                    self.backGroundView.backgroundColor = UIColor.init(red: 51/255, green: 67/255, blue: 83/255, alpha: 1.0)
                })
                UIView.animate(withDuration: 5, animations: {
                     if UIDevice().userInterfaceIdiom == .phone  {
                    self.imageToTitleConstraint.constant = 5
                     } else {
                    self.imageToTitleConstraint.constant = 10
                    }
                    //iphone
                })
            }
        }
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil , rotateDirection : Int) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        if rotateDirection == 0 {
            rotateAnimation.toValue = CGFloat(.pi * 2.0)
        } else {
            rotateAnimation.toValue = CGFloat(.pi * -2.0)
        }
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

