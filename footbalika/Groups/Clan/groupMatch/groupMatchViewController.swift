//
//  groupMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/30/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

class groupMatchViewController: UIViewController {
    
    @IBOutlet weak var startGameButton: actionLargeButton!
    
    @IBOutlet weak var bombCount: UILabel!
    
    @IBOutlet weak var freezeCount: UILabel!
    
    @IBOutlet weak var magnifier: UIImageView!
    
    @IBOutlet weak var ronaldoAndMessi: UIImageView!
    
    @IBOutlet weak var clanTimer: clanTimerView!
    
    var state = "Searching"
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var activeWarRes : getActiveWar.Response? = nil
    @objc func updateclanGamePage() {
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
        updateclanGamePage()
        setStartGroupGameButton()
    }
    
    func setPageOutlets(hidRonaldoAndMessi : Bool , hideMagnifier : Bool , hideClanTimer : Bool , hideStartGameButton : Bool ) {
        self.ronaldoAndMessi.isHidden = hidRonaldoAndMessi
        self.magnifier.isHidden = hideMagnifier
        self.clanTimer.isHidden = hideClanTimer
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
    
}
