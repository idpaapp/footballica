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
    
    var mainTitle = String()
    var mainImage = String()
    var subTitle = ""
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice().userInterfaceIdiom == .phone {
            itemTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(mainTitle)", strokeWidth: -5.0)
            itemSubTitle.AttributesOutLine(font: fonts().large35, title: "\(subTitle)", strokeWidth: -5.0)
            itemTitleForeGround.font = fonts().iPhonefonts
            itemSubTitleForeGround.font = fonts().large35
        } else {
           itemTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(mainTitle)", strokeWidth: -5.0)
            itemSubTitle.AttributesOutLine(font: fonts().large35, title: "\(subTitle)", strokeWidth: -5.0)
            itemTitleForeGround.font = fonts().large35
            itemSubTitleForeGround.font = fonts().large35
        }
        itemSubTitleForeGround.text = "\(subTitle)"
        itemTitleForeGround.text = "\(mainTitle)"
        let dataDecoded:NSData = NSData(base64Encoded: mainImage, options: NSData.Base64DecodingOptions(rawValue: 0))!
        itemImage.image = UIImage(data: dataDecoded as Data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissAcrion(_ sender: RoundButton) {
        dismissing()
    }
    
    @objc func dismissing() {
        dismiss(animated: true, completion: nil)
    }
}
