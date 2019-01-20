//
//  menuAlertViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/5/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//
                        
                           
import UIKit

class menuAlertViewController: UIViewController {
    
    weak var delegate3 : menuAlertViewControllerDelegate3!
    var delegate: DA2Delegate?
    let showAlert = menuAlert()
    var alertTitle = String()
    var alertBody = String()
    var alertAcceptLabel = "تأیید"
    var alertState = String()
    weak var delegate2 : menuAlertViewControllerDelegate2!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var matchField : mainMatchFieldViewController!
    var clanDelegate : menuAlertViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showAlert.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        UIApplication.shared.keyWindow!.addSubview(self.showAlert)
        UIApplication.shared.keyWindow!.bringSubview(toFront: self.showAlert)
        self.view.bringSubview(toFront: self.showAlert)
        if UIDevice().userInterfaceIdiom == .phone {
            self.showAlert.wholeViewHeight.constant = 202
            self.showAlert.wholeViewWidth.constant = 280
            //240
        } else {
            self.showAlert.wholeViewHeight.constant = 250
            self.showAlert.wholeViewWidth.constant = 300
        }
        self.showAlert.wholeView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.2, animations: {
            self.showAlert.wholeView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.2, animations: {
                self.showAlert.wholeView.transform = CGAffineTransform.identity
            })
        })
        
        if self.alertState != "forceUpdate" {
            self.showAlert.closeButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        }
        self.showAlert.acceptButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        self.showAlert.isOpaque = false
        if UIDevice().userInterfaceIdiom == .phone {
            self.showAlert.topLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(self.alertTitle)", strokeWidth: 8.0)
            self.showAlert.topForeGroundLabel.text = "\(self.alertTitle)"
            self.showAlert.topForeGroundLabel.font = fonts().iPhonefonts
            self.showAlert.mainTitle.font = UIFont(name: "DPA_Game", size: 20)!
            self.showAlert.mainTitle.text = "\(self.alertBody)"
            self.showAlert.acceptButtonLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(self.alertAcceptLabel)", strokeWidth: 8.0)
            self.showAlert.acceptButtonLabelForeGround.font = fonts().iPhonefonts
            self.showAlert.acceptButtonLabelForeGround.text = "\(self.alertAcceptLabel)"
        } else {
            self.showAlert.topLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(self.alertTitle)", strokeWidth: 8.0)
            self.showAlert.topForeGroundLabel.text = "\(self.alertTitle)"
            self.showAlert.topForeGroundLabel.font = fonts().iPhonefonts
            self.showAlert.mainTitle.font = UIFont(name: "DPA_Game", size: 20)!
            self.showAlert.mainTitle.text = "\(self.alertBody)"
            self.showAlert.acceptButtonLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(self.alertAcceptLabel)", strokeWidth: 8.0)
            self.showAlert.acceptButtonLabelForeGround.font = fonts().iPhonefonts
            self.showAlert.acceptButtonLabelForeGround.text = "\(self.alertAcceptLabel)"
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.isUserInteractionEnabled = true
    }
    @objc func dismissing() {
        if self.alertState != "forceUpdate" {
            UIView.animate(withDuration: 0.2, animations: {
                self.showAlert.wholeView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.showAlert.wholeView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                }, completion : { (finish) in
                    if self.alertState == "inviteToGroup" {
                        //                self.performSegue(withIdentifier: "backToMenu", sender: self)
                        self.showAlert.removeFromSuperview()
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.dismissingMA2()
                    } else {
                        self.showAlert.removeFromSuperview()
                        self.dismiss(animated: true, completion: nil)
                        if self.alertState == "userPassChange"  {
                            let passData : [String:Bool] = ["isPass" : true]
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("changingUserPassNotification"), object: nil , userInfo : passData)
                        } else if self.alertState == "signUp" {
//                            let passData : [String:Bool] = ["isPass" : false]
//                            let nc = NotificationCenter.default
//                            nc.post(name: Notification.Name("changingUserPassNotification"), object: nil , userInfo : passData)
                            
                            self.showAlert.removeFromSuperview()
                            self.delegate3?.dismissAfterGift()
//                            self.navigationController?.popToRootViewController(animated: true)
                        } else if self.alertState == "clanMatch" {
                            self.clanDelegate?.dismissing()
                        } else if self.alertState == "signUpError" {
                            self.delegate?.dismissingMA2()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                //                  self.delegate?.dismissingMA2()
                            })
                        } else if self.alertState == "report" {
                            self.delegate2?.dismissing()
                        } else if self.alertState == "requestFriendShip" {
                            self.delegate?.dismissingMA2()
                        } else if self.alertState == "friendlyMatch" {
                            self.delegate?.dismissingMA2()
                        }
                    }
                })
            })
            
            if self.alertState == "matchField" {
                self.view.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.matchField.dismiss(animated: true, completion: nil)
                    musicPlay().playMenuMusic()
                })
            }
        } else {
            if let requestUrl = NSURL(string: "https://new.sibapp.com/applications/footbalika") {
                UIApplication.shared.openURL(requestUrl as URL)
            }
        }
}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.alertTitle == "فوتبالیکا" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        
        //        if self.alertState == "report" {
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
        //                self.dismiss(animated: true, completion: nil)
        //            })
        //        }
    }
    
    var m = massageViewController()
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if self.alertState == "report" {
            DispatchQueue.main.async {
                self.m.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

                          
