//
//  loginPageViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 6/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class loginPageViewController: UIViewController {

    @IBOutlet weak var mainLoginView: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainTitleForeGround: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userNameForeGround: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var passwordForeGround: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterGoogle: RoundButton!
    @IBOutlet weak var normalEnter: RoundButton!
    @IBOutlet weak var normalEnterTitle: UILabel!
    @IBOutlet weak var normalEnterForeGround: UILabel!
    @IBOutlet weak var newUser: RoundButton!
    @IBOutlet weak var newUserTitle: UILabel!
    @IBOutlet weak var newUserTitleForeGround: UILabel!
    
    var alertTitle = String()
    var alertBody = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainLoginView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        self.mainTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "ورود به سیستم", strokeWidth: -6.0)
        self.mainTitleForeGround.font = fonts().iPhonefonts
        self.mainTitleForeGround.text = "ورود به سیستم"
        
        self.userName.AttributesOutLine(font: fonts().iPhonefonts, title: "نام کاربری", strokeWidth: -6.0)
        self.userNameForeGround.font = fonts().iPhonefonts
        self.userNameForeGround.text = "نام کاربری"
        
        self.password.AttributesOutLine(font: fonts().iPhonefonts, title: "کلمه عبور", strokeWidth: -6.0)
        self.passwordForeGround.font = fonts().iPhonefonts
        self.passwordForeGround.text = "کلمه عبور"
        
        self.normalEnterTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "ورود", strokeWidth: -6.0)
        self.normalEnterForeGround.font = fonts().iPhonefonts
        self.normalEnterForeGround.text = "ورود"
        
        self.newUserTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "کاربر جدید", strokeWidth: -6.0)
        self.newUserTitleForeGround.font = fonts().iPhonefonts
        self.newUserTitleForeGround.text = "کاربر جدید"
        
        let placeHolderColor = UIColor.init(red: 202/255, green: 202/255, blue: 202/255, alpha: 1.0)
        self.userNameTextField.attributedPlaceholder = NSAttributedString(string: "نام کاربری",attributes: [NSAttributedStringKey.foregroundColor: placeHolderColor])
        
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "کلمه عبور",attributes: [NSAttributedStringKey.foregroundColor: placeHolderColor])
        
        self.normalEnter.addTarget(self, action: #selector(normalEnterAction), for: UIControlEvents.touchUpInside)
        
        self.newUser.addTarget(self, action: #selector(newUserAction), for: UIControlEvents.touchUpInside)
    }
    
    
    @objc func normalEnterAction() {
        
        let texts = self.userNameTextField.text
        let texts2 = self.passwordTextField.text
        if texts?.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&  texts2?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if (texts2?.count)! < 8 {
                self.alertTitle = "اخطار"
                self.alertBody = "کلمه عبور باید بیش از 7 کاراکتر باشد!"
                self.performSegue(withIdentifier: "loginAlert", sender: self)
            } else {
                normalLogin()
            }
            
        } else {
            self.alertTitle = "اخطار"
            self.alertBody = "نام کاربری یا کلمه عبور رو نزدی"
            self.performSegue(withIdentifier: "loginAlert", sender: self)
        }
        
    }
    
    
    @objc func emptyStadium() {
        let stadium = readAndWritetblStadiums()
        stadium.writeToDBtblStadiumTypes(id: 0, title: "empty_std", imagePath: ("\(urls().stadium)\((login.res?.response?.mainInfo?.stadium!)!)"), extendedBase64Image: "")
    }
    
    @objc func normalLogin() {
        
        let texts = self.userNameTextField.text
        let texts2 = self.passwordTextField.text
        PubProc.isSplash = false
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByEmail' , 'email' : '\(texts!)' , 'password':'\(texts2!)' , 'load_stadium':'false'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self, from: data!)
                        
                        DispatchQueue.main.async {
                            PubProc.cV.hideWarning()
                            PubProc.isSplash = true
                        }
                        //                print(data ?? "")
                        print((login.res?.status!)!)
                        if (login.res?.status?.contains("OK"))! {
                            self.dismissing()
                            self.emptyStadium()
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("updateProgress"), object: nil)
                            loadingViewController.userid = (login.res?.response?.mainInfo?.id!)!
                            let userid = "\(loadingViewController.userid)"
                            UserDefaults.standard.set(userid, forKey: "userid")
                            loadShop.init().loadingShop(userid: userid, rest: true, completionHandler: {
                            })
                        } else if (login.res?.status?.contains("PASSWORD_NOT_VALID"))! {
                            self.alertBody = "کلمه ی عبور رو اشتباه زدی!"
                            self.alertTitle = "اخطار"
                            self.performSegue(withIdentifier: "loginAlert", sender: self)
                        } else {
                            self.alertBody = "اشکال در انجام عملیات لطفاً مجدداً سعی نمایید!"
                            self.alertTitle = "خطا"
                            self.performSegue(withIdentifier: "loginAlert", sender: self)
                        }
                        
                        PubProc.wb.hideWaiting()
                    } catch {
                        self.normalLogin()
                        print(error)
                    }
                    
                } else {
                    self.normalLogin()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
    @objc func newUserAction() {
        PubProc.isSplash = false
        let number = 100000 + arc4random_uniform(999999 - 100000 + 1)
        PubProc.HandleDataBase.readJson(wsName: "ws_updtUser", JSONStr: "{'mode':'NewUser' , 'guestName' : 'مهمان_\(number)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self, from: data!)
                        
                        DispatchQueue.main.async {
                            PubProc.cV.hideWarning()
                            PubProc.isSplash = true
                        }
                        //                print(data ?? "")
                        if (login.res?.status?.contains("OK"))! {
                            self.dismissing()
                            self.emptyStadium()
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("updateProgress"), object: nil)
                            loadingViewController.userid = (login.res?.response?.mainInfo?.id!)!
                            let userid = "\(loadingViewController.userid)"
                            UserDefaults.standard.set(userid, forKey: "userid")
                            loadShop.init().loadingShop(userid: userid, rest: true, completionHandler: {
                            })
                        } else {
                            self.alertBody = "اشکال در انجام عملیات لطفاً مجدداً سعی نمایید!"
                            self.alertTitle = "خطا"
                            self.performSegue(withIdentifier: "loginAlert", sender: self)
                        }
                        
                        PubProc.wb.hideWaiting()
                    } catch {
                        print(error)
                    }
                    
                } else {
                    self.newUserAction()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? menuAlertViewController {
            vc.alertTitle = self.alertTitle
            vc.alertBody = self.alertBody
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.mainLoginView.transform = CGAffineTransform.identity
        }
    }

    @objc func dismissing() {
        UIView.animate(withDuration: 0.3 , animations : {
            self.mainLoginView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        } , completion : { (finish) in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
