//
//  clanRewardsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class clanRewardsViewController: UIViewController {

    
    @IBOutlet weak var clanView: clanRewardsView!
    
    @IBOutlet weak var button: actionLargeButton!
    
    var warId = String()
    var claimId = String()
    var rewardItems : warRewards.reward? = nil
    var delegate : clanRewardsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(button)
        setupButton(isLoaded : false)
        
    }
    
    @objc func setupButton(isLoaded : Bool) {
        self.button.setButtons(hideAction: !isLoaded, hideAction1: true, hideAction2: true, hideAction3: true)
        self.button.setTitles(actionTitle: "خب", action1Title: "", action2Title: "", action3Title: "")
        self.button.actionButton.addTarget(self, action: #selector(claimReward), for: UIControlEvents.touchUpInside)
    }
    
    var rewards : warRewardsScore.Response? = nil
    @objc func getClanRwards() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'GET_WAR_RESULT' , 'war_id' : '\(self.warId)', 'user_id' : '\(matchViewController.userid)'}") { data, error in

                if data != nil {

                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }

                    //                print(data ?? "")

                    do {

                        self.rewards = try JSONDecoder().decode(warRewardsScore.Response.self, from: data!)

                        self.setupButton(isLoaded: true)
                        self.setupLabels()
                        print(self.rewards!)

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
                    self.getClanRwards()
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
                }.resume()
    }
    
    @objc func setupLabels() {
        
        DispatchQueue.main.async {
        
        //score
        let clanPoint = Int((self.rewards?.response?.war_point!)!)
        let otherClanPoint = Int((self.rewards?.response?.opp_war_point!)!)
        let cupCount = clanPoint! - otherClanPoint!
            
        var colorText = UIColor()
            if cupCount < 0 {
                self.clanView.cupCount.text = "-\(cupCount)"
                self.clanView.cupCount.textColor = publicColors().lostColor
                colorText = publicColors().lostColor
            } else {
                self.clanView.cupCount.text = "+\(cupCount)"
                self.clanView.cupCount.textColor = publicColors().winColor
                colorText = publicColors().winColor
            }
        
        // user Clan
        self.clanView.userClanView.clanImage.setImageWithKingFisher(url: "\(urls().clan)\((login.res?.response?.calnData?.caln_logo!)!)")
        self.clanView.userClanView.clanName.text = "\((login.res?.response?.calnData?.clan_title!)!)"
        self.clanView.userClanScore.text = "\((self.rewards?.response?.war_point!)!)"
        self.clanView.userClanScore.textColor = colorText
        
        // other Clan
        self.clanView.otherClanView.clanImage.setImageWithKingFisher(url: "\(urls().clan)\((self.rewards?.response?.opp_clan_logo!)!)")
        self.clanView.otherClanView.clanName.text = "\((self.rewards?.response?.opp_clan_title!)!)"
        self.clanView.otherClanScore.text = "\((self.rewards?.response?.opp_war_point!)!)"
        self.clanView.otherClanScore.textColor = colorText
        }
    }
    
    
    @objc func claimReward() {
            PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'CLAIM_REWARD' , 'claim_id' : '\(self.claimId)'}") { data, error in
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    DispatchQueue.main.async {
                        self.delegate?.updateAfterClaimReward()
                        self.delegate?.showClanRewards(rewardItems : self.rewardItems!)
                    }
                    
                    print(String(data: data!, encoding: String.Encoding.utf8)!)

//                    do {
//
//                        self.<#responseName#> = try JSONDecoder().decode(<#responseStructureName#>.self, from: data!)
//
//
//                    } catch {
//                        print(error)
//                    }
                    
                    DispatchQueue.main.async {
                        PubProc.wb.hideWaiting()
                    }
                    PubProc.countRetry = 0 
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.claimReward()
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
                }.resume()
    }
}
