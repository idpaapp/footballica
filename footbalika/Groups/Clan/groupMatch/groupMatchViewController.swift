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

class groupMatchViewController: UIViewController , groupMembersViewControllerDelegate , clanMatchFieldViewControllerDelegate {
    
    @IBOutlet weak var clanResultsContainerView: UIView!
    
    @IBOutlet weak var timerContainerView: UIView!
    
    func updateAfterFinishGame() {
        self.isClanMatchField = false
    }
    var warQuestions :  warQuestions.Response? = nil
    var isClanMatchField = Bool()
    func startAnswerWar(questions : warQuestions.Response) {
        self.warQuestions = questions
        DispatchQueue.main.async {
            self.isClanMatchField = true
            self.performSegue(withIdentifier: "clanMatchField", sender: self)
        }
    }
    
    func joinWar() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'JOIN_WAR' , 'user_id' : '\(loadingViewController.userid)' , 'war_id' : '\((self.activeWarRes?.response?.id!)!)'}") { data, error in
            
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
                
            } else {
                self.joinWar()
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
    
    @objc func updateclanGamePage() {
        if !isClanMatchField {
        PubProc.isSplash = true
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
                    } else {
                        startButtonState = true
                    }
                    
                    DispatchQueue.main.async {
                        
                        switch ((self.activeWarRes?.status!)!) {
                        case "NO_ACTIVE_WAR" :
                            self.state = "NO_ACTIVE_WAR"
                            self.setPageOutlets(hidRonaldoAndMessi: false, hideMagnifier: true, hideClanTimer: true, hideStartGameButton: startButtonState, hideClanResults: true, clanMembers: true, hidetimerContainerView: true)
                        case "OK" :
                            switch ((self.activeWarRes?.response?.status!)!) {
                            case publicConstants().clanJoined :
                                self.state = "OK"
                                self.setPageOutlets(hidRonaldoAndMessi: true, hideMagnifier: true, hideClanTimer: false, hideStartGameButton: true, hideClanResults: true, clanMembers: false, hidetimerContainerView: true)
                                self.setupClanTime()
                                self.setupClanMemberList(isStartWar: false)
                                if !self.isUpdated {
                                    self.startGameTimer()
                                    self.isUpdated = true
                                }
                                 self.members?.isWarStart = false
                            case publicConstants().magnifier :
                                self.setPageOutlets(hidRonaldoAndMessi: true, hideMagnifier: false, hideClanTimer: true, hideStartGameButton: true, hideClanResults: true, clanMembers: true, hidetimerContainerView: false)
                                self.state = "Searching"
                                self.setGhesarSentences()
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
                                self.setPageOutlets(hidRonaldoAndMessi: true, hideMagnifier: true, hideClanTimer: true, hideStartGameButton: true, hideClanResults: false, clanMembers: false, hidetimerContainerView: false)
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
                
            } else {
                self.updateclanGamePage()
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageOutlets(hidRonaldoAndMessi: false, hideMagnifier: true, hideClanTimer: true, hideStartGameButton: true, hideClanResults: true, clanMembers: true, hidetimerContainerView: true)
        if login.res?.response?.calnData?.clanMembers?.count != 0 {
            updateclanGamePage()
        }
        setStartGroupGameButton()
    }
    
    func setPageOutlets(hidRonaldoAndMessi : Bool , hideMagnifier : Bool , hideClanTimer : Bool , hideStartGameButton : Bool , hideClanResults : Bool , clanMembers : Bool , hidetimerContainerView : Bool) {
        self.ronaldoAndMessi.isHidden = hidRonaldoAndMessi
        self.magnifier.isHidden = hideMagnifier
        self.clanTimer.isHidden = hideClanTimer
        self.clanMembersContainerView.isHidden = clanMembers
        self.startGameButton.isHidden = hideStartGameButton
        self.clanResultsContainerView.isHidden = hideClanResults
        self.timerContainerView.isHidden = hidetimerContainerView
        self.ghesarSentencesLabel.isHidden = hideMagnifier
    }
    
    @objc func setStartGroupGameButton() {
        self.startGameButton.setButtons(hideAction: false, hideAction1: true, hideAction2: true, hideAction3: true)
        self.startGameButton.setTitles(actionTitle: "شروع بازی گروهی", action1Title: "", action2Title: "", action3Title: "")
        self.startGameButton.actionButton.addTarget(self, action: #selector(startGameAction), for: UIControlEvents.touchUpInside)
    }
    
    var startWarRes : startWar.Response? = nil
    @objc func startGameAction() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'START_WAR' , 'userid' : '\(loadingViewController.userid)'}") { data, error in
            
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
                            self.setPageOutlets(hidRonaldoAndMessi: true, hideMagnifier: true, hideClanTimer: false, hideStartGameButton: true, hideClanResults: true, clanMembers: false, hidetimerContainerView: true)
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
                
            } else {
                self.startGameAction()
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
        if self.ghesarCount == 30 {
            self.ghesarCount = 0
        } else  {
            if self.ghesarCount == 1 {
                var randomGhesar = arc4random_uniform(UInt32((loadingViewController.loadGameData?.response?.ghesarSentences.count)!))
                while self.currentGhesar == randomGhesar {
                    randomGhesar = arc4random_uniform(UInt32((loadingViewController.loadGameData?.response?.ghesarSentences.count)!))
                }
                self.currentGhesar = Int(randomGhesar)
                
                self.ghesarSentencesLabel.text = (loadingViewController.loadGameData?.response?.ghesarSentences[self.currentGhesar].desc_text!)!
                
            } else {
                
                self.ghesarSentencesLabel.text = (loadingViewController.loadGameData?.response?.ghesarSentences[self.currentGhesar].desc_text!)!
                
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
        
        let time = loadingViewController.OnlineTime/1000
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
        
        var minutes = String()
        if (differenceOfDate.minute!.description.count) == 1 {
            minutes = "0\(differenceOfDate.minute!)"
        } else {
            minutes = "\(differenceOfDate.minute!)"
        }
        
        if self.currentTime.hour != nil {
            if min(self.currentTime.second!, differenceOfDate.second!) == differenceOfDate.second! {
                self.clanTimer.clanTimerCounter.text = "\(differenceOfDate.hour!):\(minutes):\(seconds)"
                self.cTimer?.updateTimer(time: "\(differenceOfDate.hour!):\(minutes):\(seconds)")
                if differenceOfDate.hour! == 0 && minutes == "00" && seconds == "00" {
                    self.clanTimer.isHidden = true
                }
            }
        }
    }
    
    var ghesarCount = Int()
    var currentGhesar = Int()
    
    @objc func countDownTimer() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3:30") 
        guard let date = dateFormatter.date(from: "\((self.activeWarRes?.response?.start_time!)!)") else {
            fatalError()
        }
        let time = loadingViewController.OnlineTime/1000
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
                self.magnifier.animatingImageView(Radius : 50, circleCenter: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - heightOfButtomMenu))
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        magnifierState()
    }
    
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
    }
}
