//
//  showItemViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/8/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class showItemViewController: UIViewController {
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemTitleForeGround: UILabel!
    @IBOutlet weak var itemHeight: NSLayoutConstraint!
    @IBOutlet weak var itemWidth: NSLayoutConstraint!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemSubTitle: UILabel!
    @IBOutlet weak var itemSubTitleForeGround: UILabel!
    @IBOutlet weak var backGroundImageView: DesignableView!
    
    
    var mainTitle = String()
    var mainImage = String()
    var subTitle = ""
    var price = String()
    var myVitrin = Bool()
    var priceType = String()
    var isPackage = false
    
    @IBOutlet weak var itemPriceIcon: UIImageView!
    @IBOutlet weak var itemPriceTitle: UILabel!
    @IBOutlet weak var itemPriceTitleForeGround: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice().userInterfaceIdiom == .phone {
            itemTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(mainTitle)", strokeWidth: 8.0)
            itemSubTitle.AttributesOutLine(font: fonts().large35, title: "\(subTitle)", strokeWidth: 8.0)
            itemTitleForeGround.font = fonts().iPhonefonts
            itemSubTitleForeGround.font = fonts().large35
        } else {
            itemTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(mainTitle)", strokeWidth: 8.0)
            itemSubTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(subTitle)", strokeWidth: 8.0)
            itemTitleForeGround.font = fonts().iPadfonts
            itemSubTitleForeGround.font = fonts().iPadfonts
        }
        
        if subTitle == "" {
            self.itemImage.centerYAnchor.constraint(equalTo: self.backGroundImageView.centerYAnchor).isActive = true
        }
        
        itemSubTitleForeGround.text = "\(subTitle)"
        itemTitleForeGround.text = "\(mainTitle)"
        if !isPackage {
            let dataDecoded:NSData = NSData(base64Encoded: mainImage, options: NSData.Base64DecodingOptions(rawValue: 0))!
            itemImage.image = UIImage(data: dataDecoded as Data)
        } else {
            itemImage.setImageWithKingFisher(url: mainImage)
            self.itemImage.clipsToBounds = true
            self.itemImage.layer.cornerRadius = 10
        }
        
        if myVitrin {
            if priceType != "1" {
            itemPriceIcon.image = UIImage()
            if UIDevice().userInterfaceIdiom == .phone {
                itemPriceTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "استفاده", strokeWidth: 8.0)
                itemPriceTitleForeGround.font = fonts().iPhonefonts
            } else {
                itemPriceTitle.AttributesOutLine(font: fonts().iPadfonts, title: "استفاده", strokeWidth: 8.0)
                itemPriceTitleForeGround.font = fonts().iPadfonts
            }
            itemPriceTitleForeGround.text = "استفاده"
            } else {
              checkPrice()
            }
        } else {
           checkPrice()
        }
    }
    
    
    func checkPrice() {
        itemPriceIcon.image = UIImage()
        var priceItem = String()
        
        switch priceType {
        case "1":
            itemPriceIcon.image = publicImages().emptyImage
            if price.contains("مجانی") {
                priceItem = "مجانی"
            } else {
                if price.contains("تومان") {
                    priceItem = price
                } else {
                    priceItem = "\(price) تومان"
                }
            }
        case "2":
            itemPriceIcon.image = UIImage(named: "ic_coin")
            priceItem = price
        case "3":
            itemPriceIcon.image = UIImage(named: "money")
            priceItem = price
        default :
            itemPriceIcon.image = UIImage()
            if price.contains("مجانی") {
                priceItem = "مجانی"
            } else {
                if price.contains("تومان") {
                    priceItem = price
                } else {
                    priceItem = "\(price) تومان"
                }
            }
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            itemPriceTitle.AttributesOutLine(font: fonts().iPhonefonts, title: priceItem, strokeWidth: 8.0)
            itemPriceTitleForeGround.font = fonts().iPhonefonts
        } else {
            itemPriceTitle.AttributesOutLine(font: fonts().iPadfonts, title: priceItem, strokeWidth: 8.0)
            itemPriceTitleForeGround.font = fonts().iPadfonts
        }
        itemPriceTitleForeGround.text = priceItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func useOrBuyItem(_ sender: RoundButton) {
        if !isPackage {
            if myVitrin {
                NotificationCenter.default.post(name: Notification.Name("buyOrChoose"), object: nil, userInfo: nil)
                dismissing()
            } else {
                if priceType != "1" {
                    NotificationCenter.default.post(name: Notification.Name("buyOrChoose"), object: nil, userInfo: nil)
                    dismissing()
                } else {
                    dismissing()
                    NotificationCenter.default.post(name: Notification.Name("openBuyWebsite"), object: nil, userInfo: nil)
                    //                print("openSafari")
                }
            }
        } else {
            dismissing()
            NotificationCenter.default.post(name: Notification.Name("packageSelected"), object: nil, userInfo: nil)
        }
    }
    
    
    @IBAction func dismissAcrion(_ sender: RoundButton) {
        dismissing()
    }
    
    @objc func dismissing() {
        dismiss(animated: true, completion: nil)
    }
}
