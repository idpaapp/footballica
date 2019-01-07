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

protocol giftsAndChargesViewControllerDelegate : NSObjectProtocol {
    func showCharge(image : String , title : String)
    func fillData()
    func showGift(image : String , title : String)
    func showGoogleGift(image : String , title : String)
}

protocol menuViewControllerDelegate2 : NSObjectProtocol {
    func fillData()
    func showGift(image : String , title : String)
}

class matchViewController: UIViewController , GameChargeDelegate , TutorialDelegate , publicMassageNoKeysViewControllerDelegate , giftsAndChargesViewControllerDelegate , menuViewControllerDelegate2 {
    
    @IBOutlet weak var showAdsOutlet: RoundButton!
    let ts = testTapsellViewController()
    static var showingPublicMassages = true
    public static var OnlineTime = Int64()
    static var userid = String()
    var tapsell = testTapsellViewController()
    
    @IBAction func showAdsAction(_ sender: RoundButton) {
        musicPlay().playMenuMusic()
        self.tapsell.gettingAds()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            PubProc.wb.showWaiting()
        }
    }
    
    let adsView = videoAdsView()
    func adsOutlet() {
        self.adsView.frame = CGRect(x: 0, y: 0, width: self.showAdsOutlet.frame.size.width, height: self.showAdsOutlet.frame.size.height)
        self.showAdsOutlet.addSubview(adsView)
        self.showAdsOutlet.sendSubview(toBack: self.adsView)
        self.view.bringSubview(toFront: showAdsOutlet)
        self.adsView.isUserInteractionEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adsOutlet()
    }
        
    func openGameChargePage() {
        DispatchQueue.main.async {
            self.openGameChargingPage()
        }
    }
    
    func tutorialPage() {
        self.performSegue(withIdentifier: "showTutorial", sender: self)
    }
    
    func showGift(image : String , title : String) {
        self.dismiss(animated: true) { [weak self] in
                self?.upgradeImage = image
                self?.alertTitle = title
                self?.isGift = true
                self?.performSegue(withIdentifier: "showUpgrade", sender: self)
        }
    }
    
    func showGoogleGift(image : String , title : String) {
        self.upgradeImage = image
        self.alertTitle = title
        self.isGift = true
        self.performSegue(withIdentifier: "showUpgrade", sender: self)
    }
    
    
    @IBOutlet weak var gameChargeTimerBox: gameChargeTimerBox!
    @IBOutlet weak var gameChargeOutlet: RoundButton!
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
    
    func showCharge(image : String , title : String) {
        self.upgradeImage = image
        self.alertTitle = title
        self.performSegue(withIdentifier: "showUpgrade", sender: self)
    }
    
    var urlClass = urls()
    var menuState = String()
    var alertTitle = String()
    var alertBody = String()
    var alertAcceptLabel = String()
    
    @objc func fillData() {
        self.view.isUserInteractionEnabled = true
        if (login.res?.response?.mainInfo?.status) != nil {
            level.text = (login.res?.response?.mainInfo?.level)!
            money.text = (login.res?.response?.mainInfo?.cashs)!
            xp.text = "\((login.res?.response?.mainInfo?.max_points_gain)!)/\((gameDataModel.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)"
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
            mainCupImage.setImageWithKingFisher(url: "\((gameDataModel.loadGameData?.response?.gameLeagues[Int((login.res?.response?.mainInfo?.league_id)!)!].img_logo!)!)")
        }
        notificationsView()
        gameChargeSet()
    }
    
    @objc func updateGameChargeBox() {
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let onlineTime = matchViewController.OnlineTime.convertTime()
        let differenceOfDate = Calendar.current.dateComponents(components, from: self.gameChargeTime , to: onlineTime)
        updateGameChargeBoxOutlet(second : abs(differenceOfDate.second!) , minutes : abs(differenceOfDate.minute!) , hour : abs(differenceOfDate.hour!))
    }
    
    func updateGameChargeBoxOutlet(second : Int , minutes : Int , hour : Int) {
        var hourString = String()
        var minutesString = String()
        var secondString = String()
        
        if hour.description.count == 1 {
            hourString = "0\(hour)"
        } else {
            hourString = "\(hour)"
        }
        
        if minutes.description.count == 1 {
            minutesString = "0\(minutes)"
        } else {
            minutesString = "\(minutes)"
        }
        
        if second.description.count == 1 {
            secondString = "0\(second)"
        } else {
            secondString = "\(second)"
        }
        
        if second == 0 && minutes == 0 && hour == 0 {
            self.gameChargeTimerBox.isHidden = true
            normalGameChargeUI()
        }
        self.gameChargeTimerBox.timerTime.text = "\(hourString) : \(minutesString) : \(secondString)"
    }
    
    var gameChargeTime = Date()
    var gameChargeTimer : Timer!
    var canShowGameChargeBox = false
    @objc func gameChargeSet() {
        if login.res != nil {
        let finishTime = (login.res?.response?.mainInfo?.finish_extra_time!)!.convertDate()
        let onlineTime = matchViewController.OnlineTime.convertTime()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let difference = Calendar.current.dateComponents(components, from: onlineTime , to: finishTime)
        self.gameChargeTime = finishTime
        if difference.second! < 0 {
            normalGameChargeUI()
        } else {
            switch (login.res?.response?.mainInfo?.extra_type!)! {
            case "0":
                normalGameChargeUI()
            case "1":
                setGameChargeUI(imageNumber: 0, canShowChargeBox: true)
                gameChargeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateGameChargeBox), userInfo: nil, repeats: true)
            case "2":
                setGameChargeUI(imageNumber: 1, canShowChargeBox: true)
                gameChargeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateGameChargeBox), userInfo: nil, repeats: true)
            case "3":
                setGameChargeUI(imageNumber: 2, canShowChargeBox: false)
            case "4":
                setGameChargeUI(imageNumber: 3, canShowChargeBox: false)
            default:
                normalGameChargeUI()
            }
        }
        }
    }
    
    @objc func normalGameChargeUI() {
        self.gameChargeOutlet.setImage(UIImage(named: "ic_charge"), for: UIControlState.normal)
        self.canShowGameChargeBox = false
    }
    
    @objc func setGameChargeUI(imageNumber : Int , canShowChargeBox : Bool) {
        self.gameChargeOutlet.setImageWithKingFisher(url: "\((gameDataModel.loadGameData?.response?.gameCharge[imageNumber].image_path)!)")
        self.canShowGameChargeBox = canShowChargeBox
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
        if login.res != nil {
        let lastLevel = (Int((login.res?.response?.mainInfo?.level)!)!)
        login().loging(userid : "\(matchViewController.userid)", rest: false, completionHandler: {
            if (Int((login.res?.response?.mainInfo?.level)!)!) != lastLevel {
                self.upgradeImage = "ic_grade_badge"
                self.upgradeTitle = "ارتقاء سطح به \(lastLevel+1)"
                self.upgradeText = "\(lastLevel+1)"
                self.isGift = false
                self.performSegue(withIdentifier: "showUpgrade", sender: self)
            } else {}
            self.fillData()
            DispatchQueue.main.async {
                PubProc.wb.hideWaiting()
                PubProc.isSplash = false
            }
        })
        }
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
        
        self.view.addSubview(self.gameChargeTimerBox)
        self.gameChargeTimerBox.isHidden = true
        notificationsView()
        if wholeMainPageButtons != nil {
            if UIScreen.main.bounds.height < 667 {
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
        
        self.startLabelForeGround.setAdjustToFit()
        self.startLabel.setAdjustToFit()
        self.friendlyLabel.setAdjustToFit()
        self.eliminateCupLabel.setAdjustToFit()
        self.eliminateCupLabelForeGround.setAdjustToFit()
        self.friendlyLabelForeGround.setAdjustToFit()
        fillData()
    }
    
    
    func notificationsView() {
        self.alertCounterView.makeCircular()
        if login.res != nil {
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
    }
    
    var publicMassagesResponse : showPublicMassages.Response? = nil
    func showPulicMassages() {
        if login.res != nil {
        PubProc.HandleDataBase.readJson(wsName: "ws_HandleMessages", JSONStr: "{'mode' : 'READ_PUBLIC_MESSAGE_BY_USER' , 'userid' : '\(matchViewController.userid)'}") { data, error in
            
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
                    DispatchQueue.main.async {
                        PubProc.wb.hideWaiting()
                        PubProc.cV.hideWarning()
                    }
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "noInternetViewController")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = viewController
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
        
        if self.publicMassagesResponse?.response != nil {
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
            if matchViewController.showingPublicMassages  {
                    self.showPulicMassages()
                    matchViewController.showingPublicMassages = false
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
                    self.xpProgress.setProgress(Float((login.res?.response?.mainInfo?.max_points_gain)!)! / Float((gameDataModel.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)!, animated: true)
                }
            })
        }
    }
    
    @IBAction func achievements(_ sender: RoundButton) {
        loadingAchievements.init().loadAchievements(userid: matchViewController.userid, rest: false, completionHandler: {
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
        PubProc.HandleDataBase.readJson(wsName: "ws_UpdateGameResult", JSONStr: "{'mode':'START_RANDOM_GAME','userid':'\(matchViewController.userid)'}") { data, error in
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
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                            PubProc.cV.hideWarning()
                        }
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "noInternetViewController")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = viewController
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
            vC.delegate2 = self
        }
        
        if let vc = segue.destination as? giftsAndChargesViewController {
            vc.pageState = self.menuState
            vc.delegate = self
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
            if self.upgradeImage == "ic_grade_badge" {
                vc.isHomeUpgrade = true
                vc.TitleItem = self.upgradeTitle
            } else {
                vc.isHomeUpgrade = false
                vc.isPackage = true
                vc.TitleItem = self.alertTitle
            }
            vc.ImageItem = self.upgradeImage
            vc.upgradeText = self.upgradeText
            vc.isGift = self.isGift
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
    var isGift = Bool()
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
        if self.canShowGameChargeBox {
            if self.gameChargeTimerBox.isHidden {
                self.gameChargeTimerBox.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.hideGameChargeBox()
                }
            } else {
                self.gameChargeTimerBox.isHidden = true
            }
        } else {
            self.menuState = "gameCharge"
            self.performSegue(withIdentifier: "giftsAndCharges", sender: self)
        }
    }
    
    @objc func hideGameChargeBox() {
        UIView.animate(withDuration: 0.5, animations: {
            self.gameChargeTimerBox.alpha = 0
        }, completion: { (finish) in
            self.gameChargeTimerBox.isHidden = true
            self.gameChargeTimerBox.alpha = 1
        })
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
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(matchViewController.userid)' , 'load_stadium' : 'false'}") { data, error in
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
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                            PubProc.cV.hideWarning()
                        }
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "noInternetViewController")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = viewController
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
        PubProc.HandleDataBase.readJson(wsName: "ws_getFriendList", JSONStr: "{'userid':'\(matchViewController.userid)'}") { data, error in
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
                        
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                            PubProc.cV.hideWarning()
                        }
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "noInternetViewController")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = viewController
                        
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
