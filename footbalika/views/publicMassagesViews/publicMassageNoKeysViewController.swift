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
    @IBOutlet weak var publicMassageFullView: publicMassageFullView!
    @IBOutlet weak var publicMassage: publicMassageView!
    
    
    @IBOutlet weak var publicMassageHeight: NSLayoutConstraint!
    @IBOutlet weak var publicMassageWidth: NSLayoutConstraint!
    
    var massageAspectRatio = String()
    var massageImage = String()
    var publicMassageState = String()
    var massageSubject = String()
    var massageContent = String()
    weak var delegate : publicMassageNoKeysViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.publicMassageState {
        case "PUBLIC_MESSAGE_FULL_NO_KEYS":
            setNO_KEYSOutlets()
            setShowHideViews(hidePublicMassageView: false, hidePublicMassageFullView: true, hidePublicMassage: true)
        case "PUBLIC_MESSAGE_FULL" :
            setMassageFullOutlets()
            setShowHideViews(hidePublicMassageView: true, hidePublicMassageFullView: false, hidePublicMassage: true)
        case "PUBLIC_MESSAGE" :
            setMassagesOutlets()
            setShowHideViews(hidePublicMassageView: true, hidePublicMassageFullView: true, hidePublicMassage: false)
        default:
            dismissing()
        }
    }
    
    @objc func setMassagesOutlets() {
        publicMassage.mainView.closePage.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        publicMassage.okButton.actionButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        publicMassage.topTitle.AttributesOutLine(font: fonts().iPhonefonts18, title: "\(self.massageSubject)", strokeWidth: 5.0)
        publicMassage.topTitleForeGround.font = fonts().iPhonefonts18
        publicMassage.topTitleForeGround.text = "\(self.massageSubject)"
        publicMassage.descriptions.text = "\(self.massageContent)"
    }
    
    
    @objc func setMassageFullOutlets() {
        publicMassageFullView.mainView.closePage.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        publicMassageFullView.massageOkButton.actionButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        self.publicMassageFullView.massageImage.setImageWithKingFisher(url: "\(urls().news)\(massageImage)")
        publicMassageFullView.massageTitle.AttributesOutLine(font: fonts().iPhonefonts18, title: "\(self.massageSubject)", strokeWidth: 5.0)
        publicMassageFullView.massageTitleForeGround.font = fonts().iPhonefonts18
        publicMassageFullView.massageTitleForeGround.text = "\(self.massageSubject)"
        publicMassageFullView.massageTexts.text = "\(self.massageContent)"
    }
    
    @objc func setShowHideViews(hidePublicMassageView : Bool , hidePublicMassageFullView : Bool , hidePublicMassage : Bool) {
        self.publicMassageView.isHidden = hidePublicMassageView
        self.publicMassageFullView.isHidden = hidePublicMassageFullView
        self.publicMassage.isHidden = hidePublicMassage
    }
    
    
    @objc func setNO_KEYSOutlets() {
        if UIDevice().userInterfaceIdiom == .pad {
            self.publicMassageWidth.constant = 500
             publicMassageHeight.constant = 500 * (CGFloat((massageAspectRatio as NSString).floatValue))
            self.publicMassageView.massageOkButtonHeight.constant = 60
            self.publicMassageView.massageOkButtonWidth.constant = 150
        } else {
            if UIScreen.main.nativeBounds.height >= 2436 || UIScreen.main.nativeBounds.height == 1792 {
                self.publicMassageWidth.constant = UIScreen.main.bounds.width * 4/5
                publicMassageHeight.constant = (UIScreen.main.bounds.width * 4/5) * (CGFloat((massageAspectRatio as NSString).floatValue))
                self.publicMassageView.massageOkButtonHeight.constant = 40
                self.publicMassageView.massageOkButtonWidth.constant = 100
                
            } else {
                
            self.publicMassageWidth.constant = UIScreen.main.bounds.width * 4/5
             publicMassageHeight.constant = (UIScreen.main.bounds.width * 4/5) * (CGFloat((massageAspectRatio as NSString).floatValue))
                self.publicMassageView.massageOkButtonHeight.constant = 40
                self.publicMassageView.massageOkButtonWidth.constant = 100

            }
        }
       
        publicMassageView.massageCloseButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        publicMassageView.massageOkButton.actionButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        self.publicMassageView.massageImage.setImageWithKingFisher(url: "\(urls().news)\(massageImage)")
        self.publicMassageView.massageImage.layer.cornerRadius = 10
    }
    
    
    @objc func dismissing() {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.checkRestPublicMassages()
    }

}
