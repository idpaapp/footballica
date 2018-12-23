//
//  matchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices

protocol GameChargeDelegate : class {
    func openGameChargePage()
}

protocol TutorialDelegate {
    func tutorialPage()
}

protocol publicMassageNoKeysViewControllerDelegate : NSObjectProtocol {
    func checkRestPublicMassages()
}

class matchViewController: UIViewController , GameChargeDelegate , TutorialDelegate , publicMassageNoKeysViewControllerDelegate {
    
    let ts = testTapsellViewController()
    
    @IBAction func tapsellAction(_ sender: Any) {
//        NotificationCenter.default.post(name: Notification.Name("showADS"), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performSegue(withIdentifier: "showAds", sender: self)
        }
    }
    
    func openGameChargePage() {
        DispatchQueue.main.async {
            self.openGameChargingPage()
        }
    }
    
    func tutorialPage() {
        self.performSegue(withIdentifier: "showTutorial", sender: self)
    }

    @IBOutlet weak var profileOutlet: RoundButton!
    @IBOutlet weak var wholeMainPageButtons: NSLayoutConstraint!
    @IBOutlet weak var startLabelForeGround: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var friendlyLabel: UILabel!
    @IBOutlet weak var friendlyLabelForeGround: UILabel!
    @IBOutlet weak var eliminateCupLabel: UILabel!
    @IBOutlet weak var eliminateCupLabelForeGround: UILabel!
    @IBOutlet weak var mainCupImage: UIImageView!
    @IBOutlet weak var cup: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var xp: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var coin: UILabel!
    @IBOutlet weak var xpProgress: UIProgressView!
    @IBOutlet weak var xpProgressBackGround: UIView!
    @IBOutlet weak var giftOutlet: RoundButton!
    var matchID = String()
    
    @IBOutlet weak var alertCounterView: UIView!
    @IBOutlet weak var alertCounterLabel: UILabel!
    
    @IBAction func addMoney(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        goToShop()
        let pageIndexDict:[String: String] = ["title": "پول"]
        NotificationCenter.default.post(name: Notification.Name("openCoinsOrMoney"), object: nil, userInfo: pageIndexDict)
        self.view.isUserInteractionEnabled = true
    }
    
    @IBAction func addCoin(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        goToShop()
        let pageIndexDict:[String: String] = ["title": "سکه"]
        NotificationCenter.default.post(name: Notification.Name("openCoinsOrMoney"), object: nil, userInfo: pageIndexDict)
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func goToShop() {
        scrollToPage().scrollPageViewController(index: 4)
        scrollToPage().menuButtonChanged(index: 4)
    }
    
    @objc func goToGroups() {
        scrollToPage().scrollPageViewController(index: 3)
        scrollToPage().menuButtonChanged(index: 3)
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
            if ((login.res?.response?.mainInfo?.avatar)!) != "user_empty.png" {
                let urlAvatar = "\(urlClass.avatar)\((login.res?.response?.mainInfo?.avatar)!)"
                self.profileOutlet.setImageWithKingFisher(url: urlAvatar)
            } else {
                self.profileOutlet.setImage(publicImages().emptyAvatar, for: .normal)
            }
            mainCupImage.setImageWithKingFisher(url: "\((loadingViewController.loadGameData?.response?.gameLeagues[Int((login.res?.response?.mainInfo?.league_id)!)!].img_logo!)!)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        notificationsView()
        
        if UIDevice().userInterfaceIdiom == .phone  {
            startLabel.AttributesOutLine(font: fonts.init().iPhonefonts, title: "شروع بازی", strokeWidth: 8.0)
            friendlyLabel.AttributesOutLine(font: fonts().iPhonefonts18, title: "دوستانه", strokeWidth: 8.0)
            eliminateCupLabel.AttributesOutLine(font: fonts().iPhonefonts18, title:  "پیش بینی", strokeWidth: 8.0)
            eliminateCupLabelForeGround.font = fonts().iPhonefonts18
            eliminateCupLabelForeGround.text = "پیش بینی"
            friendlyLabelForeGround.font = fonts().iPhonefonts18
            friendlyLabelForeGround.text = "دوستانه"
            startLabelForeGround.text =  "شروع بازی"
            startLabelForeGround.font = fonts.init().iPhonefonts
        } else {
            startLabel.AttributesOutLine(font: fonts.init().iPadfonts, title: "شروع بازی", strokeWidth: 8.0)
            friendlyLabel.AttributesOutLine(font: fonts.init().iPadfonts, title: "دوستانه", strokeWidth: 8.0)
            eliminateCupLabel.AttributesOutLine(font: fonts.init().iPadfonts, title: "پیش بینی", strokeWidth: 8.0)
            eliminateCupLabelForeGround.font = fonts().iPadfonts
            eliminateCupLabelForeGround.text = "پیش بینی"
            startLabelForeGround.text =  "شروع بازی"
            startLabelForeGround.font = fonts.init().iPadfonts
            friendlyLabelForeGround.font = fonts().iPadfonts
            friendlyLabelForeGround.text = "دوستانه"
        }
        
        if matchViewController.isTutorial {
            PubProc.isSplash = false
        } else {
            PubProc.isSplash = true
        }
        let lastLevel = (Int((login.res?.response?.mainInfo?.level)!)!)
        login().loging(userid : "\(loadingViewController.userid)", rest: false, completionHandler: {
            if (Int((login.res?.response?.mainInfo?.level)!)!) != lastLevel {
                self.upgradeImage = "ic_grade_badge"
                self.upgradeTitle = "ارتقاء سطح به \(lastLevel+1)"
                self.upgradeText = "\(lastLevel+1)"
                self.performSegue(withIdentifier: "showUpgrade", sender: self)
            } else {}
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
        
        notificationsView()
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
        self.eliminateCupLabelForeGround.minimumScaleFactor = 0.5
        self.friendlyLabelForeGround.minimumScaleFactor = 0.5
        self.startLabel.adjustsFontSizeToFitWidth = true
        self.startLabelForeGround.adjustsFontSizeToFitWidth = true
        self.friendlyLabel.adjustsFontSizeToFitWidth = true
        self.eliminateCupLabel.adjustsFontSizeToFitWidth = true
        self.eliminateCupLabelForeGround.adjustsFontSizeToFitWidth = true
        self.friendlyLabelForeGround.adjustsFontSizeToFitWidth = true
        fillData()
    }
    
    
    func notificationsView() {
        self.alertCounterView.makeCircular()
        let alertCounts = (login.res?.response?.nots_achv?.not_count!)!
        if alertCounts != "0" {
            self.alertCounterView.isHidden = false
            if alertCounts.count > 2 {
                self.alertCounterLabel.text = "+99"
            } else {
                self.alertCounterLabel.text = "\(alertCounts)"
            }
        } else {
            self.alertCounterLabel.text = ""
            self.alertCounterView.isHidden = true
        }
    }
    
    var publicMassagesResponse : showPublicMassages.Response? = nil
    func showPulicMassages() {
        PubProc.HandleDataBase.readJson(wsName: "ws_HandleMessages", JSONStr: "{'mode' : 'READ_PUBLIC_MESSAGE_BY_USER' , 'userid' : '\(loadingViewController.userid)'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                do {
                    
                    self.publicMassagesResponse = try JSONDecoder().decode(showPublicMassages.Response.self, from: data!)
                    
                    self.checkNoKeysMassages()
                } catch {
                    print(error)
                }
                
                DispatchQueue.main.async {
                    PubProc.wb.hideWaiting()
                }
                PubProc.countRetry = 0
            } else {
                PubProc.countRetry = PubProc.countRetry + 1
                if PubProc.countRetry == 10 {
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self.showPulicMassages()
                    })
                }
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
    }
    
    
    func checkRestPublicMassages() {
        switch (self.publicMassagesResponse?.response?[self.publicMassageIndex].option_field!)! {
        case let str where str.contains("SHOP") :
            goToShop()
        case let str where str.contains("CLAN") :
            goToGroups()
        case let str where str.contains("PREDICTION") :
            goToPredictPage()
        case let str where str.contains("INSTAGRAM") :
            showInstagramPage()
        default:
            checkNoKeysMassages()
        }
    }
    
    @objc func showInstagramPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5
            , execute: {
        let appURL = NSURL(string: "instagram://user?screen_name=footballica.ir")!
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL as URL)
            }
        } else {
            //redirect to safari because the user doesn't have Instagram
            if let url = URL(string: "https://instagram.com/footballica.ir") {
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            }
        }
        })
    }
    
    var publicMassageIndex = Int()
    
    @objc func checkNoKeysMassages() {
        var publicIDS : [String] = UserDefaults.standard.array(forKey: "publicMassagesIDS") as! [String]
        
         for i in 0...(self.publicMassagesResponse?.response!.count)! - 1 {
            if (self.publicMassagesResponse?.response?[i].option_field?.contains("PUBLIC_MESSAGE_FULL_NO_KEYS"))! {
                if publicIDS.contains((self.publicMassagesResponse?.response?[i].id!)!) {
                    if i == (self.publicMassagesResponse?.response!.count)! - 1 {
                        self.checkPublicMassagesFull()
                    }
                } else {
                    publicIDS.append((self.publicMassagesResponse?.response?[i].id!)!)
                    UserDefaults.standard.set(publicIDS, forKey: "publicMassagesIDS")
                    self.publicMassageIndex = i
                    self.massageImage = (self.publicMassagesResponse?.response?[i].image_path!)!
                    self.publicMassageAspectRatio = (self.publicMassagesResponse?.response?[i].option_field_2!)!
                    DispatchQueue.main.async {
                        self.publicMassageState = "PUBLIC_MESSAGE_FULL_NO_KEYS"
                        self.performSegue(withIdentifier: "showPublicMassagesNoKeys", sender: self)
                    }
                    break
                }
            }
        }
    }
    
    @objc func checkPublicMassagesFull() {
        var publicIDS : [String] = UserDefaults.standard.array(forKey: "publicMassagesIDS") as! [String]
        for i in 0...(self.publicMassagesResponse?.response!.count)! - 1 {
            if (self.publicMassagesResponse?.response?[i].option_field?.contains("PUBLIC_MESSAGE_FULL"))! {
                if publicIDS.contains((self.publicMassagesResponse?.response?[i].id!)!) {
                    if i == (self.publicMassagesResponse?.response!.count)! - 1 {
                        checkPublicMassage()
                    }
                } else {
                    publicIDS.append((self.publicMassagesResponse?.response?[i].id!)!)
                    UserDefaults.standard.set(publicIDS, forKey: "publicMassagesIDS")
                    self.massageImage = (self.publicMassagesResponse?.response?[i].image_path!)!
                   self.publicMassageSubject = (self.publicMassagesResponse?.response?[i].subject!)!
                   self.publicMassageContent = (self.publicMassagesResponse?.response?[i].contents!)!
                    self.publicMassageIndex = i
                    DispatchQueue.main.async {
                    self.publicMassageState = "PUBLIC_MESSAGE_FULL"
                    self.performSegue(withIdentifier: "showPublicMassagesNoKeys", sender: self)
                    }
                    break
                }
            }
        }
    }
    
    @objc func checkPublicMassage() {
        
        var publicIDS : [String] = UserDefaults.standard.array(forKey: "publicMassagesIDS") as! [String]
        for i in 0...(self.publicMassagesResponse?.response!.count)! - 1 {
            if (self.publicMassagesResponse?.response?[i].option_field?.contains("PUBLIC_MESSAGE"))! {
                if publicIDS.contains((self.publicMassagesResponse?.response?[i].id!)!) {
                    
                } else {
                    publicIDS.append((self.publicMassagesResponse?.response?[i].id!)!)
                    UserDefaults.standard.set(publicIDS, forKey: "publicMassagesIDS")
                    self.publicMassageSubject = (self.publicMassagesResponse?.response?[i].subject!)!
                    self.publicMassageContent = (self.publicMassagesResponse?.response?[i].contents!)!
                    self.publicMassageIndex = i
                    DispatchQueue.main.async {
                        self.publicMassageState = "PUBLIC_MESSAGE"
                        self.performSegue(withIdentifier: "showPublicMassagesNoKeys", sender: self)
                    }
                    break
                }
            }
        }
    }
    
    var massageImage = String()
    var publicMassageAspectRatio = String()
    var publicMassageState = String()
    var publicMassageSubject = String()
    var publicMassageContent = String()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !matchViewController.isTutorial {
            if loadingViewController.showPublicMassages  {
                showPulicMassages()
                loadingViewController.showPublicMassages = false
            } else {
                checkNoKeysMassages()
            }
        }

        UserDefaults.standard.set(true, forKey: "launchedBefore")
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
        goToPredictPage()
    }
    
    @objc func goToPredictPage() {
        self.performSegue(withIdentifier : "predictMatch" , sender : self)
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
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                            self.requestNewMatch()
                        })
                    }
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
            Vc.showWinLoseTable = true
        }
        
        if let vc = segue.destination as? helpViewController {
            vc.desc = self.helpDescs
            vc.acceptTitle = self.acceptTitles
            vc.state = "WELCOME"
            vc.delegate = self
        }
        
        if let vc = segue.destination as? ItemViewController {
            vc.isHomeUpgrade = true
            vc.TitleItem = self.upgradeTitle
            vc.ImageItem = self.upgradeImage
            vc.upgradeText = self.upgradeText
        }
        if let vc = segue.destination as? publicMassageNoKeysViewController {
            vc.massageImage = self.massageImage
            vc.massageAspectRatio = self.publicMassageAspectRatio
            vc.delegate = self
            vc.publicMassageState = self.publicMassageState
           vc.massageSubject = self.publicMassageSubject
           vc.massageContent = self.publicMassageContent
        }
    }
    
    var upgradeImage = String()
    var upgradeTitle = String()
    var upgradeText = String()
    
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
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                            self.getProfile()
                        })
                    }
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
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                            self.firendlyMatch()
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
}
