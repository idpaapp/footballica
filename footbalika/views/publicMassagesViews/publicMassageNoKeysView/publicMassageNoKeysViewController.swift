//
//  publicMassageNoKeysViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class publicMassageNoKeysViewController: UIViewController {

    @IBOutlet weak var publicMassageView: publicMassageNoKeysView!
    
    @IBOutlet weak var publicMassageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var publicMassageWidth: NSLayoutConstraint!
    
    var massageAspectRatio = String()
    var massageImage = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setOutlets()
    }
    
    
    @objc func setOutlets() {
        if UIDevice().userInterfaceIdiom == .pad {
            self.publicMassageWidth.constant = 500
             publicMassageHeight.constant = 500 / (CGFloat((massageAspectRatio as NSString).floatValue)) 
        } else {
            self.publicMassageHeight.constant = UIScreen.main.bounds.height * 4/5
             publicMassageWidth.constant = (UIScreen.main.bounds.height * 4/5) / (CGFloat((massageAspectRatio as NSString).floatValue))
        }
       
        publicMassageView.massageCloseButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        publicMassageView.massageOkButton.actionButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        publicMassageView.massageOkButton.setTitles(actionTitle: "خب", action1Title: "", action2Title: "", action3Title: "")
        publicMassageView.massageOkButton.setButtons(hideAction: false, hideAction1: true, hideAction2: true, hideAction3: true)
        self.publicMassageView.massageImage.setImageWithKingFisher(url: "\(urls().news)\(massageImage)")
    }
    
    
    @objc func dismissing() {
        self.dismiss(animated: true, completion: nil)
    }

}
