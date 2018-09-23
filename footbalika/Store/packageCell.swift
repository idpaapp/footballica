//
//  packageCell.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 6/17/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class packageCell: UICollectionViewCell {
    
    @IBOutlet weak var packageButton: RoundButton!
    var bouncingTimer : Timer!
    var index = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if matchViewController.isTutorial {
        bouncingTimer = Timer.scheduledTimer(timeInterval: 1.4, target: self, selector: #selector(bouncingAction), userInfo: nil, repeats: true)
        } else {}
    }
    
    @objc func bouncingAction() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .allowUserInteraction, animations: {
            self.packageButton.transform = .init(scaleX: 0.9, y: 0.9)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.7, delay: 0, options: .allowUserInteraction, animations: {
                self.packageButton.transform = .identity
            }, completion: { (finish) in
                
            })
        })
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
