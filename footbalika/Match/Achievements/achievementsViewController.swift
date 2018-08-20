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

    @IBOutlet weak var leagues: RoundButton!
    
    @IBOutlet weak var tournament: RoundButton!
    
    @IBOutlet weak var predict3Month: RoundButton!
    
    @IBOutlet weak var achievementsTV: UITableView!
    
    @IBOutlet weak var achievementLeaderBoardTopConstraint: NSLayoutConstraint!
    
    var pageState = String()
    
//    var waitingClass = waitingBall()
    
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
    var otherProfile = Bool()
    var userButtons = Bool()
    var leaderBoardState = String()
    var isFriend = Bool()
//    let waitingCB = waiting().showWaiting()
    
    @objc func leaderBoardJson() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_getLeaderBoard", JSONStr: "{'mode' : '\(self.leaderBoardState)' , 'userid' : '\(loadingViewController.userid)'}") { data, error in
                DispatchQueue.main.async {
                    
                    if data != nil {
                        
                        //                print(data ?? "")
                        
                        do {
                            
                            self.res = try JSONDecoder().decode(leaderBoard.Response.self , from : data!)
                            
                            DispatchQueue.main.async {
                                self.achievementCount = (self.res?.response?.count)!
                                self.achievementsTV.reloadData()
                                PubProc.wb.hideWaiting()
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
                            PubProc.wb.hideWaiting()
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
                            PubProc.wb.hideWaiting()
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

    
    
    @objc func leaguesSelect() {
        self.leagues.backgroundColor = UIColor.white
        self.tournament.backgroundColor = colors().lightBrownBackGroundColor
        self.predict3Month.backgroundColor = colors().lightBrownBackGroundColor
        self.leaderBoardState = "MAIN_LEADERBORAD"
        leaderBoardJson()
//        wb.showWaiting()
    }
    
    
    @objc func tournamentSelect() {
        self.tournament.backgroundColor = UIColor.white
        self.leagues.backgroundColor = colors().lightBrownBackGroundColor
        self.predict3Month.backgroundColor = colors().lightBrownBackGroundColor
        self.leaderBoardState = "TOURNAMENT"
        leaderBoardJson()
//        wb.showWaiting()
    }
    
    
    @objc func predict3MonthSelect() {
        self.predict3Month.backgroundColor = UIColor.white
        self.leagues.backgroundColor = colors().lightBrownBackGroundColor
        self.tournament.backgroundColor = colors().lightBrownBackGroundColor
        self.leaderBoardState = "PREDICTION_3MONTH"
        leaderBoardJson()
//        wb.showWaiting()
    }
    
    
//    let wb = waitingBall()
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.waitingCB
//        wb.showWaiting()
        
        self.leagues.addTarget(self, action: #selector(leaguesSelect), for: UIControlEvents.touchUpInside)
        
        self.tournament.addTarget(self, action: #selector(tournamentSelect), for: UIControlEvents.touchUpInside)

        self.predict3Month.addTarget(self, action: #selector(predict3MonthSelect), for: UIControlEvents.touchUpInside)

        self.predict3Month.titleLabel?.adjustsFontSizeToFitWidth = true

        
        if pageState == "LeaderBoard" {
            leaderBoardJson()
            self.leaderBoardState = "MAIN_LEADERBORAD"
            achievementLeaderBoardTopConstraint.constant = 40
            self.achievementsTV.layer.cornerRadius = 10
        } else {
           achievementLeaderBoardTopConstraint.constant = 0
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
        case "friendsList" :
            self.achievementsTV.bounces = true
            self.achievementsTV.isScrollEnabled = true
            self.achievementsTV.backgroundColor = lightColor
        default:
            self.achievementsTV.bounces = false
            self.achievementsTV.isScrollEnabled = false
            self.achievementsTV.backgroundColor = lightColor
        }
    }
    
    var achievementCount = Int()
    var achievementsProgress = [Float]()
    var achievementsTitles = [String]()
    var friensRes : friendList.Response? = nil
    
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
            cell.playerName.text = "\((self.res?.response?[indexPath.row].username!)!)"
            let url = "\(urlClass.avatar)\((self.res?.response?[indexPath.row].avatar!)!)"
            let urls = URL(string : url)
            cell.avatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
            var url2 = String()
            if self.res?.response?[indexPath.row].badge_name != nil {
            url2 = "\(urlClass.badge)\((self.res?.response?[indexPath.row].badge_name!)!)"
            } else {
            url2 = "\(urlClass.badge)"
            }
            let urls2 = URL(string : url2)
            cell.playerLogo.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
            cell.selectLeaderBoard.tag = indexPath.row
            cell.selectLeaderBoard.addTarget(self, action: #selector(selectLeaderBoard), for: UIControlEvents.touchUpInside)
            
            if self.leaderBoardState == "MAIN_LEADERBORAD" {
             cell.cupImage.image = UIImage(named: "ic_cup")
             cell.playerCup.textAlignment = .center
            cell.playerCup.text = "\((self.res?.response?[indexPath.row].cups!)!)"
            } else if self.leaderBoardState == "TOURNAMENT" {
               cell.cupImage.image = UIImage(named: "ic_gem")
               cell.playerCup.textAlignment = .center
               cell.playerCup.text = "\((self.res?.response?[indexPath.row].gem!)!)"
            } else {
                cell.cupImage.image = UIImage()
                cell.playerCup.textAlignment = .left
                cell.playerCup.text = "\((self.res?.response?[indexPath.row].cups!)!)"
            }
            
            
            return cell
            
            
        case "friendsList" :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell
            
            cell.friendName.text = "\((self.friensRes?.response?[indexPath.row].username!)!)"
            let url = "\(urlClass.avatar)\((self.friensRes?.response?[indexPath.row].avatar!)!)"
            let urls = URL(string : url)
            cell.friendAvatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
            var url2 = String()
            if self.res?.response?[indexPath.row].badge_name != nil {
                url2 = "\(urlClass.badge)\((self.friensRes?.response?[indexPath.row].badge_name!)!)"
            } else {
                url2 = "\(urlClass.badge)"
            }
            let urls2 = URL(string : url2)
            cell.friendLogo.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
            
            cell.selectFriend.tag = indexPath.row
            cell.selectFriend.addTarget(self, action: #selector(selectedFriend), for: UIControlEvents.touchUpInside)
            cell.selectFriendName.tag = indexPath.row
            cell.selectFriendName.addTarget(self, action: #selector(selectedFriend), for: UIControlEvents.touchUpInside)
            
                cell.friendCup.text = "\((self.friensRes?.response?[indexPath.row].cups!)!)"
            
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
                        if self.isFriend {
                            cell.cancelFriendship.isHidden = false
                            cell.friendshipRequest.isHidden = true
                            cell.playRequest.isHidden = false
                        } else {
                        if uniqueId ==  "\(loadingViewController.userid)" {
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
                
                cell.playRequest.addTarget(self, action: #selector(playRequestGame), for: UIControlEvents.touchUpInside)
                
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
                if self.leaderBoardState == "MAIN_LEADERBORAD" {
                   return 70
                } else if self.leaderBoardState == "TOURNAMENT" {
                    return 100
                } else {
                   return 70
                }
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
            
        case "friendsList" :
            if UIDevice().userInterfaceIdiom == .phone {
                return 60
            } else {
                return 100
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
    
    @objc func selectedFriend(_ sender : UIButton!) {
        profileIndex = sender.tag
        getUserInfo(id: Int((self.friensRes?.response![profileIndex].friend_id!)!)!)
    }
    
    @objc func showProfile(){
        self.performSegue(withIdentifier: "otherProfiles", sender: self)
    }
    
    @objc func getUserInfo(id : Int) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(id)' , 'load_stadium' : 'false'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        self.performSegue(withIdentifier: "otherProfiles", sender: self)
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                        }
                    } catch {
                        self.getUserInfo(id : id)
                        print(error)
                    }
                } else {
                    self.getUserInfo(id : id)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    var profileIndex = Int()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? menuViewController {
            if pageState != "friendsList" {
            vc.isFriend = self.isFriend
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
            } else {
                vc.menuState = "profile"
                vc.isFriend = true
                vc.otherProfiles = true
                vc.oPStadium = (login.res?.response?.mainInfo?.stadium!)!
                vc.opName = (login.res?.response?.mainInfo?.username!)!
                vc.opAvatar = "\(urlClass.avatar)\((login.res?.response?.mainInfo?.avatar!)!)"
                vc.opBadge = "\(urlClass.badge)\((login.res?.response?.mainInfo?.badge_name!)!)"
                vc.opID = (login.res?.response?.mainInfo?.ref_id!)!
                vc.opCups = (login.res?.response?.mainInfo?.cups!)!
                vc.opLevel = (login.res?.response?.mainInfo?.level!)!
                vc.opWinCount = (login.res?.response?.mainInfo?.win_count!)!
                vc.opCleanSheetCount = (login.res?.response?.mainInfo?.clean_sheet_count!)!
                vc.opLoseCount = (login.res?.response?.mainInfo?.lose_count!)!
                vc.opMostScores = (login.res?.response?.mainInfo?.max_points_gain!)!
                vc.opDrawCount = (login.res?.response?.mainInfo?.draw_count!)!
                vc.opMaximumWinCount = (login.res?.response?.mainInfo?.max_wins_count!)!
                vc.opMaximumScore = (login.res?.response?.mainInfo?.max_point!)!
                vc.uniqueId = (login.res?.response?.mainInfo?.id!)!
            }
        }
        
        if let vc = segue.destination as? menuAlert2ButtonsViewController {
            vc.jsonStr = "{'mode':'BATTEL_REQUEST' , 'sender_id' : '\(loadingViewController.userid)' , 'reciver_id' : '\((login.res?.response?.mainInfo?.id!)!)'}"
            vc.alertAcceptLabel = "بلی"
            vc.alertBody = "آیا از درخواست مسابقه اطمینان دارید؟"
            vc.alertTitle = "درخواست مسابقه"
            vc.state = "friendlyMatch"
        }
    }
    
    
    @objc func playRequestGame() {
        self.performSegue(withIdentifier: "askForFriendlyMatch", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}