//
//  menuAlert2ButtonsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

protocol DA2Delegate{
    func dismissingMA2()
}

class menuAlert2ButtonsViewController: UIViewController , DA2Delegate {
    
    
    let showAlert = menuAlert2Buttons()
    var alertTitle = String()
    var alertBody = String()
    var alertAcceptLabel = String()
    var state = String()
    var jsonStr = String()
    var alertState = String()
    var matchId = String()
    var delegate: DismissDelegate?
    var userid = String()
    weak var gameChargeDelegate : GameChargeDelegate?
    
    @objc func dismissingMA2() {
         self.dismissing()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func changingUserPassNotification() {
            self.dismissing()
    }

        override func viewDidLoad() {
            super.viewDidLoad()

            let nc = NotificationCenter.default
            nc.addObserver(self, selector: #selector(changingUserPassNotification), name: Notification.Name("changingUserPassNotification"), object: nil)
            
            self.showAlert.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            UIApplication.shared.keyWindow!.addSubview(self.showAlert)
            UIApplication.shared.keyWindow!.bringSubview(toFront: self.showAlert)
            self.view.bringSubview(toFront: self.showAlert)
            if UIDevice().userInterfaceIdiom == .phone {
                self.showAlert.wholeViewHeight.constant = 202
                self.showAlert.wholeViewWidth.constant = 240
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
            
            self.showAlert.closeButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
            self.showAlert.cancelButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
            self.showAlert.acceptButton.addTarget(self, action: #selector(accepting), for: UIControlEvents.touchUpInside)
            self.showAlert.isOpaque = false
            if UIDevice().userInterfaceIdiom == .phone {
                self.showAlert.topLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(self.alertTitle)", strokeWidth: 8.0)
                self.showAlert.topForeGroundLabel.text = "\(self.alertTitle)"
                self.showAlert.topForeGroundLabel.font = fonts().iPhonefonts
                self.showAlert.mainTitle.font = UIFont(name: "DPA_Game", size: 13)!
                self.showAlert.mainTitle.text = "\(self.alertBody)"

            } else {
                self.showAlert.topLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(self.alertTitle)", strokeWidth: 8.0)
                self.showAlert.topForeGroundLabel.text = "\(self.alertTitle)"
                self.showAlert.topForeGroundLabel.font = fonts().iPhonefonts
                self.showAlert.mainTitle.font = UIFont(name: "DPA_Game", size: 13)!
                self.showAlert.mainTitle.text = "\(self.alertBody)"
            }
            
            
        }
    
    
    var predictionResponse : Response? = nil
    var ResponseFriendlyMatch = String()
    struct Response : Decodable {
        let status : String?
    }
    
    
    @objc func accepting() {
        switch state {
        case "prediction":
                    PubProc.HandleDataBase.readJson(wsName: "ws_handlePredictions", JSONStr: jsonStr) { data, error in
                        DispatchQueue.main.async {
            
            
                            if data != nil {
            
                                //                print(data ?? "")
                                
                                DispatchQueue.main.async {
                                    PubProc.cV.hideWarning()
                                }
                                do {
                                    
                                    self.predictionResponse = try JSONDecoder().decode(Response.self , from : data!)

                                    print((self.predictionResponse?.status!)!)
                                    if ((self.predictionResponse?.status!)!) == "OK" {
                                        PubProc.wb.hideWaiting()
                                        self.dismissing()
                                        NotificationCenter.default.post(name: Notification.Name("refreshPrediction"), object: nil, userInfo: nil)
                                    } else {
                                        print("this has finished!")
                                        self.performSegue(withIdentifier: "notMore", sender: self)
                                    }
            
                                } catch {
                                    self.accepting()
                                    print(error)
                                }
                            } else {
                                self.accepting()
                                print("Error Connection")
                                print(error as Any)
                                // handle error
                            }
                        }
                    }.resume()
            
        case "surrender" :
            self.dismissing()
            delegate?.dismissAndSurrender(id : self.matchId )
//            startMatchViewController().surrenderring(match_id : self.matchId)
        case "friendlyMatch" :
            PubProc.HandleDataBase.readJson(wsName: "ws_handleFriends", JSONStr: "\(jsonStr)") { data, error in
                DispatchQueue.main.async {
                    
                    if data != nil {
                        DispatchQueue.main.async {
                            PubProc.cV.hideWarning()
                        }
                        self.ResponseFriendlyMatch = ((String(data: data!, encoding: String.Encoding.utf8) as String?)!)
                        //                print(data ?? "")
                        
                        if self.ResponseFriendlyMatch.contains("OK") {
                            self.alertBody = "درخواست مسابقه با موفقیت انجام شد!"
                            self.alertTitle = "فوتبالیکا"
                            self.alertState = "friendlyMatch"
                            self.performSegue(withIdentifier: "notMore", sender: self)
                        } else {
                            self.alertBody = "به دلایلی انجام این کار امکان پذیر نمی باشد لطفاً مجدد سعی کنید"
                            self.alertTitle = "فوتبالیکا"
                            self.performSegue(withIdentifier: "notMore", sender: self)
                        }
                        
                        PubProc.wb.hideWaiting()
                    } else {
                        self.accepting()
                        print("Error Connection")
                        print(error as Any)
                        // handle error
                    }
                }
                }.resume()
            
            
        case "cancelFrindShip" :
            
//            print("cancel Frindship")
            
            PubProc.HandleDataBase.readJson(wsName: "ws_handleFriends", JSONStr: "\(jsonStr)") { data, error in
                DispatchQueue.main.async {
                    
                    if data != nil {
                        DispatchQueue.main.async {
                            PubProc.cV.hideWarning()
                        }
                        
                        self.ResponseFriendlyMatch = ((String(data: data!, encoding: String.Encoding.utf8) as String?)!)
                        print(self.jsonStr)
                        print(self.ResponseFriendlyMatch)
                        //                print(data ?? "")
                        
                        if self.ResponseFriendlyMatch.contains("OK") {
                            
                            let pageIndexDict:[String: String] = ["userID": self.userid]
                            NotificationCenter.default.post(name: Notification.Name("refreshUsersAfterCancelling"), object: nil, userInfo: pageIndexDict)
                            self.dismissing()
                            
                        } else {
                            self.alertBody = "به دلایلی انجام این کار امکان پذیر نمی باشد لطفاً مجدد سعی کنید"
                            self.alertTitle = "فوتبالیکا"
                            self.performSegue(withIdentifier: "notMore", sender: self)
                        }
                        
                        PubProc.wb.hideWaiting()
                    } else {
                        self.accepting()
                        print("Error Connection")
                        print(error as Any)
                        // handle error
                    }
                }
                }.resume()
            
            
        case "requestFriendShip" :
            
            PubProc.HandleDataBase.readJson(wsName: "ws_handleFriends", JSONStr: "\(jsonStr)") { data, error in
                DispatchQueue.main.async {
                    
                    if data != nil {
                        DispatchQueue.main.async {
                            PubProc.cV.hideWarning()
                        }
                        
                        self.ResponseFriendlyMatch = ((String(data: data!, encoding: String.Encoding.utf8) as String?)!)
                        
//                        print(self.jsonStr)
//                        print(self.ResponseFriendlyMatch)
                        //                print(data ?? "")
                        print(self.ResponseFriendlyMatch)
                        
                        if self.ResponseFriendlyMatch.contains("OK") {
                            
                            let pageIndexDict:[String: String] = ["userID": self.userid]
                            NotificationCenter.default.post(name: Notification.Name("refreshUsersAfterCancelling"), object: nil, userInfo: pageIndexDict)
                            self.dismissing()
                        } else if self.ResponseFriendlyMatch.contains("Request_sent") {
                            self.alertBody = "شما قبلاً درخواست دوستی ارسال کرده اید!"
                            self.alertTitle = "فوتبالیکا"
                            self.performSegue(withIdentifier: "notMore", sender: self)
                        } else {
                            self.alertBody = "به دلایلی انجام این کار امکان پذیر نمی باشد لطفاً مجدد سعی کنید"
                            self.alertTitle = "فوتبالیکا"
                            self.performSegue(withIdentifier: "notMore", sender: self)
                        }
                        
                        PubProc.wb.hideWaiting()
                    } else {
                        self.accepting()
                        print("Error Connection")
                        print(error as Any)
                        // handle error
                    }
                }
                }.resume()
            
        case "changePassword" :
            PubProc.HandleDataBase.readJson(wsName: "ws_updtUser", JSONStr: "\(jsonStr)") { data, error in
                DispatchQueue.main.async {
                    
                    if data != nil {
                        
                        do {
                            
                            login.res? = try JSONDecoder().decode(loginStructure.Response.self, from: data!)
                            
                            DispatchQueue.main.async {
                                PubProc.cV.hideWarning()
                            }
                            //                print(data ?? "")
                            
                            print((login.res?.status!)!)
                            if (login.res?.status?.contains("OK"))! {
                                self.alertState = "userPassChange"
                                self.alertBody = "کلمه عبور با موفقیت تغییر کرد"
                                self.alertTitle = "فوتبالیکا"
                                self.performSegue(withIdentifier: "notMore", sender: self)
                            } else if (login.res?.status?.contains("OLD_PASSWORD_NOT_VALID"))! {
                                self.alertState = ""
                                self.alertBody = "کلمه ی عبور فعلی اشتباه است!"
                                self.alertTitle = "خطا"
                                 self.performSegue(withIdentifier: "notMore", sender: self)
                            } else {
                                self.alertState = ""
                                self.alertBody = "اشکال در انجام عملیات لطفاً مجدداً سعی نمایید!"
                                self.alertTitle = "خطا"
                                self.performSegue(withIdentifier: "notMore", sender: self)
                            }
                            
                             PubProc.wb.hideWaiting()
                        } catch {
                                print(error)
                            }
                        
                    } else {
                        self.accepting()
                        print("Error Connection")
                        print(error as Any)
                        // handle error
                    }
                }
                }.resume()
            
        case "changeUserName" :
            PubProc.HandleDataBase.readJson(wsName: "ws_updtUser", JSONStr: "\(jsonStr)") { data, error in
                DispatchQueue.main.async {
                    
                    if data != nil {
                        DispatchQueue.main.async {
                            PubProc.cV.hideWarning()
                        }
                        self.ResponseFriendlyMatch = ((String(data: data!, encoding: String.Encoding.utf8) as String?)!)
                        //                print(data ?? "")
                        
                        if self.ResponseFriendlyMatch.contains("OK") {
                            self.alertState = "userPassChange"
                            self.alertBody = "نام کاربری با موفقیت تغییر کرد"
                            self.alertTitle = "فوتبالیکا"
                            self.performSegue(withIdentifier: "notMore", sender: self)
                            PubProc.wb.hideWaiting()
                        } else {
                            self.alertState = ""
                            self.alertBody = "اشکال در عملیات لطفاً مجدداً سعی نمایید"
                            self.alertTitle = "فوتبالیکا"
                            self.performSegue(withIdentifier: "notMore", sender: self)
                            PubProc.wb.hideWaiting()
                        }
                        
                        
                    } else {
                        self.accepting()
                        print("Error Connection")
                        print(error as Any)
                        // handle error
                    }
                }
                }.resume()
            
        case "signUp" :
            PubProc.HandleDataBase.readJson(wsName: "ws_updtUser", JSONStr: "\(jsonStr)") { data, error in
                DispatchQueue.main.async {
                    
                    if data != nil {
                        
                        do {
                            
                            login.res? = try JSONDecoder().decode(loginStructure.Response.self, from: data!)
                            
                            DispatchQueue.main.async {
                                PubProc.cV.hideWarning()
                            }
                            //                print(data ?? "")
                            
                            
                            print((login.res?.status!)!)
                            if (login.res?.status?.contains("OK"))! {
                                self.alertState = "userPassChange"
                                self.alertBody = "ثبت نام با موفقیت انجام شد!"
                                self.alertTitle = "فوتبالیکا"
                                self.alertAcceptLabel = "تأیید"
                                self.performSegue(withIdentifier: "notMore", sender: self)
                            } else if (login.res?.status?.contains("USERNAME_NOT_VALID"))! {
                                self.state = "signUpError"
                                self.alertBody = "نام کاربری تکراری است!"
                                self.alertTitle = "خطا"
                                self.alertAcceptLabel = "تأیید"
                                self.performSegue(withIdentifier: "notMore", sender: self)
                            } else {
                                self.state = "signUpError"
                                self.alertBody = "اشکال در انجام عملیات لطفاً مجدداً سعی نمایید!"
                                self.alertTitle = "خطا"
                                self.alertAcceptLabel = "تأیید"
                                self.performSegue(withIdentifier: "notMore", sender: self)
                            }
                            
                            PubProc.wb.hideWaiting()
                        } catch {
                            print(error)
                        }
                        
                    } else {
                        self.accepting()
                        print("Error Connection")
                        print(error as Any)
                        // handle error
                    }
                }
                }.resume()
            
        case "outOfGameCharge" :
            self.dismiss(animated: true, completion: nil)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            DispatchQueue.main.async {
                self.dismissing()
                self.gameChargeDelegate?.openGameChargePage()
            }
            
        case "clanInviteFriend" :
            PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "\(jsonStr)") { data, error in
                DispatchQueue.main.async {
                    
                    if data != nil {
                        
                        
                        let res = String(data: data!, encoding: String.Encoding.utf8)
                        
                        if (res)!.contains("OK") {
                            self.alertState = "inviteToGroup"
                            self.alertBody = "دعوتنامه ارسال گردید"
                            self.alertTitle = "فوتبالیکا"
                            self.performSegue(withIdentifier: "notMore", sender: self)
                        } else {
                            self.alertState = "inviteToGroup"
                            self.alertBody = "اشکال در عملیات لطفاً مجدداً سعی نمایید"
                            self.alertTitle = "خطا"
                            self.performSegue(withIdentifier: "notMore", sender: self)
                        }
                        
                            
                            DispatchQueue.main.async {
                                PubProc.cV.hideWarning()
                                PubProc.wb.hideWaiting()
                            }
                            
                            
                        
                        
                    } else {
                        self.accepting()
                        print("Error Connection")
                        print(error as Any)
                        // handle error
                    }
                }
                }.resume()
        default:
            print("otherStates")
            self.dismissing()
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! menuAlertViewController
        vc.delegate = self
        if state == "friendlyMatch" {
            vc.alertState = self.alertState
            vc.alertBody = self.alertBody
            vc.alertTitle = self.alertTitle
            vc.alertAcceptLabel = "تأیید"
        } else if state == "changePassword" {
//            print(self.ResponseFriendlyMatch)
            vc.alertState = self.alertState
            vc.alertBody = self.alertBody
            vc.alertTitle = self.alertTitle
            vc.alertAcceptLabel = "تأیید"
        } else if state == "changeUserName" {
//            print(self.ResponseFriendlyMatch)
            vc.alertState = "userPassChange"
            vc.alertBody = self.alertBody
            vc.alertTitle = self.alertTitle
            vc.alertAcceptLabel = self.alertAcceptLabel
        } else if state == "signUpError" {
            vc.alertState = "signUpError"
            vc.alertBody = self.alertBody
            vc.alertTitle = self.alertTitle
            vc.alertAcceptLabel = self.alertAcceptLabel
        } else if state == "signUp" {
            vc.alertState = "signUp"
            vc.alertBody = self.alertBody
            vc.alertTitle = self.alertTitle
            vc.alertAcceptLabel = self.alertAcceptLabel
        } else if state == "cancelFrindShip" {
            vc.alertState = "cancelFrindShip"
            vc.alertBody = self.alertBody
            vc.alertTitle = self.alertTitle
            vc.alertAcceptLabel = self.alertAcceptLabel
        } else if state == "requestFriendShip" {
            vc.alertState = "requestFriendShip"
            vc.alertBody = self.alertBody
            vc.alertTitle = self.alertTitle
            vc.alertAcceptLabel = "تأیید"
        } else if state == "clanInviteFriend"{
            vc.alertState = self.alertState
            vc.alertBody = self.alertBody
            vc.alertTitle = self.alertTitle
//        } else if state == "friendlyMatch" {
//            vc.alertState = "friendlyMatch"
//            vc.alertBody = self.alertBody
//            vc.alertTitle = self.alertTitle
//            vc.alertAcceptLabel = "تأیید"
            
        } else {
        vc.alertState = ""
        vc.alertBody = "زمان پیش بینی این بازی تمام شده است"
        vc.alertTitle = "فوتبالیکا"
        vc.alertAcceptLabel = "تأیید"
        }
    }
        
        @objc func dismissing() {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2, animations: {
                self.showAlert.wholeView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.showAlert.wholeView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
//                    self.showAlert.removeFromSuperview()
//                    self.dismiss(animated: true, completion: nil)
                }, completion : { (finish) in
//                    self.showAlert.removeFromSuperview()
//                    self.dismiss(animated: true, completion: nil)
                })
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.view.isUserInteractionEnabled = true
                self.showAlert.removeFromSuperview()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
}
