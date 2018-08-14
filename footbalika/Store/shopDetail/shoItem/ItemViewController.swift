//
//  ItemViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/14/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var mainView: DesignableView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerTitleForeGround: UILabel!
    @IBOutlet weak var shinyImage: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var doneOutlet: RoundButton!
    @IBOutlet weak var acceptButtonLabel: UILabel!
    @IBOutlet weak var acceptButtonLabelForeGround: UILabel!
    
    var alphaTimer : Timer!
    var TitleItem = String()
    var ImageItem = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPlay().playBuyItem()
        let dataDecoded:NSData = NSData(base64Encoded: ImageItem, options: NSData.Base64DecodingOptions(rawValue: 0))!
        itemImage.image = UIImage(data: dataDecoded as Data)
        
        if UIDevice().userInterfaceIdiom == .phone {
          headerTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(TitleItem)", strokeWidth: -6.0)
            headerTitleForeGround.font = fonts().iPhonefonts
            acceptButtonLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "تأیید", strokeWidth: -6.0)
            acceptButtonLabelForeGround.font = fonts().iPhonefonts
        } else {
            
           headerTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(TitleItem)", strokeWidth: -6.0)
            headerTitleForeGround.font = fonts().iPadfonts
            acceptButtonLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "تأیید", strokeWidth: -6.0)
            acceptButtonLabelForeGround.font = fonts().iPhonefonts
        }
        
        acceptButtonLabelForeGround.text = "تأیید"
        headerTitleForeGround.text = TitleItem
        
//       mainView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
//       headerImage.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
//       headerTitle.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
//       headerTitleForeGround.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
//       shinyImage.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
//       itemImage.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
//       doneOutlet.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
//
//        UIView.animate(withDuration: 1.0, animations: {
//                self.mainView.transform = CGAffineTransform.identity
//                self.headerImage.transform = CGAffineTransform.identity
//                self.headerTitle.transform = CGAffineTransform.identity
//                self.headerTitleForeGround.transform = CGAffineTransform.identity
//                self.shinyImage.transform = CGAffineTransform.identity
//                self.itemImage.transform = CGAffineTransform.identity
//                self.doneOutlet.transform = CGAffineTransform.identity
//        })
                
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        alphaTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAlpha), userInfo: nil, repeats: true)
    }
    
    @objc func updateAlpha() {
        if shinyImage.alpha != 1.0 {
            UIView.animate(withDuration: 1.0) {
                self.shinyImage.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.shinyImage.alpha = 0.3
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(_ sender: RoundButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
