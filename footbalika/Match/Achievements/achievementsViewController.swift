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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                    PubProc.wb.hideWaiting()
                                    PubProc.cV.hideWarning()
                                })
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
    
    
//    @objc func updateConstraint() {
//        UIView.animate(withDuration: 0.5) {
//        if self.leaderBoardState == "TOURNAMENT" {
//            self.achievementLeaderBoardTopConstraint.constant = 80
//            self.achievementsTV.layer.cornerRadius = 10
//        } else {
//            self.achievementLeaderBoardTopConstraint.constant = 40
//        }
//            self.view.layoutIfNeeded()
//        }
//    }
    
    var alertsRes : allAlerts.Response? = nil ;
    
    @objc func alertsJson() {
        PubProc.HandleDataBase.readJson(wsName: "ws_HandleMessages", JSONStr: "{'mode':'READ', 'userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.alertsRes = try JSONDecoder().decode(allAlerts.Response.self , from : data!)
                        
                        DispatchQueue.main.async {
                            self.achievementCount = (self.alertsRes?.response?.count)!
                            self.achievementsTV.reloadData()
                            PubProc.wb.hideWaiting()
                            PubProc.cV.hideWarning()
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
                                PubProc.cV.hideWarning()
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
    }
    
    
    @objc func tournamentSelect() {
        self.tournament.backgroundColor = UIColor.white
        self.leagues.backgroundColor = colors().lightBrownBackGroundColor
        self.predict3Month.backgroundColor = colors().lightBrownBackGroundColor
        self.leaderBoardState = "TOURNAMENT"
        leaderBoardJson()
    }
    
    
    @objc func predict3MonthSelect() {
        self.predict3Month.backgroundColor = UIColor.white
        self.leagues.backgroundColor = colors().lightBrownBackGroundColor
        self.tournament.backgroundColor = colors().lightBrownBackGroundColor
        self.leaderBoardState = "PREDICTION_3MONTH"
        leaderBoardJson()
    }
    
    @objc func reloadingTV(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let isPassword = dict["isPass"] as? Bool{
                if !isPassword {
                    pageState = "profile"
                    otherProfile = false
                    self.profileName = (login.res?.response?.mainInfo?.username)!
                    self.achievementsTV.reloadData()
                }
            }
        }
    }
    
    
    @objc func refreshUserData(notification : Notification) {
        if let userid = notification.userInfo?["userID"] as? String {
            self.otherProfile = true
            getUserInfo(id: (Int(userid)!), isResfresh: true)
        }
       
        }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadingTV(_:)), name: NSNotification.Name(rawValue: "changingUserPassNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUserData(notification:)), name: NSNotification.Name(rawValue: "refreshUsersAfterCancelling"), object: nil)

        self.leagues.addTarget(self, action: #selector(leaguesSelect), for: UIControlEvents.touchUpInside)
        
        self.tournament.addTarget(self, action: #selector(tournamentSelect), for: UIControlEvents.touchUpInside)

        self.predict3Month.addTarget(self, action: #selector(predict3MonthSelect), for: UIControlEvents.touchUpInside)

        self.predict3Month.titleLabel?.adjustsFontSizeToFitWidth = true

        
        if pageState == "LeaderBoard" {
            leaderBoardJson()
            self.leaderBoardState = "MAIN_LEADERBORAD"
            leaguesSelect()
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
            if pageState != "profile" {
            otherProfileJson()
            }
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
            let intProgress = Int((loadingAchievements.res?.response?[indexPath.row].progress)!)!
            if intProgress < 10 {
            if UIDevice().userInterfaceIdiom == .phone {
                cell.progressTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\((loadingAchievements.res?.response?[indexPath.row].progress)!)/10", strokeWidth: -5.0)
                cell.progressTitleForeGround.font = fonts().iPhonefonts
                cell.acievementTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: -7.0)
                cell.acievementTitleForeGround.font = fonts().iPhonefonts
                
            } else {
                cell.progressTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\((loadingAchievements.res?.response?[indexPath.row].progress)!)/10", strokeWidth: -5.0)
                cell.progressTitleForeGround.font = fonts().iPadfonts
                cell.acievementTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: -7.0)
                cell.acievementTitleForeGround.font = fonts().iPadfonts
            }
            cell.progressTitleForeGround.text = "\((loadingAchievements.res?.response?[indexPath.row].progress)!)/10"
            } else {
            
                cell.receiveGift.tag = indexPath.row
                cell.receiveGift.addTarget(self, action: #selector(receivingGift), for: UIControlEvents.touchUpInside)
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.progressTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "دریافت جایزه", strokeWidth: -5.0)
                    cell.progressTitleForeGround.font = fonts().iPhonefonts
                    cell.acievementTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: -7.0)
                    cell.acievementTitleForeGround.font = fonts().iPhonefonts
                    
                } else {
                    cell.progressTitle.AttributesOutLine(font: fonts().iPadfonts, title: "دریافت جایزه", strokeWidth: -5.0)
                    cell.progressTitleForeGround.font = fonts().iPadfonts
                    cell.acievementTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: -7.0)
                    cell.acievementTitleForeGround.font = fonts().iPadfonts
                }
                cell.progressTitleForeGround.text = "دریافت جایزه"

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

            if (self.alertsRes?.response?[indexPath.row].type!)! == "2" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "alertType1Cell", for: indexPath) as! alertType1Cell
                
                cell.alertTitle.text = (self.alertsRes?.response?[indexPath.row].subject!)!
                cell.alertBody.text = (self.alertsRes?.response?[indexPath.row].contents!)!
                cell.alertDate.text = (self.alertsRes?.response?[indexPath.row].p_message_date!)!
                let url = "http://volcan.ir/adelica/images/news/\((self.alertsRes?.response?[indexPath.row].image_path!)!)"
                let urls = URL(string : url)
                cell.alertImage.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "alertTypeChooseCell", for: indexPath) as! alertTypeChooseCell
                
                cell.alertTitle.text = (self.alertsRes?.response?[indexPath.row].username!)!
                cell.alertDate.text = (self.alertsRes?.response?[indexPath.row].p_message_date!)!
                let url = "\(urlClass.avatar)\((self.alertsRes?.response?[indexPath.row].avatar!)!)"
                let urls = URL(string : url)
                cell.userAvatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
                cell.alertBody.text = (self.alertsRes?.response?[indexPath.row].subject!)!
                cell.accept.tag = indexPath.row
                cell.accept.addTarget(self, action: #selector(acceptingGameOrFriend), for: UIControlEvents.touchUpInside)
                cell.cancel.tag = indexPath.row
                cell.cancel.addTarget(self, action: #selector(cancelGameOrFriend), for: UIControlEvents.touchUpInside)
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
                    cell.profileName.AttributesOutLine(font: fonts().iPhonefonts18, title: "\(profileName)", strokeWidth: -4.0)
                    cell.profileId.AttributesOutLine(font: fonts().iPhonefonts, title: "\(profileID)", strokeWidth: -4.0)
                    cell.firstProfileTitleForeGround.font = fonts().iPhonefonts
                } else {
                    cell.firstProfileTitle.AttributesOutLine(font: fonts().iPadfonts, title: "مشخصات بازیکن", strokeWidth: -7.0)
                    cell.profileName.AttributesOutLine(font: fonts().iPadfonts25, title: "\(profileName)", strokeWidth: -4.0)
                    cell.profileId.AttributesOutLine(font: fonts().iPadfonts25, title: "\(profileID)", strokeWidth: -4.0)
                    cell.firstProfileTitleForeGround.font = fonts().iPadfonts
                }
                cell.profileCup.text = profileCups
                cell.profileLevel.text = profileLevel
                
                return cell
                
                
            case 1 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "profileButtonsCell", for: indexPath) as! profileButtonsCell
                
                cell.contentView.backgroundColor = grayColor

                if (login.res?.response?.mainInfo?.id!)! == UserDefaults.standard.string(forKey: "userid") ?? String() && !otherProfile {
                    
                    //userProfile
                    if (login.res?.response?.mainInfo?.status!)! != "2" {
                        //signUp Profile
                        cell.completingProfile.isHidden = false
                        cell.profileCompletingTitle.isHidden = false
                        cell.profileCompletingTitleForeGround.isHidden = false
                        cell.profileCompletingTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "ثبت نام کنید", strokeWidth: -6.0)
                        cell.profileCompletingTitleForeGround.font = fonts().iPhonefonts
                        cell.profileCompletingTitleForeGround.text = "ثبت نام کنید"
                        cell.completingProfile.addTarget(self, action: #selector(signUp), for: UIControlEvents.touchUpInside)
                        cell.cancelFriendship.isHidden = true
                        cell.friendshipRequest.isHidden = true
                        cell.playRequest.isHidden = true
                    } else {
                        
                        //completed Profile
                        cell.completingProfile.isHidden = true
                        cell.cancelFriendship.isHidden = true
                        cell.friendshipRequest.isHidden = true
                        cell.playRequest.isHidden = true
                        cell.profileCompletingTitle.isHidden = true
                        cell.profileCompletingTitleForeGround.isHidden = true
                    }
                    
                } else {
                    
                    //otherProfile
                        if ((login.res?.response?.mainInfo?.is_my_friend!)!) == 1 {
                        //is Friend
                        cell.completingProfile.isHidden = true
                        cell.cancelFriendship.isHidden = false
                        cell.playRequest.isHidden = false
                        cell.friendshipRequest.isHidden = true
                        cell.profileCompletingTitleForeGround.isHidden = true
                        cell.profileCompletingTitle.isHidden = true
                    } else {
                            
                       //is Not Friend
                        cell.completingProfile.isHidden = true
                        cell.cancelFriendship.isHidden = true
                        cell.playRequest.isHidden = true
                        cell.friendshipRequest.isHidden = false
                        cell.profileCompletingTitleForeGround.isHidden = false
                            cell.profileCompletingTitle.isHidden = false
                        cell.profileCompletingTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "درخواست دوستی", strokeWidth: -6.0)
                        cell.profileCompletingTitleForeGround.font = fonts().iPhonefonts
                        cell.profileCompletingTitleForeGround.text = "درخواست دوستی"
                        cell.friendshipRequest.addTarget(self, action: #selector(requestFriendShip) , for: UIControlEvents.touchUpInside)

                    }
                }
                
                cell.playRequest.addTarget(self, action: #selector(playRequestGame), for: UIControlEvents.touchUpInside)
                cell.cancelFriendship.addTarget(self, action: #selector(cancellingFriendShip), for: UIControlEvents.touchUpInside)
                
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
            } else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "changeUserNameAndPasswordCell", for: indexPath) as! changeUserNameAndPasswordCell

                cell.changePassword.addTarget(self, action: #selector(changePass), for: UIControlEvents.touchUpInside)
                cell.changeUserName.addTarget(self, action: #selector(changeUser), for: UIControlEvents.touchUpInside)
                
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
    
    
    @objc func acceptingGameOrFriend(_ sender : UIButton!) {
        if ((self.alertsRes?.response?[sender.tag].type!)!) == "1" {
            // accept friendship Request
            acceptOrRejectFriendShipRequest(mode: "CONFIRM_REQUEST", user1_id: (self.alertsRes?.response?[sender.tag].reciver_id!)!, user2_id: (self.alertsRes?.response?[sender.tag].sender_id!)!, message_id: (self.alertsRes?.response?[sender.tag].id!)!)
            
        } else {
           //accept gameRequest
            
            
            
            
        }
    }
    
    
    @objc func cancelGameOrFriend(_ sender : UIButton!) {
        
        if ((self.alertsRes?.response?[sender.tag].type!)!) == "1" {
            //reject friendship Request
            acceptOrRejectFriendShipRequest(mode: "REJECT_REQUEST", user1_id: (self.alertsRes?.response?[sender.tag].reciver_id!)!, user2_id: (self.alertsRes?.response?[sender.tag].sender_id!)!, message_id: (self.alertsRes?.response?[sender.tag].id!)!)
            
        } else {
            //reject gameRequest
            
            
            
        }
        
    }
    
    @objc func acceptOrRejectFriendShipRequest(mode: String , user1_id : String , user2_id: String , message_id : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleFriends", JSONStr: "{'mode' : '\(mode)' ,'user1_id':'\(user1_id)' , 'user2_id' : '\(user2_id)' , 'message_id' : '\(message_id)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    self.messageRead(id: message_id)
                    
//                    self.collectingItemAchievement = String(data: data!, encoding: String.Encoding.utf8) as String?
//
//                    if ((self.collectingItemAchievement)!).contains("OK") {
//                        self.messageRead()
//                    } else {
//                        self.messageRead()
//                    }
                    
                } else {
                    self.acceptOrRejectFriendShipRequest(mode: mode, user1_id: user1_id, user2_id: user2_id, message_id: message_id)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
    @objc func messageRead(id : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_HandleMessages", JSONStr: "{'mode' : 'SET_READ' ,'message_id':'\(id)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    self.alertsJson()
                    
                } else {
                    self.messageRead(id: id)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
    @objc func cancellingFriendShip() {
        self.stateOfFriendAlert = "cancelFriendlyMatch"
        self.performSegue(withIdentifier: "askForFriendlyMatch", sender: self)
    }
    
    var isPass = Bool()
    @objc func changePass() {
        if (login.res?.response?.mainInfo?.status!)! == "2" {
        self.isPass = true
        self.performSegue(withIdentifier: "changePassAndUser", sender: self)
        }
    }
    
    @objc func changeUser() {
        if (login.res?.response?.mainInfo?.status!)! == "2" {
        self.isPass = false
        self.performSegue(withIdentifier: "changePassAndUser", sender: self)
        }
    }
    
    
    var collectingItemAchievement : String? = nil;

    @objc func achievementReceive(id : Int) {
        PubProc.HandleDataBase.readJson(wsName: "ws_updateAchievements", JSONStr: "{'achievement_id' : '\(id)' ,'userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    self.collectingItemAchievement = String(data: data!, encoding: String.Encoding.utf8) as String?

                    if ((self.collectingItemAchievement)!).contains("OK") {
                        loadingAchievements.init().loadAchievements(userid: loadingViewController.userid, completionHandler: {
                        DispatchQueue.main.async {
                            self.achievementsTV.reloadData()
                            PubProc.wb.hideWaiting()
                            thirdSoundPlay().playCollectItemSound()
                        }
                            })
                    } else {
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                        }
                    }
                } else {
                    self.achievementReceive(id : id)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    @objc func receivingGift(_ sender : UIButton!) {
        print(sender.tag)
        let aId = Int((loadingAchievements.res?.response?[sender.tag].id!)!)
        achievementReceive(id : aId!)
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
            if (self.alertsRes?.response?[indexPath.row].type!)! == "2" {
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
                if self.uniqueId == UserDefaults.standard.string(forKey: "userid") ?? String() && (login.res?.response?.mainInfo?.status!)! == "2"{
                        return 0
                } else {
                    return 50
                }
                } else {
                    if (login.res?.response?.mainInfo?.status!)! == "2"{
                        return 0
                    } else {
                        return 50
                    }
                }
//                if otherProfile == true {
//                    if userButtons == true {
//                        if uniqueId == "\(loadingViewController.userid)" {
//                            return 0
//                        } else {
//                            return 50
//                        }
//                    } else {
//                        return 0
//                    }
//                } else {
//                    if (login.res?.response?.mainInfo?.status!)! != "2" {
//                        return 50
//                    } else {
//                        return 0
//                    }
//                }
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
                return 80
            } else {
                return 120
            }
            
        default :
            if indexPath.row == 0 {
                if UIDevice().userInterfaceIdiom == .phone {
                    return 60
                } else {
                    return 100
                }
                
             } else if indexPath.row == 4 {
                    
                if UIDevice().userInterfaceIdiom == .phone {
                    return 40
                } else {
                    return 50
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
        getUserInfo(id: Int((self.res?.response?[profileIndex].id!)!)!, isResfresh: false)
//        showProfile()
    }
    
    
    @objc func selectedFriend(_ sender : UIButton!) {
        profileIndex = sender.tag
        getUserInfo(id: Int((self.friensRes?.response![profileIndex].friend_id!)!)!, isResfresh: false)
    }
    
    @objc func showProfile() {
        self.performSegue(withIdentifier: "otherProfiles", sender: self)
    }
    
    @objc func getUserInfo(id : Int , isResfresh : Bool) {

        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(id)' , 'load_stadium' : 'false' , 'my_userid' : '\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    //                print(data ?? "")
                    
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        if !isResfresh {
                        self.performSegue(withIdentifier: "otherProfiles", sender: self)
                        } else {
                            self.achievementsTV.reloadData()
                        }
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                        }
                    } catch {
                        self.getUserInfo(id : id, isResfresh: isResfresh)
                        print(error)
                    }
                } else {
                    self.getUserInfo(id : id, isResfresh: isResfresh)
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
            if self.stateOfFriendAlert ==  "askFriendlyMatch" {
            vc.jsonStr = "{'mode':'BATTEL_REQUEST' , 'sender_id' : '\(loadingViewController.userid)' , 'reciver_id' : '\((login.res?.response?.mainInfo?.id!)!)'}"
            vc.alertAcceptLabel = "بلی"
            vc.alertBody = "آیا از درخواست مسابقه اطمینان دارید؟"
            vc.alertTitle = "درخواست مسابقه"
            vc.state = "friendlyMatch"
            } else if self.stateOfFriendAlert == "cancelFriendlyMatch" {
                vc.jsonStr = "{'mode':'CANCEL_FRIEND' , 'user1_id' : '\(loadingViewController.userid)' , 'user2_id' : '\((login.res?.response?.mainInfo?.id!)!)' , 'message_id' : '0'}"
                vc.alertAcceptLabel = "بلی"
                vc.alertBody = "آیا برای لغو دوستی اطمینان دارید؟"
                vc.alertTitle = "فوتبالیکا"
                vc.state = "cancelFrindShip"
                vc.userid = (login.res?.response?.mainInfo?.id!)!
            } else if self.stateOfFriendAlert == "requestFriendShip" {
                vc.jsonStr = "{'mode':'FRIEND_REQUEST' , 'sender_id' : '\(loadingViewController.userid)' , 'reciver_id' : '\((login.res?.response?.mainInfo?.id!)!)'}"
                vc.alertAcceptLabel = "بلی"
                vc.alertBody = "آیا برای ارسال درخواست دوستی اطمینان دارید؟"
                vc.alertTitle = "فوتبالیکا"
                vc.state = "requestFriendShip"
                vc.userid = (login.res?.response?.mainInfo?.id!)!
            } else {
                //no need this will execute in the first line
//                vc.jsonStr = "{'mode':'BATTEL_REQUEST' , 'sender_id' : '\(loadingViewController.userid)' , 'reciver_id' : '\((login.res?.response?.mainInfo?.id!)!)'}"
//                vc.alertAcceptLabel = "بلی"
//                vc.alertBody = "آیا از درخواست مسابقه اطمینان دارید؟"
//                vc.alertTitle = "درخواست مسابقه"
//                vc.state = "friendlyMatch"
            }
        }
        
        if let vc = segue.destination as? changePassAndUserNameViewController {
            vc.isSignUp = self.isSignUp
            vc.isPasswordChange = self.isPass
        }
    }
    
    var isSignUp = Bool()
    @objc func signUp() {
        self.isSignUp = true
        self.pageState = "signUp"
        self.performSegue(withIdentifier: "changePassAndUser", sender: self)
    }
    
    @objc func requestFriendShip() {
        self.stateOfFriendAlert = "requestFriendShip"
        self.performSegue(withIdentifier: "askForFriendlyMatch", sender: self)
    }
    
    var stateOfFriendAlert = String()
    @objc func playRequestGame() {
        self.stateOfFriendAlert = "askFriendlyMatch"
        self.performSegue(withIdentifier: "askForFriendlyMatch", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
