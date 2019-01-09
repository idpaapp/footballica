//
//  groupMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/30/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

protocol groupMembersViewControllerDelegate {
    func joinWar()
    func startAnswerWar(questions : warQuestions.Response)
}

protocol clanMatchFieldViewControllerDelegate {
    func updateAfterFinishGame()
}

protocol clanRewardsViewControllerDelegate {
    func updateAfterClaimReward()
    func showClanRewards(rewardItems : warRewards.reward)
}

class groupMatchViewController: UIViewController , groupMembersViewControllerDelegate , clanMatchFieldViewControllerDelegate , clanRewardsViewControllerDelegate {
    
    @IBOutlet weak var clanResultsContainerView: UIView!
    
    @IBOutlet weak var timerContainerView: UIView!
    
    @IBOutlet weak var clanReward: UIView!
    
    func updateAfterClaimReward() {
        clanRewards()
    }
    
    
    var delegate : groupMatchViewControllerDelegate!
    func showClanRewards(rewardItems : warRewards.reward) {
        self.delegate?.showRewards(rewardItems : rewardItems)
    }
    
    func updateAfterFinishGame() {
        self.isClanMatchField = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        magnifierState()
    }
    
    var warQuestions :  warQuestions.Response? = nil
    var isClanMatchField = false
    
    func startAnswerWar(questions : warQuestions.Response) {
        self.warQuestions = questions
        DispatchQueue.main.async {
            PubProc.wb.hideWaiting()
            self.isClanMatchField = true
            self.startGameButton.actionButton.isUserInteractionEnabled = false
            self.performSegue(withIdentifier: "clanMatchField", sender: self)
        }
    }
    
    func joinWar() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'JOIN_WAR' , 'user_id' : '\(matchViewController.userid)' , 'war_id' : '\((self.activeWarRes?.response?.id!)!)'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                let res = String(data: data!, encoding: String.Encoding.utf8) as String?
                print(res!)
                DispatchQueue.main.async {
                    if (res!).contains("USER_JOINED_BEFORE") {
                        print("شما قبلاً عضو شده اید")
                    } else if (res!).contains("USER_JOINED") {
                        self.updateclanGamePage()
                    } else if (res!).contains("NOT_ENOUGH_RESOURCE") {
                        print("شما منابع لازم برای انجام این کار را ندارید")
                    } else {
                        print("else")
                    }
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
                self.joinWar()
                    })
                }
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
    }
    
    @IBOutlet weak var startGameButton: actionLargeButton!
    
    @IBOutlet weak var bombCount: UILabel!
    
    @IBOutlet weak var freezeCount: UILabel!
    
    @IBOutlet weak var magnifier: UIImageView!
    
    @IBOutlet weak var ghesarSentencesLabel: UILabel!
    
    @IBOutlet weak var ghesarBackGround: DesignableView!
    
    @IBOutlet weak var ronaldoAndMessi: UIImageView!
    
    @IBOutlet weak var clanTimer: clanTimerView!
    
    @IBOutlet weak var clanMembersContainerView: UIView!
    
    var members : groupMembersViewController?
    
    var cTimer : showTimerViewController?
    
    var state = "Searching"
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var cResults: clanResultsViewController?
    var isUpdated = false
    var activeWarRes : getActiveWar.Response? = nil
    var warID = String()
    
    @objc func updateclanGamePage() {
//        if self.warReward?.unclaimed_reward?.reward != nil {
//            if (self.warReward?.unclaimed_reward?.is_claimed!)! != "0" {
//                clanData()
//            } else {
//                clanData()
//            }
//        } else {
//            clanData()
//        }
                clanData()
    }
    
    func isClanMatchFieldData(isDisable : Bool) {
    self.isClanMatchField = isDisable
    }
    
    @objc func clanData() {
        if !self.isClanMatchField {
            PubProc.isSplash = true
            if login.res?.response?.calnData?.clanid != nil {
            DispatchQueue.main.async {
                self.bombCount.text = "\(((login.res?.response?.mainInfo?.bomb)!)!)"
                self.freezeCount.text = "\(((login.res?.response?.mainInfo?.freeze)!)!)"
            }
            PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'GET_ACTIVE_WAR' , 'clan_id' : '\((login.res?.response?.calnData?.clanid!)!)'}") { data, error in
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    DispatchQueue.main.async {
                        PubProc.wb.hideWaiting()
                    }
                    PubProc.isSplash = false
                    
                    do {
                        
                        self.activeWarRes = try JSONDecoder().decode(getActiveWar.Response.self, from: data!)
                        var startButtonState = Bool()
                        
                        if ((login.res?.response?.calnData?.member_roll!)!) == "1" {
                            startButtonState = false
                            self.setStartGroupGameButton()
                        } else {
                            startButtonState = true
                        }
                        
                        DispatchQueue.main.async {
                            
                            switch ((self.activeWarRes?.status!)!) {
                            case "NO_ACTIVE_WAR" :
                                self.state = "NO_ACTIVE_WAR"
                                self.setPageOutlets(hidRonaldoAndMessi: false, hideMagnifier: true, hideClanTimer: true, hideStartGameButton: startButtonState, hideClanResults: true, clanMembers: true, hidetimerContainerView: true, hideClanReward: true)
                            case "OK" :
                                switch ((self.activeWarRes?.response?.status!)!) {
                                case publicConstants().clanJoined :
                                    self.warID = (self.activeWarRes?.response?.id!)!
                                    self.state = "OK"
                                    self.setPageOutlets(hidRonaldoAndMessi: true, hideMagnifier: true, hideClanTimer: false, hideStartGameButton: true, hideClanResults: true, clanMembers: false, hidetimerContainerView: true, hideClanReward: true)
                                    self.setupClanTime()
                                    self.setupClanMemberList(isStartWar: false)
                                    if !self.isUpdated {
                                        self.startGameTimer()
                                        self.isUpdated = true
                                    }
                                    self.members?.isWarStart = false
                                case publicConstants().magnifier :
                                    self.warID = (self.activeWarRes?.response?.id!)!
                                    self.setPageOutlets(hidRonaldoAndMessi: true, hideMagnifier: false, hideClanTimer: false, hideStartGameButton: true, hideClanResults: true, clanMembers: true, hidetimerContainerView: true, hideClanReward: true)
                                    self.state = "Searching"
//                                    self.setGhesarSentences()
                                    self.setupClanTime()
                                    if !self.updateSearch {
                                        self.magnifierState()
                                        self.updateSearch = true
                                        if !self.isUpdated {
                                            self.startGameTimer()
                                            self.isUpdated = true
                                        }
                                    }
                                    self.members?.isWarStart = false
                                case publicConstants().war :
                                    self.warID = (self.activeWarRes?.response?.id!)!
                                    self.setPageOutlets(hidRonaldoAndMessi: true, hideMagnifier: true, hideClanTimer: true, hideStartGameButton: true, hideClanResults: false, clanMembers: false, hidetimerContainerView: false, hideClanReward: true)
                                    self.cResults?.groupsUpdate(clanImage: ((login.res?.response?.calnData?.caln_logo!)!), oppClanImage: (self.activeWarRes?.response?.opp_clan_logo!)!, clanName: ((login.res?.response?.calnData?.clan_title!)!), oppClanName: (self.activeWarRes?.response?.opp_clan_title!)!, clanScore: (self.activeWarRes?.response?.war_point!)!, oppClanScore: (self.activeWarRes?.response?.opp_war_point!)!)
                                    self.setupClanTime()
                                    self.setupClanMemberList(isStartWar: false)
                                    self.members?.startWarUpdate()
                                    self.members?.activeWarRes = self.activeWarRes
                                    self.members?.reloadingData(members: (self.activeWarRes?.response?.members?.count)!)
                                    self.members?.isWarStart = true
                                    if !self.isUpdated {
                                        self.startGameTimer()
                                        self.isUpdated = true
                                    }
                                default :
                                    break
                                }
                            default :
                                break
                            }
                        }
                    } catch {
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
                    self.updateclanGamePage()
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
                }.resume()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageOutlets(hidRonaldoAndMessi: false, hideMagnifier: true, hideClanTimer: true, hideStartGameButton: true, hideClanResults: true, clanMembers: true, hidetimerContainerView: true, hideClanReward: true)
        self.startGameButton.setButtons(hideAction: true, hideAction1: true, hideAction2: true, hideAction3: true)
        if login.res?.response?.calnData?.clanMembers?.count != 0 {
            clanRewards()
        }
    }
    
    var warReward : warRewards.Response?
    @objc func clanRewards() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'GET_WAR_CLAN_DATA' , 'user_id' : '\(matchViewController.userid)'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                do {
                    
                    self.warReward = try JSONDecoder().decode(warRewards.Response.self, from: data!)
                    
                    if self.warReward?.unclaimed_reward?.reward != nil {
                        if (self.warReward?.unclaimed_reward?.is_claimed!)! == "0" {
                            self.setPageOutlets(hidRonaldoAndMessi: true, hideMagnifier: true, hideClanTimer: true, hideStartGameButton: true, hideClanResults: true, clanMembers: true, hidetimerContainerView: true, hideClanReward: false)
                            
                            let vc = self.childViewControllers.last as! clanRewardsViewController
                            vc.warId = (self.warReward?.unclaimed_reward?.war_id!)!
                            vc.claimId = (self.warReward?.unclaimed_reward?.id!)!
                            vc.rewardItems = self.warReward?.unclaimed_reward?.reward
                            vc.getClanRwards()
                            //                        warRewards
                        } else {
                            self.updateclanGamePage()
                            self.setStartGroupGameButton()
                        }
                    } else {
                        self.updateclanGamePage()
                        self.setStartGroupGameButton()
                    }
                    
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
                self.clanRewards()
                    })
                }
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
    }
    
    func setPageOutlets(hidRonaldoAndMessi : Bool , hideMagnifier : Bool , hideClanTimer : Bool , hideStartGameButton : Bool , hideClanResults : Bool , clanMembers : Bool , hidetimerContainerView : Bool , hideClanReward : Bool) {
        DispatchQueue.main.async {
        self.ronaldoAndMessi.isHidden = hidRonaldoAndMessi
        self.magnifier.isHidden = hideMagnifier
        self.clanTimer.isHidden = hideClanTimer
        self.clanMembersContainerView.isHidden = clanMembers
        self.startGameButton.isHidden = hideStartGameButton
        self.clanResultsContainerView.isHidden = hideClanResults
        self.timerContainerView.isHidden = hidetimerContainerView
        self.ghesarSentencesLabel.isHidden = hideMagnifier
        self.ghesarBackGround.isHidden = hideMagnifier
        self.clanReward.isHidden = hideClanReward
        }
    }
    
    @objc func setStartGroupGameButton() {
        DispatchQueue.main.async {
        self.startGameButton.actionButton.isUserInteractionEnabled = true
        self.startGameButton.setButtons(hideAction: false, hideAction1: true, hideAction2: true, hideAction3: true)
        self.startGameButton.setTitles(actionTitle: "شروع بازی گروهی", action1Title: "", action2Title: "", action3Title: "")
             self.startGameButton.actionButton.addTarget(self, action: #selector(self.startGameAction), for: UIControlEvents.touchUpInside)
        }
    }
    
    var startWarRes : startWar.Response? = nil
    @objc func startGameAction() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'START_WAR' , 'userid' : '\(matchViewController.userid)'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                do {
                    
                    print(String(data: data!, encoding: String.Encoding.utf8) ?? "")
                    self.startWarRes = try JSONDecoder().decode(startWar.Response.self, from: data!)
                    DispatchQueue.main.async {
                        if ((self.startWarRes?.status!)!) == "OK" {
                            self.setPageOutlets(hidRonaldoAndMessi: true, hideMagnifier: true, hideClanTimer: false, hideStartGameButton: true, hideClanResults: true, clanMembers: false, hidetimerContainerView: true, hideClanReward: true)
                            //                            self.setupClanTime()
                            self.updateclanGamePage()
                        } else if ((self.startWarRes?.status!)!) == "THERE_IS_ACTIVE_WAR" {
                            print("THERE_IS_ACTIVE_WAR")
                        }
                    }
                    
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
                self.startGameAction()
                    })
                }
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
    }
    
    var gameTimer : Timer!
    
    @objc func startGameTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 10.0 , target: self, selector: #selector(updateclanGamePage), userInfo: nil, repeats: true)
    }
    
    func setupClanTime() {
        self.clanTimer.clanImage.setImageWithKingFisher(url: "\(urls().clan)\((login.res?.response?.calnData?.caln_logo!)!)")
        self.clanTimer.clanName.text =  "\((login.res?.response?.calnData?.clan_title!)!)"
        self.clanTimer.clanTimerTitle.text = "زمان باقی مانده تا شروع"
        calculatingTimeLeft()
    }
    
    @objc func setGhesarSentences() {
        self.ghesarCount = self.ghesarCount + 1
        if self.ghesarCount >= 30 {
            self.ghesarCount = 0
        } else  {
            if self.ghesarCount == 1 {
                var randomGhesar = arc4random_uniform(UInt32((gameDataModel.loadGameData?.response?.ghesarSentences.count)!))
                while self.currentGhesar == randomGhesar {
                    randomGhesar = arc4random_uniform(UInt32((gameDataModel.loadGameData?.response?.ghesarSentences.count)!))
                }
                self.currentGhesar = Int(randomGhesar)
                self.ghesarSentencesLabel.text = (gameDataModel.loadGameData?.response?.ghesarSentences[self.currentGhesar].desc_text!)!
            } else {
                self.ghesarSentencesLabel.text = (gameDataModel.loadGameData?.response?.ghesarSentences[self.currentGhesar].desc_text!)!
            }
        }
    }
    
    var currentTime = DateComponents()
    var updateSearch = Bool()
    @objc func calculatingTimeLeft() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3:30") //
        guard let date = dateFormatter.date(from: "\((self.activeWarRes?.response?.start_time!)!)") else {
            fatalError()
        }
        
        let time = matchViewController.OnlineTime/1000
        let onlineTime = Double(time)
        var previousDate = Date()
        let onlineDate = Date(timeIntervalSince1970: onlineTime)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeStyle = DateFormatter.Style.long
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3:30")
        previousDate = onlineDate
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: previousDate, to: date)
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0 , target: self, selector: #selector(countDownTimer), userInfo: nil, repeats: true)
        var timesSeconds = Int()
        if self.currentTime.hour != nil {
            timesSeconds = min(self.currentTime.second!, differenceOfDate.second!)
        } else {
            timesSeconds = differenceOfDate.second!
        }
        
        var seconds = String()
        if (timesSeconds.description.count) == 1 {
            seconds = "0\(timesSeconds)"
        } else {
            seconds = "\(timesSeconds)"
        }
        
        var timesMinutes = Int()
        if self.currentTime.hour != nil {
            timesMinutes = min(self.currentTime.minute!, differenceOfDate.minute!)
        } else {
            timesMinutes = differenceOfDate.minute!
        }
        
        var minutes = String()
        if (timesMinutes.description.count) == 1 {
            minutes = "0\(timesMinutes)"
        } else {
            minutes = "\(timesMinutes)"
        }
        
        var timesHours = Int()
        if self.currentTime.hour != nil {
            timesHours = min(self.currentTime.hour!, differenceOfDate.hour!)
        } else {
            timesHours = differenceOfDate.hour!
        }
        
       
        if self.currentTime.hour != nil {
            if min(self.currentTime.second!, differenceOfDate.second!) == differenceOfDate.second! {
                self.clanTimer.clanTimerCounter.text = "\(timesHours):\(minutes):\(seconds)"
                self.cTimer?.updateTimer(time: "\(timesHours):\(minutes):\(seconds)")
                if differenceOfDate.hour! == 0 && minutes == "00" && seconds == "00" {
                    self.clanTimer.isHidden = true
                }
            }
        }
    }
    
    var ghesarCount = Int()
    var currentGhesar = Int()
    
    @objc func countDownTimer() {
         setGhesarSentences()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3:30") 
        guard let date = dateFormatter.date(from: "\((self.activeWarRes?.response?.start_time!)!)") else {
            fatalError()
        }
        let time = matchViewController.OnlineTime/1000
        let onlineTime = Double(time)
        var previousDate = Date()
        let onlineDate = Date(timeIntervalSince1970: onlineTime)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeStyle = DateFormatter.Style.long
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3:30")
        previousDate = onlineDate
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let currentDate = Calendar.current.date(byAdding: .second, value: -1, to: date)
        let differenceOfDate = Calendar.current.dateComponents(components, from: previousDate, to: currentDate!)
        
        self.currentTime = differenceOfDate
        
        var seconds = String()
        if (differenceOfDate.second!.description.count) == 1 {
            seconds = "0\(differenceOfDate.second!)"
        } else {
            seconds = "\(differenceOfDate.second!)"
        }
        
        var minutes = String()
        if (differenceOfDate.minute!.description.count) == 1 {
            minutes = "0\(differenceOfDate.minute!)"
        } else {
            minutes = "\(differenceOfDate.minute!)"
        }
        
        self.clanTimer.clanTimerCounter.text = "\(differenceOfDate.hour!):\(minutes):\(seconds)"
        
        self.cTimer?.updateTimer(time: "\(differenceOfDate.hour!):\(minutes):\(seconds)")
        
        if differenceOfDate.hour! == 0 && minutes == "00" && seconds == "00" {
            self.clanTimer.isHidden = true
        }
    }
    
    
    
    func setupClanMemberList(isStartWar : Bool) {
        DispatchQueue.main.async {
            var membersCount = Int()
            self.members?.enableOrDisableJoinWar(isEnable: true)
            if isStartWar {
                if self.startWarRes?.response?.members != nil {
                    membersCount = Int((self.startWarRes?.response?.members?.count)!)
                } else {
                    membersCount = 0
                }
                self.members?.startWarRes = self.startWarRes
                self.members?.activeWarRes = nil
                self.members?.reloadingData(members: membersCount)
            } else {
                if self.activeWarRes?.response?.members != nil {
                    membersCount = Int((self.activeWarRes?.response?.members?.count)!)
                } else {
                    membersCount = 0
                }
                self.members?.activeWarRes = self.activeWarRes
                self.members?.startWarRes = nil
                self.members?.reloadingData(members: membersCount)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewDidLayoutSubviews()
    }
    
    @objc func magnifierState() {
        if state == "Searching" {
            if !self.updateSearch {
                var heightOfButtomMenu = CGFloat()
                if UIDevice().userInterfaceIdiom == .phone {
                    if UIScreen.main.nativeBounds.height == 2436 {
                        heightOfButtomMenu = 135
                    } else {
                        heightOfButtomMenu = 85
                    }
                } else {
                    heightOfButtomMenu = 135
                }
                DispatchQueue.main.async {
                    self.magnifier.animatingImageView(Radius : 25, circleCenter: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - heightOfButtomMenu))
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        magnifierState()
    //    }
    

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? groupMembersViewController {
            vc.delegate = self
            if segue.identifier == "membersOfGroup" {
                self.members = segue.destination as? groupMembersViewController
            }
        }
        
        if let vc = segue.destination as? clanMatchFieldViewController {
            vc.warQuestions = self.warQuestions
            vc.delegate = self
            vc.warID = self.warID
        }
        
        
        //        if let vc = segue.destination as? showTimerViewController {
        if segue.identifier == "timer" {
            self.cTimer = segue.destination as?
            showTimerViewController
        }
        //        }
        if segue.identifier == "clanResults" {
            self.cResults = segue.destination as? clanResultsViewController
        }
        
        if let vc = segue.destination as? clanRewardsViewController {
            vc.delegate = self
        }
    }
}
