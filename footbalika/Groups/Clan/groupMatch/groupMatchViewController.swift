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
}

class groupMatchViewController: UIViewController , groupMembersViewControllerDelegate {
    
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
        //        USER_JOINED
        //        NOT_ENOUGH_RESOURCE
        //        USER_JOINED_BEFORE
    }
    
    @IBOutlet weak var startGameButton: actionLargeButton!
    
    @IBOutlet weak var bombCount: UILabel!
    
    @IBOutlet weak var freezeCount: UILabel!
    
    @IBOutlet weak var magnifier: UIImageView!
    
    @IBOutlet weak var ronaldoAndMessi: UIImageView!
    
    @IBOutlet weak var clanTimer: clanTimerView!
    
    @IBOutlet weak var clanMembersContainerView: UIView!
    
    
    var state = "Searching"
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var activeWarRes : getActiveWar.Response? = nil
    @objc func updateclanGamePage() {
        PubProc.isSplash = true
        self.bombCount.text = "\(((login.res?.response?.mainInfo?.bomb)!)!)"
        self.freezeCount.text = "\(((login.res?.response?.mainInfo?.freeze)!)!)"
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
                        print(((self.activeWarRes?.status!)!))
                        switch ((self.activeWarRes?.status!)!) {
                        case "NO_ACTIVE_WAR" :
                            self.state = "NO_ACTIVE_WAR"
                            self.setPageOutlets(hidRonaldoAndMessi: false, hideMagnifier: true, hideClanTimer: true, hideStartGameButton: startButtonState)
                        case "OK" :
                            self.state = "OK"
                            self.setPageOutlets(hidRonaldoAndMessi: true, hideMagnifier: true, hideClanTimer: false, hideStartGameButton: true)
                            self.setupClanTimer()
                            self.setupClanMemberList(isStartWar: false)
                            break
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageOutlets(hidRonaldoAndMessi: false, hideMagnifier: true, hideClanTimer: true, hideStartGameButton: true)
        updateclanGamePage()
        setStartGroupGameButton()
    }
    
    func setPageOutlets(hidRonaldoAndMessi : Bool , hideMagnifier : Bool , hideClanTimer : Bool , hideStartGameButton : Bool ) {
        self.ronaldoAndMessi.isHidden = hidRonaldoAndMessi
        self.magnifier.isHidden = hideMagnifier
        self.clanTimer.isHidden = hideClanTimer
        self.clanMembersContainerView.isHidden = hideClanTimer
        self.startGameButton.isHidden = hideStartGameButton
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
                            self.setPageOutlets(hidRonaldoAndMessi: true, hideMagnifier: true, hideClanTimer: false, hideStartGameButton: true)
                            self.setupClanTimer()
                            self.setupClanMemberList(isStartWar: true)
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
    
    func setupClanTimer() {
        self.clanTimer.clanImage.setImageWithKingFisher(url: "\(urls().clan)\((login.res?.response?.calnData?.caln_logo!)!)")
        self.clanTimer.clanName.text =  "\((login.res?.response?.calnData?.clan_title!)!)"
        self.clanTimer.clanTimerTitle.text = "زمان باقی مانده تا"
    }
    
    func setupClanMemberList(isStartWar : Bool) {
        let vc = childViewControllers.last as! groupMembersViewController
        var membersCount = Int()
        if isStartWar {
            if self.startWarRes?.response?.members != nil {
                membersCount = Int((self.startWarRes?.response?.members?.count)!)
            } else {
                membersCount = 0
            }
            vc.startWarRes = self.startWarRes
        } else {
            if self.activeWarRes?.response?.members != nil {
                membersCount = Int((self.activeWarRes?.response?.members?.count)!)
            } else {
                membersCount = 0
            }
            vc.activeWarRes = self.activeWarRes
        }
        vc.reloadingData(members: membersCount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewDidLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if state == "Searching" {
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
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? groupMembersViewController {
            vc.delegate = self
        }
    }
    
}
