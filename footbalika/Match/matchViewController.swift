//
//  matchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

protocol GameChargeDelegate : class {
    func openGameChargePage()
}

protocol TutorialDelegate {
    func tutorialPage()
}

class matchViewController: UIViewController , GameChargeDelegate , TutorialDelegate {
    
    func openGameChargePage() {
        DispatchQueue.main.async {
            self.openGameChargingPage()
        }
    }
    
    func tutorialPage() {
        self.performSegue(withIdentifier: "showTutorial", sender: self)
    }
    
    
    @IBOutlet weak var wholeMainPageButtons: NSLayoutConstraint!
    @IBOutlet weak var startLabelForeGround: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var friendlyLabel: UILabel!
    @IBOutlet weak var eliminateCupLabel: UILabel!
    @IBOutlet weak var mainCupImage: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var cup: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var xp: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var coin: UILabel!
    @IBOutlet weak var xpProgress: UIProgressView!
    @IBOutlet weak var xpProgressBackGround: UIView!
    @IBOutlet weak var giftOutlet: RoundButton!
    var matchID = String()
    
    @IBAction func addMoney(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        scrollToPage().scrollPageViewController(index: 4)
        scrollToPage().menuButtonChanged(index: 4)
        let pageIndexDict:[String: String] = ["title": "پول"]
        NotificationCenter.default.post(name: Notification.Name("openCoinsOrMoney"), object: nil, userInfo: pageIndexDict)
        self.view.isUserInteractionEnabled = true
    }

    @IBAction func addCoin(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        scrollToPage().scrollPageViewController(index: 4)
        scrollToPage().menuButtonChanged(index: 4)
        let pageIndexDict:[String: String] = ["title": "سکه"]
        NotificationCenter.default.post(name: Notification.Name("openCoinsOrMoney"), object: nil, userInfo: pageIndexDict)
        self.view.isUserInteractionEnabled = true
    }
    
//    @objc func menuButtonChanged(index : Int) {
//        let pageIndexDict:[String: Int] = ["button": index]
//        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
//    }
//
//    @objc func scrollPageViewController(index : Int) {
//        let pageIndexDict:[String: Int] = ["pageIndex": index]
//        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
//    }
    
    var urlClass = urls()
    var menuState = String()
    var alertTitle = String()
    var alertBody = String()
    var alertAcceptLabel = String()
    
    @objc func fillData() {
        if (login.res?.response?.mainInfo?.status) != nil {
        level.text = (login.res?.response?.mainInfo?.level)!
        money.text = (login.res?.response?.mainInfo?.cashs)!
        xp.text = "\((login.res?.response?.mainInfo?.max_points_gain)!)/\((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)"
        coin.text = (login.res?.response?.mainInfo?.coins)!
        xp.minimumScaleFactor = 0.5
        xp.adjustsFontSizeToFitWidth = true
        xpProgressBackGround.layer.cornerRadius  = 3
        profileName.text = (login.res?.response?.mainInfo?.username)!
        cup.text = (login.res?.response?.mainInfo?.cups)!
        self.xpProgress.progress = 0.0
        let urlAvatar = "\(urlClass.avatar)\((login.res?.response?.mainInfo?.avatar)!)"
            self.avatar.setImageWithRealmPath(url : urlAvatar)
                if self.avatar.image != UIImage() {
            } else {
                self.avatar.setImageWithKingFisher(url: urlAvatar)
            }
            
        mainCupImage.setImageWithKingFisher(url: "\((loadingViewController.loadGameData?.response?.gameLeagues[Int((login.res?.response?.mainInfo?.league_id)!)!].img_logo!)!)")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UIDevice().userInterfaceIdiom == .phone  {
            startLabel.AttributesOutLine(font: fonts.init().iPhonefonts, title: "شروع بازی", strokeWidth: 6.0)
            friendlyLabel.AttributesOutLine(font: UIFont(name: "DPA_Game", size: 18)!, title: "دوستانه", strokeWidth: -4.0)
            eliminateCupLabel.AttributesOutLine(font: UIFont(name: "DPA_Game", size: 18)!, title:  "پیش بینی", strokeWidth: -4.0)
            startLabelForeGround.text =  "شروع بازی"
            startLabelForeGround.font = fonts.init().iPhonefonts
        } else {
            startLabel.AttributesOutLine(font: fonts.init().iPadfonts, title: "شروع بازی", strokeWidth: -4.0)
            friendlyLabel.AttributesOutLine(font: fonts.init().iPadfonts, title: "دوستانه", strokeWidth: -4.0)
            eliminateCupLabel.AttributesOutLine(font: fonts.init().iPadfonts, title: "پیش بینی", strokeWidth: -4.0)
            startLabelForeGround.text =  "شروع بازی"
            startLabelForeGround.font = fonts.init().iPadfonts
            
        }
        
        if matchViewController.isTutorial {
         PubProc.isSplash = false
        } else {
        PubProc.isSplash = true
        }
        login().loging(userid : "\(loadingViewController.userid)", rest: false, completionHandler: {
            self.fillData()
            DispatchQueue.main.async {
                PubProc.wb.hideWaiting()
                PubProc.isSplash = false
            }
        })
        
        
    }
    
    @objc func shakeFunstion() {
        self.giftOutlet.shake()
    }
    
    @objc func startNewMatch(_ notification: NSNotification) {
        DispatchQueue.main.async {
            PubProc.wb.showWaiting()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() +
        0.5) {
             PubProc.wb.hideWaiting()
            if let dict = notification.userInfo as NSDictionary? {
                if let match_id = dict["matchID"] as? String{
                    self.matchID = match_id
                    self.performSegue(withIdentifier: "startingMatch", sender: self)
                }
            }
        }
    }
    
    var shakeTimer : Timer!
    var helpDescs = [String]()
    var acceptTitles = [String]()
    static var  isTutorial = UserDefaults.standard.bool(forKey: "tutorial")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if wholeMainPageButtons != nil {
            if UIScreen.main.bounds.height < 568 {
                wholeMainPageButtons.constant = 20
            } else {
                wholeMainPageButtons.constant = 50
            }
        }
        
        if matchViewController.isTutorial {
            
            getHelp().gettingHelp(mode: "WELCOME", completionHandler: {
                for i in 0...(helpViewController.helpRes?.response?.count)! - 1 {
                    if helpViewController.helpRes?.response?[i].desc_text != nil {
                        self.helpDescs.append((helpViewController.helpRes?.response?[i].desc_text!)!)
                    } else {
                        self.helpDescs.append("")
                    }
                    if helpViewController.helpRes?.response?[i].key_title != nil {
                        self.acceptTitles.append((helpViewController.helpRes?.response?[i].key_title!)!)
                    } else {
                        self.acceptTitles.append("")
                    }
                }
                self.performSegue(withIdentifier : "tutorialHelp" , sender : self)
            })
        }
        
        
        self.shakeTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.shakeFunstion), userInfo: nil, repeats: true)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(fillData), name: Notification.Name("changingUserPassNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.startNewMatch(_:)), name: NSNotification.Name(rawValue: "startNewMatch"), object: nil)

        
        self.startLabelForeGround.minimumScaleFactor = 0.5
        self.startLabel.minimumScaleFactor = 0.5
        self.friendlyLabel.minimumScaleFactor = 0.5
        self.eliminateCupLabel.minimumScaleFactor = 0.5
        self.startLabel.adjustsFontSizeToFitWidth = true
        self.startLabelForeGround.adjustsFontSizeToFitWidth = true
        self.friendlyLabel.adjustsFontSizeToFitWidth = true
        self.eliminateCupLabel.adjustsFontSizeToFitWidth = true
        fillData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let pageIndexDict:[String: Int] = ["button": 2]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
        self.xpProgress.progress = 0.0
        DispatchQueue.main.async {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
   
            if  login.res?.response?.mainInfo?.max_points_gain != nil {
                self.xpProgress.setProgress(Float((login.res?.response?.mainInfo?.max_points_gain)!)! / Float((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)!, animated: true)
            }
        })
        }
    }
    
    @IBAction func achievements(_ sender: RoundButton) {
        loadingAchievements.init().loadAchievements(userid: loadingViewController.userid, rest: false, completionHandler: {
            DispatchQueue.main.async {
                PubProc.wb.hideWaiting()
            }
            self.menuState = "Achievements"
            self.performSegue(withIdentifier: "achievement", sender: self)
            })
    }
    
    @IBAction func setting(_ sender: RoundButton) {
        self.menuState = "Settings"
        self.performSegue(withIdentifier: "achievement", sender: self)
    }
    

    @IBAction func eliminateCupAction(_ sender: RoundButton) {
        self.performSegue(withIdentifier : "predictMatch" , sender : self)
//        scrollPageViewController(index: 1)
//        menuButtonChanged(index: 1)
    }
    
    @IBAction func StartAMatch(_ sender: RoundButton) {
        PubProc.wb.showWaiting()
        requestNewMatch()
    }
    
    var matchCreateRes : String? = nil;
    @objc func requestNewMatch() {
        PubProc.wb.hideWaiting()
        PubProc.HandleDataBase.readJson(wsName: "ws_UpdateGameResult", JSONStr: "{'mode':'START_RANDOM_GAME','userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
//                      print(data ?? "")

                        self.matchCreateRes = String(data: data!, encoding: String.Encoding.utf8) as String?

                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    if ((self.matchCreateRes)!).contains("GAME_NOT_AVAILABILE") {
                        self.alertTitle = "اخطار"
                        self.alertBody = "بازی های فعال شما از حد مجاز گذشته باید بازیاتو شارژ کنی یا صبر کنی تا یه بازی تموم بشه"
                        self.alertAcceptLabel = "تأیید"
                        self.menuState = "outOfGameCharge"
                        self.performSegue(withIdentifier: "showAlert2Btn", sender: self)
                        PubProc.wb.hideWaiting()
                    } else {
                        self.matchID = (self.matchCreateRes)!
                        self.performSegue(withIdentifier: "startingMatch", sender: self)
                        PubProc.wb.hideWaiting()
                    }
                    
                } else {
                    self.requestNewMatch()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vC = segue.destination as? menuViewController {
            vC.menuState = self.menuState
            vC.friensRes = self.friendsRes
            vC.profileResponse = login.res
        }
        
        if let vc = segue.destination as? giftsAndChargesViewController {
            vc.pageState = self.menuState
        }
        
        if let VC = segue.destination as? menuAlertViewController {
            VC.alertTitle = self.alertTitle
            VC.alertBody = self.alertBody
            VC.alertAcceptLabel = self.alertAcceptLabel
        }
        
        if let viewCon = segue.destination as? menuAlert2ButtonsViewController {
            viewCon.alertTitle = self.alertTitle
            viewCon.alertBody = self.alertBody
            viewCon.state = self.menuState
            viewCon.alertAcceptLabel = self.alertAcceptLabel
            viewCon.gameChargeDelegate = self
        }
        
        if let Vc = segue.destination as? startMatchViewController {
            Vc.matchID = self.matchID
        }
        
        if let vc = segue.destination as? helpViewController {
            vc.desc = self.helpDescs
            vc.acceptTitle = self.acceptTitles
            vc.state = "WELCOME"
            vc.delegate = self
        }
    }
    
    @IBAction func showLeagus(_ sender: UIButton) {
        self.performSegue(withIdentifier: "leagueShow", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gifts(_ sender: RoundButton) {
        self.menuState = "gifts"
        self.performSegue(withIdentifier: "giftsAndCharges", sender: self)
    }
    
    @objc func openGameChargingPage() {
        self.menuState = "gameCharge"
        self.performSegue(withIdentifier: "giftsAndCharges", sender: self)
    }
    
    @IBAction func gameCharge(_ sender: RoundButton) {
        openGameChargingPage()
    }
    
    @IBAction func questionsBank(_ sender: RoundButton) {
        self.alertTitle = "اخطار"
        self.alertBody = "بخش کارخانه سوال به زودی راه اندازی خواهد شد"
        self.alertAcceptLabel = "تأیید"
        self.performSegue(withIdentifier: "alert", sender: self)
    }
    
    @IBAction func showLeaderBoard(_ sender: RoundButton) {
        self.menuState = "LeaderBoard"
        self.performSegue(withIdentifier: "achievement", sender: self)
    }
    
    @IBAction func alerts(_ sender: RoundButton) {
        self.menuState = "alerts"
        self.performSegue(withIdentifier: "achievement", sender: self)
    }
    
    @IBAction func profile(_ sender: RoundButton) {
        self.menuState = "profile"
        getProfile()
    }
    
    @objc func getProfile() {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(loadingViewController.userid)' , 'load_stadium' : 'false'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        DispatchQueue.main.async {
                            PubProc.cV.hideWarning()
                        }
                        self.performSegue(withIdentifier: "achievement", sender: self)
                        PubProc.wb.hideWaiting()
                    } catch {
                        self.getProfile()
                        print(error)
                    }
                } else {
                    self.getProfile()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    @IBAction func requestFriendlyMatch(_ sender: RoundButton) {
        firendlyMatch()
    }
    
    var friendsRes : friendList.Response? = nil
    
    @objc func firendlyMatch() {
        PubProc.HandleDataBase.readJson(wsName: "ws_getFriendList", JSONStr: "{'userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.friendsRes = try JSONDecoder().decode(friendList.Response.self , from : data!)
                        
                        DispatchQueue.main.async {
                            self.menuState = "friendsList"
                            self.performSegue(withIdentifier: "achievement", sender: self)
                            PubProc.wb.hideWaiting()
                            PubProc.cV.hideWarning()
                        }
                        
                    } catch {
                        self.firendlyMatch()
                        print(error)
                    }
                } else {
                    self.firendlyMatch()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
}
