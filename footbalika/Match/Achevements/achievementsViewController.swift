 //
//  achievementsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/22/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

class achievementsViewController : UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var achievementsTV: UITableView!

    var pageState = String()
    var settingsTitle = ["صداهای بازی",
                         "موسیقی بازی",
                         "اعلان ها"]
   
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var urlClass = urls()
    var switchStates = [Bool]()
    let playgameSounds = UserDefaults.standard.bool(forKey: "gameSounds")
    let playMenuMusic = UserDefaults.standard.bool(forKey: "menuMusic")
    let alerts = UserDefaults.standard.bool(forKey: "alerts")
    public var res : leaderBoard.Response? = nil ;
    var userNames = [String]()
    var userImages = [String]()
    var userCups = [String]()
    var userLogo = [String]()
    var otherProfile = Bool()
    var userButtons = Bool()
    
    @objc func leaderBoardJson() {
        
            PubProc.HandleDataBase.readJson(wsName: "ws_getLeaderBoard", JSONStr: "{}") { data, error in
                DispatchQueue.main.async {
                    
                    if data != nil {
                        
                        //                print(data ?? "")
                        
                        do {
                            
                            self.res = try JSONDecoder().decode(leaderBoard.Response.self , from : data!)

                            for i in  0...(self.res?.response?.count)! - 1 {
                                self.userNames.append((self.res?.response?[i].username!)!)
                                self.userImages.append((self.res?.response?[i].avatar!)!)
                                self.userCups.append((self.res?.response?[i].cups!)!)
                                self.userLogo.append((self.res?.response?[i].badge_name!)!)
                            }
                            DispatchQueue.main.async {
                                self.achievementCount = (self.res?.response?.count)!
                                self.achievementsTV.reloadData()
                            }
                        } catch {
                            self.leaderBoardJson()
                            print(error)
                        }
                    } else {
                        self.leaderBoardJson()
                        print("Error Connection")
                        print(error as Any)
                        // handle error
                    }
                }
                }.resume()
    }
    
    var alertsRes : allAlerts.Response? = nil ;
    var alertTypes = [String]()
    var alertTitles = [String]()
    var alertBody = [String]()
    var alertDate = [String]()
    var userAvatar = [String]()
    
    @objc func alertsJson() {
        PubProc.HandleDataBase.readJson(wsName: "ws_HandleMessages", JSONStr: "{'mode':'READ', 'userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.alertsRes = try JSONDecoder().decode(allAlerts.Response.self , from : data!)
                        
                        for i in 0...(self.alertsRes?.response?.count)! - 1 {
                            self.alertTypes.append((self.alertsRes?.response?[i].type!)!)
                            if (self.alertsRes?.response?[i].type!)! == "2" {
                            self.alertTitles.append((self.alertsRes?.response?[i].subject!)!)
                            self.alertBody.append((self.alertsRes?.response?[i].contents!)!)
                            self.userAvatar.append((self.alertsRes?.response?[i].image_path!)!)
                            } else {
                            self.alertTitles.append((self.alertsRes?.response?[i].username!)!)
                            self.alertBody.append((self.alertsRes?.response?[i].subject!)!)
                            self.userAvatar.append((self.alertsRes?.response?[i].avatar!)!)
                            }
                            
                            self.alertDate.append((self.alertsRes?.response?[i].p_message_date!)!)
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.achievementCount = (self.alertsRes?.response?.count)!
                            self.achievementsTV.reloadData()
                        }
                    } catch {
                        self.leaderBoardJson()
                        print(error)
                    }
                } else {
                    self.leaderBoardJson()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    static var friendsRes : friendList.Response? = nil;
    var friendsId = [String]()
    @objc func otherProfileJson() {
        PubProc.HandleDataBase.readJson(wsName: "ws_getFriendList", JSONStr: "{'userid': \(loadingViewController.userid) }") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        achievementsViewController.friendsRes = try JSONDecoder().decode(friendList.Response.self , from : data!)
                        
                        for i in 0...(achievementsViewController.friendsRes?.response?.count)! - 1 {
                            self.friendsId.append((achievementsViewController.friendsRes?.response?[i].friend_id!)!)
                        }
                        self.userButtons = true
                        DispatchQueue.main.async {
                            if self.pageState == "profile" {
                            let indexPathOfFriend = IndexPath(row: 1, section: 0)
                            self.achievementsTV.reloadRows(at: [indexPathOfFriend], with: .none)
                            }
                        }
                    } catch {
                        self.otherProfileJson()
                        print(error)
                    }
                } else {
                    self.otherProfileJson()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    let lightColor = UIColor.init(red: 240/255, green: 236/255, blue: 220/255, alpha: 1.0)
    let grayColor = UIColor.init(red: 98/255, green: 105/255, blue: 122/255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        if pageState == "LeaderBoard" {
            leaderBoardJson()
        }
         if self.pageState == "alerts" {
            alertsJson()
        }
        switchStates.append(playgameSounds)
        switchStates.append(playMenuMusic)
        switchStates.append(alerts)
    
        if otherProfile == true {
            otherProfileJson()
        } else {
            
        }
        
        switch self.pageState {
        case "Achievements":
            self.achievementsTV.bounces = true
            self.achievementsTV.isScrollEnabled = true
            self.achievementsTV.backgroundColor = lightColor
        case "LeaderBoard":
            self.achievementsTV.bounces = true
            self.achievementsTV.isScrollEnabled = true
            self.achievementsTV.backgroundColor = lightColor
        case "alerts":
            self.achievementsTV.bounces = true
            self.achievementsTV.isScrollEnabled = true
            self.achievementsTV.backgroundColor = lightColor
        case "profile":
            self.achievementsTV.bounces = false
            self.achievementsTV.isScrollEnabled = true
            self.achievementsTV.backgroundColor = grayColor
        default:
            self.achievementsTV.bounces = false
            self.achievementsTV.isScrollEnabled = false
            self.achievementsTV.backgroundColor = lightColor
        }
    }
    
    var achievementCount = Int()
    var achievementsProgress = [Float]()
    var achievementsTitles = [String]()

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageState == "Achievements" {
        return (loadingAchievements.res?.response?.count)!
        } else {
          return achievementCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch pageState {
        case "Achievements":
            let cell = tableView.dequeueReusableCell(withIdentifier: "achievementsCell", for: indexPath) as! achievementsCell
            
            //            print((loadingAchievements.res?.response?[indexPath.row].level_gain_reward!)!)
            //            print((loadingAchievements.res?.response?[indexPath.row].cash_reward!)!)
            //            print((loadingAchievements.res?.response?[indexPath.row].coin_reward!)!)
            //            print((loadingAchievements.res?.response?[indexPath.row].progress!)!)
            
            cell.coinLabel.text = (loadingAchievements.res?.response?[indexPath.row].coin_reward!)!
            cell.moneyLabel.text = (loadingAchievements.res?.response?[indexPath.row].cash_reward!)!
            
            cell.acievementTitleForeGround.text = "\((loadingAchievements.res?.response?[indexPath.row].title!)!)"
            if UIDevice().userInterfaceIdiom == .phone {
                cell.progressTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\((loadingAchievements.res?.response?[indexPath.row].progress)!)/10", strokeWidth: -3.0)
                cell.acievementTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: -7.0)
                cell.acievementTitleForeGround.font = fonts().iPhonefonts
            } else {
                cell.progressTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\((loadingAchievements.res?.response?[indexPath.row].progress)!)/10", strokeWidth: -3.0)
                cell.acievementTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: -7.0)
                cell.acievementTitleForeGround.font = fonts().iPadfonts
            }
            cell.achievementDesc.text = "\((loadingAchievements.res?.response?[indexPath.row].describtion!)!)"
            let progressAchievement = (Float((loadingAchievements.res?.response?[indexPath.row].progress)!)!) / 10.0
            print("progress\(progressAchievement)")
            cell.achievementProgress.progress = progressAchievement
            return cell
        case "LeaderBoard":
            let cell = tableView.dequeueReusableCell(withIdentifier: "leaderBoardCell", for: indexPath) as! leaderBoardCell
            
            cell.number.text = "\(indexPath.row + 1)"
            cell.playerName.text = "\(userNames[indexPath.row])"
            let url = "\(urlClass.avatar)\(self.userImages[indexPath.row])"
            let urls = URL(string : url)
            cell.avatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
            let url2 = "\(urlClass.badge)\(self.userLogo[indexPath.row])"
            let urls2 = URL(string : url2)
            cell.playerLogo.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
            cell.playerCup.text = "\(self.userCups[indexPath.row])"
            cell.selectLeaderBoard.tag = indexPath.row
            cell.selectLeaderBoard.addTarget(self, action: #selector(selectLeaderBoard), for: UIControlEvents.touchUpInside)
            return cell
        case "alerts":
            if self.alertTypes[indexPath.row] == "2" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "alertType1Cell", for: indexPath) as! alertType1Cell
                
                cell.alertTitle.text = self.alertTitles[indexPath.row]
                cell.alertBody.text = self.alertBody[indexPath.row]
                cell.alertDate.text = self.alertDate[indexPath.row]
                let url = "http://volcan.ir/adelica/images/news/\(self.userAvatar[indexPath.row])"
                let urls = URL(string : url)
                cell.alertImage.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "alertTypeChooseCell", for: indexPath) as! alertTypeChooseCell
                
                cell.alertTitle.text = self.alertTitles[indexPath.row]
                cell.alertDate.text = self.alertDate[indexPath.row]
                let url = "\(urlClass.avatar)\(self.userAvatar[indexPath.row])"
                let urls = URL(string : url)
                cell.userAvatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
                cell.alertBody.text = self.alertBody[indexPath.row]
                return cell
                
            }
        case "profile":
            
            switch indexPath.row {
                
            case 0 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "profile1Cell", for: indexPath) as! profile1Cell
                cell.contentView.backgroundColor = grayColor
                cell.firstProfileTitleForeGround.text = "مشخصات بازیکن"
                let url =  profileAvatar                
                let urls = URL(string : url)
                cell.profileAvatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
                let url2 = profileBadge
                let urls2 = URL(string : url2)
                cell.profileLogo.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.firstProfileTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "مشخصات بازیکن", strokeWidth: -7.0)
                    cell.profileName.AttributesOutLine(font: fonts().iPhonefonts18, title: "\(profileName)", strokeWidth: -3.0)
                    cell.profileId.AttributesOutLine(font: fonts().iPhonefonts, title: "\(profileID)", strokeWidth: -3.0)
                    cell.firstProfileTitleForeGround.font = fonts().iPhonefonts
                } else {
                    cell.firstProfileTitle.AttributesOutLine(font: fonts().iPadfonts, title: "مشخصات بازیکن", strokeWidth: -7.0)
                    cell.profileName.AttributesOutLine(font: fonts().iPadfonts25, title: "\(profileName)", strokeWidth: -3.0)
                    cell.profileId.AttributesOutLine(font: fonts().iPadfonts25, title: "\(profileID)", strokeWidth: -3.0)
                    cell.firstProfileTitleForeGround.font = fonts().iPadfonts
                }
                cell.profileCup.text = profileCups
                cell.profileLevel.text = profileLevel
                
                return cell
                
                
            case 1 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "profileButtonsCell", for: indexPath) as! profileButtonsCell
                
                cell.contentView.backgroundColor = grayColor

                if otherProfile == true {
                    if userButtons ==  true {
                    cell.completingProfile.isHidden = true
                        if uniqueId == "1" {
                            cell.cancelFriendship.isHidden = true
                            cell.friendshipRequest.isHidden = true
                            cell.playRequest.isHidden = true
                        } else if self.friendsId.contains(uniqueId) {
                        cell.cancelFriendship.isHidden = false
                        cell.friendshipRequest.isHidden = true
                        cell.playRequest.isHidden = false
                    } else {
                        cell.cancelFriendship.isHidden = true
                        cell.friendshipRequest.isHidden = false
                        cell.playRequest.isHidden = true
                    }
                } else {
                    cell.completingProfile.isHidden = false
                }
                } else {
                    cell.cancelFriendship.isHidden = true
                    cell.friendshipRequest.isHidden = true
                    cell.playRequest.isHidden = true
                    cell.completingProfile.isHidden = true
                }
                
                return cell
                
            case 2 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "profile2Cell", for: indexPath) as! profile2Cell
                cell.secondProfileTitleForeGround.text = "آمار و نتایج بازی ها"
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.secondProfileTitle.AttributesOutLine(font: fonts().iPhonefonts18, title: "آمار و نتایج بازی ها", strokeWidth: -7.0)
                    cell.secondProfileTitleForeGround.font = fonts().iPhonefonts18
                } else {
                    cell.secondProfileTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "آمار و نتایج بازی ها", strokeWidth: -7.0)
                    cell.secondProfileTitleForeGround.font = fonts().iPadfonts25
                }
                cell.contentView.backgroundColor = grayColor
                cell.drawCount.text = profileDrawCount
                cell.winCount.text = profileWinCount
                cell.loseCount.text = profileLoseCount
                cell.cleanSheetCount.text = profileCleanSheetCount
                cell.mostScores.text = profileMostScores
                return cell
                
            case 3 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "profile3Cell", for: indexPath) as! profile3Cell
                cell.contentView.backgroundColor = grayColor
                cell.maximumScores.text = profileMaximumScore
                cell.maximumWinCount.text = profileMaximumWinCount
                cell.thirdProfileTitleForeGround.text = "آمار و نتایج جام های حذفی"
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.thirdProfileTitle.AttributesOutLine(font: fonts().iPhonefonts18, title: "آمار و نتایج جام های حذفی", strokeWidth: -7.0)
                    cell.thirdProfileTitleForeGround.font = fonts().iPhonefonts18
                } else {
                    cell.thirdProfileTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "آمار و نتایج جام های حذفی", strokeWidth: -7.0)
                    cell.thirdProfileTitleForeGround.font = fonts().iPadfonts25
                }
                return cell
                
            default :
                let cell = tableView.dequeueReusableCell(withIdentifier: "profile4Cell", for: indexPath) as! profile4Cell
                cell.contentView.backgroundColor = grayColor
                cell.fourthProfileTitleForeGround.text = "استادیوم"
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.fourthProfileTitle.AttributesOutLine(font: fonts().iPhonefonts18, title: "استادیوم", strokeWidth: -7.0)
                    cell.fourthProfileTitleForeGround.font = fonts().iPhonefonts18
                } else {
                    cell.fourthProfileTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "استادیوم", strokeWidth: -7.0)
                    cell.fourthProfileTitleForeGround.font = fonts().iPadfonts25
                }
                
                let url = profileStadium
                let urls = URL(string : url)
                cell.stadiumImage.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
                
                return cell
            }
           
        default:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "googleEntranceCell", for: indexPath) as! googleEntranceCell
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! settingsCell
                
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.settingLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(settingsTitle[indexPath.row - 1])", strokeWidth: -7.0)
                    cell.settingLabelForeGround.font = fonts().iPhonefonts
                } else {
                    cell.settingLabel.AttributesOutLine(font: fonts().iPadfonts, title: "\(settingsTitle[indexPath.row - 1])", strokeWidth: -7.0)
                    cell.settingLabelForeGround.font = fonts().iPadfonts
                }
                cell.settingLabelForeGround.text = "\(settingsTitle[indexPath.row - 1])"
                cell.switchSet.tag = indexPath.row - 1
                cell.switchSet.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
                cell.switchSet.setOn(switchStates[indexPath.row - 1], animated: false)
                if cell.switchSet.isOn {
                    if let ThumbImg = UIImage(named: "ic_green_ball") {
                        cell.switchSet.thumbTintColor = UIColor(patternImage: ThumbImg)
                    }
                } else {
                    if let ThumbImg = UIImage(named: "ic_red_ball") {
                        cell.switchSet.thumbTintColor = UIColor(patternImage: ThumbImg)
                    }
                }
                return cell
            }
            
        }
        
    }
    
    var profileAvatar = String()
    var profileName = String()
    var profileID = String()
    var profileLevel = String()
    var profileBadge = String()
    var profileWinCount = String()
    var profileCleanSheetCount = String()
    var profileLoseCount = String()
    var profileMostScores = String()
    var profileDrawCount = String()
    var profileStadium = String()
    var profileMaximumWinCount = String()
    var profileMaximumScore = String()
    var profileCups = String()
    var uniqueId = String()
    
    
    @objc func switchChanged(_ sender : UISwitch!) {
         if (sender.isOn == true){
            switchStates[sender.tag] = true
            UserDefaults.standard.set(switchStates[0], forKey: "gameSounds")
            UserDefaults.standard.set(switchStates[1], forKey: "menuMusic")
            UserDefaults.standard.set(switchStates[2], forKey: "alerts")
         } else {
            switchStates[sender.tag] = false
            UserDefaults.standard.set(switchStates[0], forKey: "gameSounds")
            UserDefaults.standard.set(switchStates[1], forKey: "menuMusic")
            UserDefaults.standard.set(switchStates[2], forKey: "alerts")
        }
        DispatchQueue.main.async {
            soundPlay().playClick()
        if sender.tag == 1 {
            musicPlay().playMenuMusic()
        }
        UIView.performWithoutAnimation {
            self.achievementsTV.reloadData()
        }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch pageState {
        case "Achievements" :
            if UIDevice().userInterfaceIdiom == .phone {
                return 150
            } else {
                return 220
            }
        case "LeaderBoard" :
            if UIDevice().userInterfaceIdiom == .phone {
                return 70
            } else {
                return 100
            }
        case "alerts":
            if self.alertTypes[indexPath.row] == "2" {
                if UIDevice().userInterfaceIdiom == .phone {
                    return 350
                } else {
                    return 350
                }
            } else {
                if UIDevice().userInterfaceIdiom == .phone {
                    return 150
                } else {
                    return 150
                }
            }
        case "profile" :
            switch indexPath.row  {
            case 0 :
            if UIDevice().userInterfaceIdiom == .phone {
                return 180
            } else {
                return 240
            }
            case 1 :
                if otherProfile == true {
                    if userButtons == true {
                        if uniqueId == "1" {
                            return 0 
                        } else {
                       if UIDevice().userInterfaceIdiom == .phone {
                            return 50
                        } else {
                           return 50
                        }
                        }
                    } else {
                        return 0
                    }
                } else {
                    return 0
                }
            case 2 :
                if UIDevice().userInterfaceIdiom == .phone {
                    return 280
                } else {
                    return 300
                }
            case 3 :
                if UIDevice().userInterfaceIdiom == .phone {
                    return 135
                } else {
                    return 150
                }
            default :
                if UIDevice().userInterfaceIdiom == .phone {
                    return 1 * (UIScreen.main.bounds.height / 3)
                } else {
                    return 5 * (UIScreen.main.bounds.height / 16)
                }
            }
        default :
            if indexPath.row == 0 {
                if UIDevice().userInterfaceIdiom == .phone {
                    return 60
                } else {
                    return 100
                }
            } else {
                if UIDevice().userInterfaceIdiom == .phone {
                    return 70
                } else {
                    return 90
                }
            }
        }
    }
    
    @objc func selectLeaderBoard(_ sender : UIButton!) {
        profileIndex = sender.tag
        showProfile()
    }
    
    @objc func showProfile(){
        self.performSegue(withIdentifier: "otherProfiles", sender: self)
    }
    
    var profileIndex = Int()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? menuViewController {
            vc.menuState = "profile"
            vc.otherProfiles = true
            vc.oPStadium = (self.res?.response?[profileIndex].stadium!)!
            vc.opName = (self.res?.response?[profileIndex].username!)!
            vc.opAvatar = "\(urlClass.avatar)\((self.res?.response?[profileIndex].avatar!)!)"
            vc.opBadge = "\(urlClass.badge)\((self.res?.response?[profileIndex].badge_name!)!)"
            vc.opID = (self.res?.response?[profileIndex].ref_id!)!
            vc.opCups = (self.res?.response?[profileIndex].cups!)!
            vc.opLevel = (self.res?.response?[profileIndex].level!)!
            vc.opWinCount = (self.res?.response?[profileIndex].win_count!)!
            vc.opCleanSheetCount = (self.res?.response?[profileIndex].clean_sheet_count!)!
            vc.opLoseCount = (self.res?.response?[profileIndex].lose_count!)!
            vc.opMostScores = (self.res?.response?[profileIndex].max_points_gain!)!
            vc.opDrawCount = (self.res?.response?[profileIndex].draw_count!)!
            vc.opMaximumWinCount = (self.res?.response?[profileIndex].max_wins_count!)!
            vc.opMaximumScore = (self.res?.response?[profileIndex].max_point!)!
            vc.uniqueId = (self.res?.response?[profileIndex].id!)!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
