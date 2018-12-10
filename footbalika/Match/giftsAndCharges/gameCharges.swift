//
//  gameCharges.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/5/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import UIKit

public class gameCharges : menuView {
    
    public var gameChargesImages = [String]()
    public var gameChargesTitles = [String]()
    public var gameChargesNumbers = [String]()
    public var gameChargesPriceType = [String]()
    public var gameChargesHeight : CGFloat = 445
    public var gameChargesWidth : CGFloat = 310
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isOpaque = false
        
        for i in  0...(loadingViewController.loadGameData?.response?.gameCharge.count)! - 1 {
            gameChargesImages.append((loadingViewController.loadGameData?.response?.gameCharge[i].image_path)!)
            
            gameChargesTitles.append((loadingViewController.loadGameData?.response?.gameCharge[i].title)!)
            
            gameChargesNumbers.append((loadingViewController.loadGameData?.response?.gameCharge[i].price)!)
            
            gameChargesPriceType.append((loadingViewController.loadGameData?.response?.gameCharge[i].price_type)!)
            
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            self.topTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "شارژ بازی", strokeWidth: 8.0)
            self.topTitleForeGround.font = fonts().iPhonefonts
        } else {
            self.topTitle.AttributesOutLine(font: fonts().iPadfonts, title: "شارژ بازی", strokeWidth: 8.0)
            self.topTitleForeGround.font = fonts().iPadfonts
        }
        self.topTitleForeGround.text = "شارژ بازی"
    }
    
}
