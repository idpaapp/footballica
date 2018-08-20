//
//  achievementsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/13/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class menuViewController: UIViewController {
    
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    
    @IBOutlet weak var menuWidth: NSLayoutConstraint!
    
    @IBOutlet weak var mainBackGround: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var maintitle: UILabel!
    
    @IBOutlet weak var mainTitleForeGround: UILabel!
    
    @IBOutlet weak var subMainBackGround: UIView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    
    var friensRes : friendList.Response? = nil
    var menuState = String()
    var otherProfiles = Bool()
    var oPStadium = String()
    var opName = String()
    var opAvatar = String()
    var opBadge = String()
    var opID = String()
    var opCups = String()
    var opLevel = String()
    var opWinCount = String()
    var opCleanSheetCount = String()
    var opLoseCount = String()
    var opMostScores = String()
    var opDrawCount = String()
    var opMaximumWinCount = String()
    var opMaximumScore = String()
    var uniqueId = String()
    var urlClass = urls()
    var isFriend = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainBackGround.layer.cornerRadius = 15
        self.topView.layer.cornerRadius = 15
        self.subMainBackGround.layer.cornerRadius = 15
        
        if menuState == "Achievements" {
            
            self.mainTitleForeGround.text = "دستاوردها"
            if UIDevice().userInterfaceIdiom == .phone {
                self.menuHeight.constant = ((8 * UIScreen.main.bounds.height) / 9)
                self.menuWidth.constant = 280
                maintitle.AttributesOutLine(font: iPhonefonts, title: "دستاوردها", strokeWidth: -7.0)
                self.mainTitleForeGround.font = iPhonefonts
            } else {
                self.menuHeight.constant = ((8 * UIScreen.main.bounds.height) / 9)
                self.menuWidth.constant = 600
                maintitle.AttributesOutLine(font: iPadfonts, title: "دستاوردها", strokeWidth: -7.0)
                self.mainTitleForeGround.font = iPadfonts
            }
        } else if menuState == "LeaderBoard" {
            self.mainTitleForeGround.text = "رتبه بندی"
            if UIDevice().userInterfaceIdiom == .phone {
                self.mainTitleForeGround.font = iPhonefonts
                if UIScreen.main.nativeBounds.height == 2436 {
                self.menuHeight.constant = UIScreen.main.bounds.height - 90
                self.menuWidth.constant = UIScreen.main.bounds.width - 10
                maintitle.AttributesOutLine(font: iPhonefonts, title: "رتبه بندی", strokeWidth: -7.0)
                } else {
                    self.menuHeight.constant = UIScreen.main.bounds.height - 30
                    self.menuWidth.constant = UIScreen.main.bounds.width - 10
                    maintitle.AttributesOutLine(font: iPhonefonts, title: "رتبه بندی", strokeWidth: -7.0)
                }
            } else {
                self.menuHeight.constant = UIScreen.main.bounds.height - 100
                self.menuWidth.constant = 3 * (UIScreen.main.bounds.width / 4)
                maintitle.AttributesOutLine(font: iPadfonts, title: "رتبه بندی", strokeWidth: -7.0)
                self.mainTitleForeGround.font = iPadfonts
            }
        } else if self.menuState == "alerts" {
            self.mainTitleForeGround.text = "اخبار و اعلان ها"
            if UIDevice().userInterfaceIdiom == .phone {
                self.menuHeight.constant = UIScreen.main.bounds.height - 100
                self.menuWidth.constant = UIScreen.main.bounds.width - 40
                maintitle.AttributesOutLine(font: iPhonefonts, title: "اخبار و اعلان ها", strokeWidth: -7.0)
                self.mainTitleForeGround.font = iPhonefonts
            } else {
                self.menuHeight.constant = UIScreen.main.bounds.height - 100
                self.menuWidth.constant = 3 * (UIScreen.main.bounds.width / 4)
                maintitle.AttributesOutLine(font: iPadfonts, title: "اخبار و اعلان ها", strokeWidth: -7.0)
                self.mainTitleForeGround.font = iPadfonts
            }
            
          } else if self.menuState == "profile" {
            self.mainTitleForeGround.text = "پروفایل"
            if UIDevice().userInterfaceIdiom == .phone {
                var stadium = String()
                if otherProfiles == false {
                    stadium = (login.res?.response?.mainInfo?.stadium)!
                } else {
                    stadium = oPStadium
                }
                if UIScreen.main.nativeBounds.height == 2436 && stadium == "empty_std.jpg"{
                  self.menuHeight.constant = UIScreen.main.bounds.height - 115
                } else {
                self.menuHeight.constant = UIScreen.main.bounds.height - 100
                }
                self.menuWidth.constant = UIScreen.main.bounds.width - 40
                maintitle.AttributesOutLine(font: iPhonefonts, title: "پروفایل", strokeWidth: -7.0)
                self.mainTitleForeGround.font = iPhonefonts
            } else {
                if otherProfiles == false {
                    let stadium = (login.res?.response?.mainInfo?.stadium)!
                    if stadium != "empty_std.jpg" {
                        self.menuHeight.constant = UIScreen.main.bounds.height - 100
                    } else {
                        self.menuHeight.constant = UIScreen.main.bounds.height - 230
                    }
                } else {
                    let stadium = oPStadium
                    if stadium != "empty_std.jpg" {
                        self.menuHeight.constant = UIScreen.main.bounds.height - 100
                    } else {
                        self.menuHeight.constant = UIScreen.main.bounds.height - 230
                    }
                }
                
                self.menuWidth.constant = 3 * (UIScreen.main.bounds.width / 4)
                maintitle.AttributesOutLine(font: iPadfonts, title: "پروفایل", strokeWidth: -7.0)
                self.mainTitleForeGround.font = iPadfonts
            }
            
            
        } else if self.menuState == "friendsList" {
            self.mainTitleForeGround.text = "دوستان"
            if UIDevice().userInterfaceIdiom == .phone {
                self.mainTitleForeGround.font = iPhonefonts
                if UIScreen.main.nativeBounds.height == 2436 {
                    self.menuHeight.constant = UIScreen.main.bounds.height - 90
                    self.menuWidth.constant = UIScreen.main.bounds.width - 10
                    maintitle.AttributesOutLine(font: iPhonefonts, title: "دوستان", strokeWidth: -7.0)
                } else {
                    self.menuHeight.constant = UIScreen.main.bounds.height - 30
                    self.menuWidth.constant = UIScreen.main.bounds.width - 10
                    maintitle.AttributesOutLine(font: iPhonefonts, title: "دوستان", strokeWidth: -7.0)
                }
            } else {
                self.menuHeight.constant = UIScreen.main.bounds.height - 100
                self.menuWidth.constant = 3 * (UIScreen.main.bounds.width / 4)
                maintitle.AttributesOutLine(font: iPadfonts, title: "دوستان", strokeWidth: -7.0)
                self.mainTitleForeGround.font = iPadfonts
            }
        } else {
             self.mainTitleForeGround.text = "تنظیمات"
            if UIDevice().userInterfaceIdiom == .phone {
            self.menuHeight.constant = 318
            self.menuWidth.constant = 280
            maintitle.AttributesOutLine(font: iPhonefonts, title: "تنظیمات", strokeWidth: -7.0)
            self.mainTitleForeGround.font = iPhonefonts
            } else {
             self.menuHeight.constant = 418
             self.menuWidth.constant = 370
            maintitle.AttributesOutLine(font: iPadfonts, title: "تنظیمات", strokeWidth: -7.0)
            self.mainTitleForeGround.font = iPadfonts
            }
        }
    }

    @objc func dismissing() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func crossDismiss(_ sender: UIButton) {
        dismissing()
    }
    @IBAction func dismissAction(_ sender: UIButton) {
        dismissing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vC = segue.destination as? achievementsViewController {
            vC.pageState = self.menuState
            switch self.menuState {
            case "Achievements" :
                vC.achievementCount = 10
            case "LeaderBoard" :
                vC.achievementCount = 0
            case "alerts" :
                vC.achievementCount = 0
            case "profile" :
                if otherProfiles == false {
                    let stadium = (login.res?.response?.mainInfo?.stadium)!
                    if stadium != "empty_std.jpg" {
                        vC.achievementCount = 5
                    } else {
                        vC.achievementCount = 4
                    }
                    vC.otherProfile = false
                    vC.profileAvatar = "\(urlClass.avatar)\((login.res?.response?.mainInfo?.avatar)!)"
                    vC.profileBadge = "\(urlClass.badge)\((login.res?.response?.mainInfo?.badge_name)!)"
                    vC.profileName = (login.res?.response?.mainInfo?.username)!
                    vC.profileID = (login.res?.response?.mainInfo?.ref_id)!
                    vC.profileCups = (login.res?.response?.mainInfo?.cups)!
                    vC.profileLevel = (login.res?.response?.mainInfo?.level)!
                    vC.profileWinCount = (login.res?.response?.mainInfo?.win_count)!
                    vC.profileCleanSheetCount = (login.res?.response?.mainInfo?.clean_sheet_count)!
                    vC.profileLoseCount = (login.res?.response?.mainInfo?.lose_count)!
                    vC.profileMostScores = (login.res?.response?.mainInfo?.max_points_gain)!
                    vC.profileDrawCount = (login.res?.response?.mainInfo?.draw_count)!
                    vC.profileStadium = "\(urlClass.stadium)\((login.res?.response?.mainInfo?.stadium)!)"
                    vC.profileMaximumWinCount = (login.res?.response?.mainInfo?.max_wins_count)!
                    vC.profileMaximumScore = (login.res?.response?.mainInfo?.max_point)!
                } else {
                    let stadium = oPStadium
                    if stadium != "empty_std.jpg" {
                        vC.achievementCount = 5
                    } else {
                        vC.achievementCount = 4
                    }
                    
                    vC.otherProfile = true
                    vC.profileAvatar = opAvatar
                    vC.profileBadge = opBadge
                    vC.profileName = opName
                    vC.profileID = opID
                    vC.profileCups = opCups
                    vC.profileLevel = opLevel
                    vC.profileWinCount = opWinCount
                    vC.profileCleanSheetCount = opCleanSheetCount
                    vC.profileLoseCount = opLoseCount
                    vC.profileMostScores = opMostScores
                    vC.profileDrawCount = opDrawCount
                    vC.profileStadium = "\(urlClass.stadium)\(oPStadium)"
                    vC.profileMaximumWinCount = opMaximumWinCount
                    vC.profileMaximumScore = opMaximumScore
                    vC.uniqueId = uniqueId
                    vC.isFriend = self.isFriend
                }
            case "friendsList" :
                vC.friensRes = self.friensRes
                vC.achievementCount = (self.friensRes?.response?.count)!
            default :
                vC.achievementCount = 4
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
