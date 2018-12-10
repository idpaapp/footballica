//
//  achievementsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/13/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

protocol achievementsViewControllerDelegate {
    func updateClanData()
    func dismissing()
}

class menuViewController: UIViewController  , achievementsViewControllerDelegate {
    
    
    func updateClanData() {
        self.delegate?.updatingClan()
    }
    
    
    
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
    
    var delegate : menuViewControllerDelegate!
    var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    
    var friensRes : friendList.Response? = nil
    var menuState = String()
    var isClanInvite = false
    var profileResponse : loginStructure.Response? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainBackGround.layer.cornerRadius = 15
        self.topView.layer.cornerRadius = 15
        self.subMainBackGround.layer.cornerRadius = 15
        
        if menuState == "Achievements" {
            
            self.mainTitleForeGround.text = "دستاوردها"
            if UIDevice().userInterfaceIdiom == .phone {
                self.menuHeight.constant = ((8 * UIScreen.main.bounds.height) / 9)
                self.menuWidth.constant = UIScreen.main.bounds.width - 20
                maintitle.AttributesOutLine(font: iPhonefonts, title: "دستاوردها", strokeWidth: 8.0)
                self.mainTitleForeGround.font = iPhonefonts
            } else {
                self.menuHeight.constant = ((8 * UIScreen.main.bounds.height) / 9)
                self.menuWidth.constant = 600
                maintitle.AttributesOutLine(font: iPadfonts, title: "دستاوردها", strokeWidth: 8.0)
                self.mainTitleForeGround.font = iPadfonts
            }
        } else if menuState == "LeaderBoard" {
            self.mainTitleForeGround.text = "رتبه بندی"
            if UIDevice().userInterfaceIdiom == .phone {
                self.mainTitleForeGround.font = iPhonefonts
                if UIScreen.main.nativeBounds.height == 2436 {
                self.menuHeight.constant = UIScreen.main.bounds.height - 90
                self.menuWidth.constant = UIScreen.main.bounds.width - 10
                maintitle.AttributesOutLine(font: iPhonefonts, title: "رتبه بندی", strokeWidth: 8.0)
                } else {
                    self.menuHeight.constant = UIScreen.main.bounds.height - 30
                    self.menuWidth.constant = UIScreen.main.bounds.width - 10
                    maintitle.AttributesOutLine(font: iPhonefonts, title: "رتبه بندی", strokeWidth: 8.0)
                }
            } else {
                self.menuHeight.constant = UIScreen.main.bounds.height - 100
                self.menuWidth.constant = 3 * (UIScreen.main.bounds.width / 4)
                maintitle.AttributesOutLine(font: iPadfonts, title: "رتبه بندی", strokeWidth: 8.0)
                self.mainTitleForeGround.font = iPadfonts
            }
        } else if self.menuState == "alerts" {
            self.mainTitleForeGround.text = "اخبار و اعلان ها"
            if UIDevice().userInterfaceIdiom == .phone {
                self.menuHeight.constant = UIScreen.main.bounds.height - 100
                self.menuWidth.constant = UIScreen.main.bounds.width - 40
                maintitle.AttributesOutLine(font: iPhonefonts, title: "اخبار و اعلان ها", strokeWidth: 8.0)
                self.mainTitleForeGround.font = iPhonefonts
            } else {
                self.menuHeight.constant = UIScreen.main.bounds.height - 100
                self.menuWidth.constant = 3 * (UIScreen.main.bounds.width / 4)
                maintitle.AttributesOutLine(font: iPadfonts, title: "اخبار و اعلان ها", strokeWidth: 8.0)
                self.mainTitleForeGround.font = iPadfonts
            }
            
          } else if self.menuState == "profile" {
            self.mainTitleForeGround.text = "پروفایل"
            if UIDevice().userInterfaceIdiom == .phone {
//                var stadium = String()
//                if otherProfiles == false {
//                    stadium = (login.res?.response?.mainInfo?.stadium)!
//                } else {
//                    stadium = oPStadium
//                }
                let stadium = (profileResponse?.response?.mainInfo?.stadium)!
                if UIScreen.main.nativeBounds.height == 2436 && stadium == "empty_std.jpg"{
                     if (profileResponse?.response?.mainInfo?.status!)! != "2" {
                     self.menuHeight.constant = UIScreen.main.bounds.height - 115
                     } else {
                     self.menuHeight.constant = UIScreen.main.bounds.height - 167
                    }
                } else {
                self.menuHeight.constant = UIScreen.main.bounds.height - 100
                }
                self.menuWidth.constant = UIScreen.main.bounds.width - 40
                maintitle.AttributesOutLine(font: iPhonefonts, title: "پروفایل", strokeWidth: 8.0)
                self.mainTitleForeGround.font = iPhonefonts
            } else {
                if loadingViewController.userid ==  (profileResponse?.response?.mainInfo?.id)! {
                    let stadium = (profileResponse?.response?.mainInfo?.stadium)!
                    if stadium != "empty_std.jpg" {
                        self.menuHeight.constant = UIScreen.main.bounds.height - 100
                    } else {
                        if (login.res?.response?.mainInfo?.status!)! != "2" {
                            self.menuHeight.constant = 790
                        } else {
//                        self.menuHeight.constant = UIScreen.main.bounds.height - 230
                            self.menuHeight.constant = 740
                        }
                    }
                } else {
                    let stadium = (profileResponse?.response?.mainInfo?.stadium)!
                    if stadium != "empty_std.jpg" {
                        self.menuHeight.constant = UIScreen.main.bounds.height - 100
                    } else {
                        self.menuHeight.constant = UIScreen.main.bounds.height - 230
                    }
                }
                
                self.menuWidth.constant = 3 * (UIScreen.main.bounds.width / 4)
                maintitle.AttributesOutLine(font: iPadfonts, title: "پروفایل", strokeWidth: 8.0)
                self.mainTitleForeGround.font = iPadfonts
            }
            
            
        } else if self.menuState == "friendsList" {
            self.mainTitleForeGround.text = "دوستان"
            if UIDevice().userInterfaceIdiom == .phone {
                self.mainTitleForeGround.font = iPhonefonts
                if UIScreen.main.nativeBounds.height == 2436 {
                    self.menuHeight.constant = UIScreen.main.bounds.height - 90
                    self.menuWidth.constant = UIScreen.main.bounds.width - 10
                    maintitle.AttributesOutLine(font: iPhonefonts, title: "دوستان", strokeWidth: 8.0)
                } else {
                    self.menuHeight.constant = UIScreen.main.bounds.height - 30
                    self.menuWidth.constant = UIScreen.main.bounds.width - 10
                    maintitle.AttributesOutLine(font: iPhonefonts, title: "دوستان", strokeWidth: 8.0)
                }
            } else {
                self.menuHeight.constant = UIScreen.main.bounds.height - 100
                self.menuWidth.constant = 3 * (UIScreen.main.bounds.width / 4)
                maintitle.AttributesOutLine(font: iPadfonts, title: "دوستان", strokeWidth: 8.0)
                self.mainTitleForeGround.font = iPadfonts
            }
        } else {
             self.mainTitleForeGround.text = "تنظیمات"
            if UIDevice().userInterfaceIdiom == .phone {
                if (login.res?.response?.mainInfo?.status!)! != "2" {
                    if (login.res?.response?.mainInfo?.email_connected!)! != "1" {
                    self.menuHeight.constant = 358
                    } else {
                    self.menuHeight.constant = 378
                    }
                } else {
                    if (login.res?.response?.mainInfo?.email_connected!)! != "1" {
                        self.menuHeight.constant = 408
                    } else {
                        self.menuHeight.constant = 428
                    }
                }
                self.menuWidth.constant = 280
            maintitle.AttributesOutLine(font: iPhonefonts, title: "تنظیمات", strokeWidth: 8.0)
            self.mainTitleForeGround.font = iPhonefonts
            } else {
                if (login.res?.response?.mainInfo?.status!)! != "2" {
                    if (login.res?.response?.mainInfo?.email_connected!)! != "1" {
                        self.menuHeight.constant = 458
                    } else {
                        self.menuHeight.constant = 478
                    }
                } else {
                    if (login.res?.response?.mainInfo?.email_connected!)! != "1" {
                        self.menuHeight.constant = 518
                    } else {
                        self.menuHeight.constant = 538
                    }
                }
             self.menuWidth.constant = 500
            maintitle.AttributesOutLine(font: iPadfonts, title: "تنظیمات", strokeWidth: 8.0)
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
                var profileCellsCount =  Int()
                    let stadium = (profileResponse?.response?.mainInfo?.stadium)!
                    if stadium != "empty_std.jpg" {
                        profileCellsCount = 5
                    } else {
                        profileCellsCount = 4
                    }
                if (profileResponse?.response?.calnData?.clanMembers) != nil {
                    profileCellsCount = profileCellsCount + 1
                }
                vC.achievementCount = profileCellsCount
                vC.pageState = "profile"
                vC.profileResponse = self.profileResponse
            case "friendsList" :
                vC.friensRes = self.friensRes
                vC.isClanInvite = self.isClanInvite
                vC.achievementCount = (self.friensRes?.response?.count)!
            default :
                if (login.res?.response?.mainInfo?.status!)! != "2" {
                vC.achievementCount = 4
                } else {
                vC.achievementCount = 5
                }
            }
            vC.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func unwindToMenu(segue:UIStoryboardSegue) { }
    
    
}
