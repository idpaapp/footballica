//
//  giftsAndChargesViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/4/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices


class giftsAndChargesViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , SFSafariViewControllerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let giftMenu = gift()
    var pageState = String()
    let gameChargeMenu = gameCharges()
    
    @objc func addGiftMenu() {
        
        self.giftMenu.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        if UIScreen.main.bounds.height < self.giftMenu.giftHeight {
            self.giftMenu.giftHeight = 475
        } else {
            self.giftMenu.giftHeight = 605
        }
        if (login.res?.response?.mainInfo?.status!)! == "2" {
            self.giftMenu.menuHeight.constant = self.giftMenu.giftHeight - 80
        } else {
        self.giftMenu.menuHeight.constant = self.giftMenu.giftHeight
        }
        
        self.giftMenu.menuWidth.constant = self.giftMenu.giftWidth
        self.giftMenu.center = centerScreen().centerScreens
        self.giftMenu.menuTableView.register(UINib(nibName: "menuCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        UIApplication.shared.keyWindow!.addSubview(self.giftMenu)
        UIApplication.shared.keyWindow!.bringSubview(toFront: self.giftMenu)
        self.view.bringSubview(toFront: self.giftMenu)
        self.giftMenu.closeButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        self.giftMenu.dismissBack.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        self.giftMenu.awakeFromNib()
    }
    
    @objc func addGameChargeMenu() {
        
        self.gameChargeMenu.awakeFromNib()
        self.gameChargeMenu.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.gameChargeMenu.menuWidth.constant = self.gameChargeMenu.gameChargesWidth
        self.gameChargeMenu.menuHeight.constant = self.gameChargeMenu.gameChargesHeight
        self.gameChargeMenu.center = centerScreen().centerScreens
        self.gameChargeMenu.menuTableView.register(UINib(nibName: "menuCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        UIApplication.shared.keyWindow!.addSubview(self.gameChargeMenu)
        UIApplication.shared.keyWindow!.bringSubview(toFront: self.gameChargeMenu)
        self.view.bringSubview(toFront: self.gameChargeMenu)
        
        self.gameChargeMenu.closeButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        self.gameChargeMenu.dismissBack.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        gameChargeCount = self.gameChargeMenu.gameChargesImages.count
    }
    
    @objc func dismissing() {
    self.giftMenu.removeFromSuperview()
    self.gameChargeMenu.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
         if pageState == "gifts" {
        addGiftMenu()
         } else {
        addGameChargeMenu()
        }
    }
    
    var gameChargeCount = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        giftMenu.menuTableView.dataSource = self
        giftMenu.menuTableView.delegate = self
        gameChargeMenu.menuTableView.dataSource = self
        gameChargeMenu.menuTableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageState == "gifts" {
        return self.giftMenu.giftsImages.count
        } else {
        return gameChargeCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if pageState == "gifts" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as!  menuCell
        
        cell.menuImage.image = UIImage(named: "\(self.giftMenu.giftsImages[indexPath.row])")
        cell.menuLeftImage.image = UIImage(named: "ic_coin")
            
        switch indexPath.row {
        case 0:
            cell.menuLeftView.isHidden = true
        default:
            cell.menuLeftView.isHidden = false
        }
            
        cell.menuLeftLabel.text = self.giftMenu.giftsNumbers[indexPath.row]
        cell.menuLabel.text = self.giftMenu.giftsTitles[indexPath.row]
        cell.selectMenu.tag = indexPath.row
        cell.selectMenu.addTarget(self, action: #selector(selectedMenu), for: UIControlEvents.touchUpInside)
        return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as!  menuCell
            
            let url = "\(self.gameChargeMenu.gameChargesImages[indexPath.row])"
            let urls = URL(string : url)
            cell.menuImage.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
            
            switch self.gameChargeMenu.gameChargesPriceType[indexPath.row]{
            case "2":
                cell.menuLeftImage.image = UIImage(named: "ic_coin")
            default :
                cell.menuLeftImage.image = UIImage(named: "money")
            }
        
            cell.menuLeftLabel.text = self.gameChargeMenu.gameChargesNumbers[indexPath.row]
            cell.menuLabel.text = self.gameChargeMenu.gameChargesTitles[indexPath.row]
            cell.selectMenu.tag = indexPath.row
            cell.selectMenu.addTarget(self, action: #selector(selectedMenu), for: UIControlEvents.touchUpInside)
            return cell
            
            
            
        }
    }
    
    var chargeRes : String? = nil;
    var alertTitle = String()
    var alertBody = String()
    var alertAcceptLabel = String()
    
    @objc func chargeGame(id : Int) {
        PubProc.HandleDataBase.readJson(wsName: "ws_setExtraGames", JSONStr: "{'charge_id' : '\(id)' , 'userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    
                        self.chargeRes = String(data: data!, encoding: String.Encoding.utf8) as String?

                    
                    if ((self.chargeRes)!).contains("TRANSACTION_COMPELETE") {
                        self.alertTitle = "فوتبالیکا"
                        self.alertBody = "تراکنش با موفقیت انجام شد!"
                        self.alertAcceptLabel = "تأیید"
                        self.performSegue(withIdentifier: "giftAlert", sender: self)
                    } else {
                        self.alertTitle = "اخطار"
                        self.alertBody = "تراکنش با موفقیت انجام نشد!"
                        self.alertAcceptLabel = "تأیید"
                        self.performSegue(withIdentifier: "giftAlert", sender: self)
                    }
                    
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                            PubProc.cV.hideWarning()
                        }
                        
                    
                } else {
                    self.chargeGame(id : id)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }

    
    @objc func selectedMenu(_ sender : UIButton!) {
        soundPlay().playClick()
        if pageState == "gifts" {
           
             if (login.res?.response?.mainInfo?.status!)! == "2" {
                
                switch sender.tag {
                case 0 :
                    print("giftCode")
                    giftsCode()
                case 1 :
                    print("supportUs")
                    supportingUs()
                case 2 :
                    print("inviteFriends")
                    invitingFriends()
                case 3 :
                    print("googleSignIn")
                    googleSignIn()
                case 4 :
                    print("reportProblem")
                    reportingProblem()
                default :
                    print("suggestions")
                    suggestions()
                }
             } else {
                switch sender.tag {
                case 0 :
                    print("giftCode")
                    giftsCode()
                case 1 :
                    print("supportUs")
                    supportingUs()
                case 2 :
                    print("inviteFriends")
                    invitingFriends()
                case 3 :
                    if (login.res?.response?.mainInfo?.status!)! != "2" {
                    print("signIn")
                    self.isSignUp = true
                    self.isPasswordChange = false
                    self.performSegue(withIdentifier : "signUpGift", sender: self)
                    }
                case 4 :
                    print("googleSignIn")
                    googleSignIn()
                case 5 :
                    print("reportProblem")
                    reportingProblem()
                default :
                    print("suggestions")
                    suggestions()
                }
            }
            
        } else {
        let id = Int((loadingViewController.loadGameData?.response?.gameCharge[sender.tag].id!)!)
        self.chargeGame(id : id!)
        }
    }
    
    @objc func giftsCode() {
        self.isGift = true
        self.performSegue(withIdentifier: "massage", sender: self)
    }
    
    var TitleItem = String()
    var ImageItem = String()
    var isShopItem = Bool()
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.TitleItem = "جایزه حمایت"
        self.ImageItem = "ic_coin"
        self.isShopItem = false
        self.performSegue(withIdentifier: "showGiftReward", sender: self)
    }
    
    
    @objc func invitingFriends() {
        
         let shareText = "دوست خوبم،\n با لینک زیر فوتبالیکا رو نصب کن و موقع ثبت نام کد معرف رو وارد کن تا \((loadingViewController.loadGameData?.response?.giftRewards?.invite_friend!)!) تا سکه رایگان بگیری. \n مایکت \n https://myket.ir/app/com.dpa_me.adelica \n بازار \n https://cafebazaar.ir/app/com.dpa_me.adelica/?l=fa \n سیب اپ \n https://new.sibapp.com/applications/footbalika \n کد معرف: \((login.res?.response?.mainInfo?.ref_id!)!.replacingOccurrences(of: "#", with: ""))"
        
        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        present(vc, animated: true)
    }
    
    @objc func googleSignIn() {
        
    }
    
    @objc func reportingProblem() {
        self.reportTitle = "گزارش مشکل"
        self.isGift = false
        self.performSegue(withIdentifier: "massage", sender: self)
    }

    @objc func suggestions() {
        self.reportTitle = " انتقاد و پیشنهاد"
        self.isGift = false
        self.performSegue(withIdentifier: "massage", sender: self)
    }
    
    struct Response : Decodable {
        let status : String?
    }
    
    var supportRes : Response? = nil
    
    @objc func supportingUs() {
        //        USER_SUPPORTS
        
        
        PubProc.HandleDataBase.readJson(wsName: "ws_updtUser", JSONStr: "{'mode':'USER_SUPPORTS' , 'userid' : '\(loadingViewController.userid)'}") { data, error in
            
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    do {
                        
                        self.supportRes? = try JSONDecoder().decode(Response.self, from: data!)
                        
                        DispatchQueue.main.async {
                            PubProc.cV.hideWarning()
                        }
                        //                print(data ?? "")
                        
                        print((String(data: data!, encoding: String.Encoding.utf8) as String?)!)
                        
                        if ((String(data: data!, encoding: String.Encoding.utf8) as String?)!.contains("USER_SUPPORTS_US")) {
                            
                            let appURL = NSURL(string: "sibapp://")!
                            if UIApplication.shared.canOpenURL(appURL as URL) {
                                if #available(iOS 10.0 , *) {
                                    UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(appURL as URL)
                                }
                                
                            } else {
                                //redirect to safari because the user doesn't have SibApp
                                if let url = URL(string: "https://new.sibapp.com/applications/footbalika") {
                                    let svc = SFSafariViewController(url: url)
                                    self.present(svc, animated: true, completion: nil)
                                    svc.delegate = self
                                }
                            }
                            
                        } else if ((String(data: data!, encoding: String.Encoding.utf8) as String?)!.contains("USER_SUPPORTS_BEFORE")) {
                            self.alertBody = "شما قبلاً از ما حمایت کرده اید!"
                            self.alertTitle = "فوتبالیکا"
                            self.alertAcceptLabel = "تأیید"
                            self.performSegue(withIdentifier: "giftAlert", sender: self)
                        } else {
                            self.alertBody = "اشکال در انجام عملیات لطفاً مجدداً سعی نمایید!"
                            self.alertTitle = "خطا"
                            self.alertAcceptLabel = "تأیید"
                            self.performSegue(withIdentifier: "giftAlert", sender: self)
                        }
                        
                        PubProc.wb.hideWaiting()
                    } catch {
                        print(error)
                    }
                    
                } else {
                    self.supportingUs()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if pageState == "gifts" {
        return 80
        } else {
        return 100
        }
    }
    
    var isSignUp = Bool()
    var isPasswordChange = Bool()
    var reportTitle = String()
    var isGift = Bool()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? menuAlertViewController {
            vc.alertTitle = self.alertTitle
            vc.alertBody = self.alertBody
            vc.alertAcceptLabel = self.alertAcceptLabel
        }
        
        if let vc = segue.destination as? changePassAndUserNameViewController {
            vc.isSignUp = self.isSignUp
            vc.isPasswordChange = self.isPasswordChange
        }
        
        if let vc = segue.destination as? massageViewController {
            vc.massagePageTitle = self.reportTitle
            vc.isGift = self.isGift
        }
        
        if let vc = segue.destination as? ItemViewController {
            vc.TitleItem = self.TitleItem
            vc.ImageItem = self.ImageItem
            vc.isShopItem = self.isShopItem
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
