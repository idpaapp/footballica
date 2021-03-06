 //
 //  achievementsViewController.swift
 //  footbalika
 //
 //  Created by Saeed Rahmatolahi on 3/22/1397 AP.
 //  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
 //
 
 import UIKit
 import RealmSwift
 import GoogleSignIn
 import Foundation
 
 protocol menuAlert2ButtonsViewControllerDemoteDelegate : NSObjectProtocol {
    func demoteUser()
    func forceKick()
    func promoteUser()
 }
 
 protocol changePassAndUserNameViewControllerDelegate2 : NSObjectProtocol {
    func getGift()
 }
 
 
 class achievementsViewController : UIViewController , UITableViewDelegate , UITableViewDataSource , GIDSignInUIDelegate , GIDSignInDelegate , menuAlert2ButtonsViewControllerDemoteDelegate , changePassAndUserNameViewControllerDelegate2 {
    
    func getGift() {
        self.delegate?.getSignUpGift()
    }
    
    @IBOutlet weak var leagues: RoundButton!
    @IBOutlet weak var tournament: RoundButton!
    @IBOutlet weak var predict3Month: RoundButton!
    @IBOutlet weak var achievementsTV: UITableView!
    @IBOutlet weak var achievementLeaderBoardTopConstraint: NSLayoutConstraint!
    
    weak var delegate : achievementsViewControllerDelegate!
    var pageState = String()
    var realm : Realm!
    var isClanInvite = false
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
    var userButtons = Bool()
    var leaderBoardState = String()
    var isFriend = Bool()
    
    @objc func leaderBoardJson() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_getLeaderBoard", JSONStr: "{'mode' : '\(self.leaderBoardState)' , 'userid' : '\(matchViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.res = try JSONDecoder().decode(leaderBoard.Response.self , from : data!)
                        
                        DispatchQueue.main.async {
                            self.achievementCount = (self.res?.response?.count)!
                            self.achievementsTV.reloadData()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                if self.achievementCount != 0 {
                                    let indexPath = IndexPath(row: 0, section: 0)
                                    self.achievementsTV.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
                                }
                                PubProc.wb.hideWaiting()
                                PubProc.cV.hideWarning()
                            })
                        }
                    } catch {
                        self.leaderBoardJson()
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
                    self.leaderBoardJson()
                        })
                    }
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
        PubProc.HandleDataBase.readJson(wsName: "ws_HandleMessages", JSONStr: "{'mode':'READ', 'userid':'\(matchViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.alertsRes = try JSONDecoder().decode(allAlerts.Response.self , from : data!)
                        
                        DispatchQueue.main.async {
                            self.achievementCount = (self.alertsRes?.response?.count)!
                            
                            for i in 0...(self.alertsRes?.response?.count)! - 1 {
                                if (self.alertsRes?.response?[i].option_field!)!.contains("") {
                                    
                                } else {
                                    
                                }
                            }
                            UIView.performWithoutAnimation {
                                self.achievementsTV.reloadData()
                            }
                            PubProc.wb.hideWaiting()
                            PubProc.cV.hideWarning()
                        }
                    } catch {
                        self.leaderBoardJson()
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
                    self.leaderBoardJson()
                        })
                    }
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
        PubProc.HandleDataBase.readJson(wsName: "ws_getFriendList", JSONStr: "{'userid': \(matchViewController.userid) }") { data, error in
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
                    self.otherProfileJson()
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
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
        self.leaderBoardState = "PREDICTION_CLANSCORES"
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
                    self.profileName = (self.profileResponse?.response?.mainInfo?.badge_name!)!
                    DispatchQueue.main.async {
                        self.achievementsTV.reloadData()
                        PubProc.wb.hideWaiting()
                    }
                }
            }
        }
    }
    
    
    @objc func refreshUserData(notification : Notification) {
        if let userid = notification.userInfo?["userID"] as? String {
            getUserInfo(id: (Int(userid)!), isResfresh: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try? Realm()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadingTV(_:)), name: NSNotification.Name(rawValue: "changingUserPassNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUserData(notification:)), name: NSNotification.Name(rawValue: "refreshUsersAfterCancelling"), object: nil)
        
        self.leagues.addTarget(self, action: #selector(leaguesSelect), for: UIControlEvents.touchUpInside)
        
        self.tournament.addTarget(self, action: #selector(tournamentSelect), for: UIControlEvents.touchUpInside)
        
        self.predict3Month.addTarget(self, action: #selector(predict3MonthSelect), for: UIControlEvents.touchUpInside)
        
        self.predict3Month.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.achievementsTV.register(UINib(nibName: "profileGroupCell", bundle: nil), forCellReuseIdentifier: "profileGroupCell")
        
        if self.pageState == "friendsList" {
        self.achievementsTV.register(UINib(nibName: "NoFriendInListCell", bundle: nil), forCellReuseIdentifier: "NoFriendInListCell")
        }
        if pageState == "LeaderBoard" {
            self.achievementsTV.register(UINib(nibName: "clanGroupsCell", bundle: nil), forCellReuseIdentifier: "clanGroupsCell")
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
        
        //            if pageState != "profile" {
        //            otherProfileJson()
        //            }
        
        
        switch self.pageState {
        case "Achievements":
            self.achievementsTV.bounces = true
            self.achievementsTV.isScrollEnabled = true
            self.achievementsTV.backgroundColor = .lightColor
        case "LeaderBoard":
            self.achievementsTV.bounces = true
            self.achievementsTV.isScrollEnabled = true
            self.achievementsTV.backgroundColor = .lightColor
        case "alerts":
            self.achievementsTV.bounces = true
            self.achievementsTV.isScrollEnabled = true
            self.achievementsTV.backgroundColor = .lightColor
        case "profile":
            self.achievementsTV.bounces = false
            self.achievementsTV.isScrollEnabled = true
            self.achievementsTV.backgroundColor = .grayColor
        case "friendsList" :
            self.achievementsTV.bounces = true
            self.achievementsTV.isScrollEnabled = true
            self.achievementsTV.backgroundColor = .lightColor
        default:
            self.achievementsTV.bounces = false
            self.achievementsTV.isScrollEnabled = false
            self.achievementsTV.backgroundColor = .lightColor
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
            if self.pageState == "friendsList" {
                if achievementCount == 0 {
                    return 1
                } else {
                    return achievementCount
                }
            } else {
            return achievementCount
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch pageState {
        case "Achievements":
            let cell = tableView.dequeueReusableCell(withIdentifier: "achievementsCell", for: indexPath) as! achievementsCell
            
            if (loadingAchievements.res?.response?[indexPath.row].coin_reward!)! == "0" {
                cell.coinLabel.text = ""
                cell.coinImage.isHidden = true
            } else {
                cell.coinLabel.text = (loadingAchievements.res?.response?[indexPath.row].coin_reward!)!
                cell.coinImage.isHidden = false
            }
            
            if (loadingAchievements.res?.response?[indexPath.row].cash_reward!)! == "0" {
                cell.moneyLabel.text = ""
                cell.moneyImage.isHidden = true
            } else {
                cell.moneyLabel.text = (loadingAchievements.res?.response?[indexPath.row].cash_reward!)!
                cell.moneyImage.isHidden = false
            }
            
            
            
            cell.acievementTitleForeGround.text = "\((loadingAchievements.res?.response?[indexPath.row].title!)!)"
            
            let intProgress = Int((loadingAchievements.res?.response?[indexPath.row].progress)!)!
            
            cell.achievementImage.setImageWithKingFisher(url: "\(urlClass.icons)\((loadingAchievements.res?.response?[indexPath.row].img_logo!)!)")
            
            if intProgress < Int((loadingAchievements.res?.response?[indexPath.row].max_point)!)! {
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.progressTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\((loadingAchievements.res?.response?[indexPath.row].progress)!)/\((loadingAchievements.res?.response?[indexPath.row].max_point)!)", strokeWidth: 5.0)
                    cell.progressTitleForeGround.font = fonts().iPhonefonts
                    cell.acievementTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: 5.0)
                    cell.acievementTitleForeGround.font = fonts().iPhonefonts
                    
                } else {
                    cell.progressTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\((loadingAchievements.res?.response?[indexPath.row].progress)!)/\((loadingAchievements.res?.response?[indexPath.row].max_point)!)", strokeWidth: 5.0)
                    cell.progressTitleForeGround.font = fonts().iPadfonts
                    cell.acievementTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: 5.0)
                    cell.acievementTitleForeGround.font = fonts().iPadfonts
                }
                
                cell.progressTitleForeGround.text = "\((loadingAchievements.res?.response?[indexPath.row].progress)!)/\((loadingAchievements.res?.response?[indexPath.row].max_point)!)"
                
            } else {
                
                cell.receiveGift.tag = indexPath.row
                cell.receiveGift.addTarget(self, action: #selector(receivingGift), for: UIControlEvents.touchUpInside)
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.progressTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "دریافت جایزه", strokeWidth: 8.0)
                    cell.progressTitleForeGround.font = fonts().iPhonefonts
                    cell.acievementTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: 8.0)
                    cell.acievementTitleForeGround.font = fonts().iPhonefonts
                    
                } else {
                    cell.progressTitle.AttributesOutLine(font: fonts().iPadfonts, title: "دریافت جایزه", strokeWidth: 8.0)
                    cell.progressTitleForeGround.font = fonts().iPadfonts
                    cell.acievementTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: 8.0)
                    cell.acievementTitleForeGround.font = fonts().iPadfonts
                }
                cell.progressTitleForeGround.text = "دریافت جایزه"
                
            }
            cell.achievementDesc.text = "\((loadingAchievements.res?.response?[indexPath.row].describtion!)!)"
            let progressAchievement = (Float((loadingAchievements.res?.response?[indexPath.row].progress)!)!) / (Float((loadingAchievements.res?.response?[indexPath.row].max_point)!)!)
            //            print("progress\(progressAchievement)")
            cell.achievementProgress.progress = progressAchievement
            return cell
            
        case "LeaderBoard":
            
            if self.leaderBoardState == "PREDICTION_CLANSCORES" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "clanGroupsCell", for: indexPath) as! clanGroupsCell

                cell.cupImage.image = publicImages().clanCup
                if let url = self.res?.response?[indexPath.row].avatar {
                    cell.clanImage.setImageWithKingFisher(url: urls().clan + "\(url)")
                }
                
                if let clanName = self.res?.response?[indexPath.row].username {
                    cell.clanName.text = clanName
                }
                
                if let clanCups = self.res?.response?[indexPath.row].cups {
                    cell.clanCup.text = clanCups
                }
                
                if let clanMembers = self.res?.response?[indexPath.row].score {
                    cell.clanMembers.text = "\(clanMembers) / 11"
                }
                
                cell.clanSelect.isHidden = false
                cell.clanSelect.tag = indexPath.row
                cell.clanSelect.addTarget(self, action: #selector(selectClan), for: UIControlEvents.touchUpInside)
                
                return cell
            } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "leaderBoardCell", for: indexPath) as! leaderBoardCell
            
            cell.number.text = "\(indexPath.row + 1)"
            cell.playerName.text = "\((self.res?.response?[indexPath.row].username!)!)"
            let url = "\(urlClass.avatar)\((self.res?.response?[indexPath.row].avatar!)!)"
            
            let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
            if realmID.count != 0 {
                let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                cell.avatar.image = UIImage(data: dataDecoded as Data)
            } else {
                cell.avatar.setImageWithKingFisher(url: url)
            }
            
            var url2 = String()
            if self.res?.response?[indexPath.row].badge_name != nil {
                url2 = "\(urlClass.badge)\((self.res?.response?[indexPath.row].badge_name!)!)"
            } else {
                url2 = "\(urlClass.badge)"
            }
            
            let realmID2 = self.realm.objects(tblShop.self).filter("image_path == '\(url2)'")
            if realmID2.count != 0 {
                let dataDecoded:NSData = NSData(base64Encoded: (realmID2.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                cell.playerLogo.image = UIImage(data: dataDecoded as Data)
            } else {
                cell.playerLogo.setImageWithKingFisher(url: url2)
            }
            
            cell.selectLeaderBoard.tag = indexPath.row
            cell.selectLeaderBoard.addTarget(self, action: #selector(selectLeaderBoard), for: UIControlEvents.touchUpInside)
            
            if self.leaderBoardState == "MAIN_LEADERBORAD" {
                cell.cupImage.image = UIImage(named: "ic_cup")
                cell.playerCup.textAlignment = .center
                cell.playerCup.text = "\((self.res?.response?[indexPath.row].cups!)!)"
            } else if self.leaderBoardState == "PREDICTION_CLANSCORES" {
                cell.cupImage.image = UIImage(named: "ic_gem")
                cell.playerCup.textAlignment = .center
                if self.res?.response?[indexPath.row].gem != nil {
                    cell.playerCup.text = "\((self.res?.response?[indexPath.row].gem!)!)"
                }
            } else {
                cell.cupImage.image = UIImage()
                cell.playerCup.textAlignment = .left
                cell.playerCup.text = "\((self.res?.response?[indexPath.row].cups!)!)"
            }
            
            return cell
            
            }
        case "friendsList" :
            
            if achievementCount == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoFriendInListCell", for: indexPath) as! NoFriendInListCell

                cell.noFriendTitle.AttributesOutLine(font: fonts().iPhonefonts18, title: "کسی در لیست دوستان شما وجود ندارد" , strokeWidth: 5.0)
                cell.noFriendTitleForeGround.font = fonts().iPhonefonts18
                cell.noFriendTitleForeGround.text = "کسی در لیست دوستان شما وجود ندارد"
                
                return cell
            } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell
            
            cell.friendName.text = "\((self.friensRes?.response?[indexPath.row].username!)!)"
            let url = "\(urlClass.avatar)\((self.friensRes?.response?[indexPath.row].avatar!)!)"
            
            let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
            if realmID.count != 0 {
                let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                cell.friendAvatar.image = UIImage(data: dataDecoded as Data)
            } else {
                cell.friendAvatar.setImageWithKingFisher(url: url)
            }
            
            
            var url2 = String()
            if self.friensRes?.response?[indexPath.row].badge_name != nil {
                url2 = "\(urlClass.badge)\((self.friensRes?.response?[indexPath.row].badge_name!)!)"
            } else {
                url2 = "\(urlClass.badge)"
            }
            
            if url2 == "http://volcan.ir/adelica/images/badge/" {
                cell.friendLogo.image = UIImage()
            } else {
                let realmID2 = self.realm.objects(tblShop.self).filter("image_path == '\(url2)'")
                //                print(url2)
                if realmID2.count != 0 {
                    let dataDecoded:NSData = NSData(base64Encoded: (realmID2.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    cell.friendLogo.image = UIImage(data: dataDecoded as Data)
                } else {
                    cell.friendLogo.setImageWithKingFisher(url: url2)
                }
            }
            
            cell.selectFriend.tag = indexPath.row
            cell.selectFriendName.tag = indexPath.row
            if isClanInvite {
                cell.selectFriendName.addTarget(self, action: #selector(iviteFriendToClan), for: UIControlEvents.touchUpInside)
                cell.selectFriend.addTarget(self, action: #selector(iviteFriendToClan), for: UIControlEvents.touchUpInside)
            } else {
                cell.selectFriend.addTarget(self, action: #selector(selectedFriend), for: UIControlEvents.touchUpInside)
                cell.selectFriendName.addTarget(self, action: #selector(selectedFriend), for: UIControlEvents.touchUpInside)
            }
            cell.friendCup.text = "\((self.friensRes?.response?[indexPath.row].cups!)!)"
            
            return cell
            }
            
        case "alerts":
            
            if (self.alertsRes?.response?[indexPath.row].type!)! == "2" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "alertType1Cell", for: indexPath) as! alertType1Cell
                
                cell.alertTitle.text = (self.alertsRes?.response?[indexPath.row].subject!)!
                cell.alertBody.text = (self.alertsRes?.response?[indexPath.row].contents!)!
                cell.alertDate.text = (self.alertsRes?.response?[indexPath.row].p_message_date!)!
                let url = "\(urls().news)\((self.alertsRes?.response?[indexPath.row].image_path!)!)"
                
                let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
                if realmID.count != 0 {
                    let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    cell.alertImage.image = UIImage(data: dataDecoded as Data)
                } else {
                    cell.alertImage.setImageWithKingFisher(url: url)
                }
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "alertTypeChooseCell", for: indexPath) as! alertTypeChooseCell
                cell.alertTitle.text = (self.alertsRes?.response?[indexPath.row].username!)!
                cell.alertDate.text = (self.alertsRes?.response?[indexPath.row].p_message_date!)!
                let url = "\(urlClass.avatar)\((self.alertsRes?.response?[indexPath.row].avatar!)!)"
                
                let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
                if realmID.count != 0 {
                    let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    cell.userAvatar.image = UIImage(data: dataDecoded as Data)
                } else {
                    cell.userAvatar.setImageWithKingFisher(url: url)
                }
                
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
                cell.contentView.backgroundColor = .grayColor
                cell.firstProfileTitleForeGround.text = "مشخصات بازیکن"
                
                let url =  "\(urlClass.avatar)\((self.profileResponse?.response?.mainInfo?.avatar!)!)"
                let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
                if realmID.count != 0 {
                    let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    cell.profileAvatar.image = UIImage(data: dataDecoded as Data)
                    if realmID.first?.img_base64 == "" {
                        cell.profileAvatar.setImageWithKingFisher(url: url)
                    }else {}
                } else {
                    cell.profileAvatar.setImageWithKingFisher(url: url)
                }
                
                let url2 = "\(urlClass.badge)\((self.profileResponse?.response?.mainInfo?.badge_name!)!)"
                
                if url2 == "http://volcan.ir/adelica/images/badge/" {
                    cell.profileLogo.image = UIImage()
                } else {
                    let realmID2 = self.realm.objects(tblShop.self).filter("image_path == '\(url2)'")
                    if realmID2.count != 0 {
                        let dataDecoded:NSData = NSData(base64Encoded: (realmID2.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                        cell.profileLogo.image = UIImage(data: dataDecoded as Data)
                        if realmID2.first?.img_base64 == "" {
                            cell.profileLogo.setImageWithKingFisher(url: url2)
                        }else {}
                    } else {
                        cell.profileLogo.setImageWithKingFisher(url: url2)
                    }
                }
                
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.firstProfileTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "مشخصات بازیکن", strokeWidth: 8.0)
                    cell.profileName.AttributesOutLine(font: fonts().iPhonefonts18, title: "\((self.profileResponse?.response?.mainInfo?.username!)!)", strokeWidth: -4.0)
                    cell.profileId.AttributesOutLine(font: fonts().iPhonefonts, title: "\((self.profileResponse?.response?.mainInfo?.ref_id!)!)", strokeWidth: -4.0)
                    cell.firstProfileTitleForeGround.font = fonts().iPhonefonts
                } else {
                    cell.firstProfileTitle.AttributesOutLine(font: fonts().iPadfonts, title: "مشخصات بازیکن", strokeWidth: 8.0)
                    cell.profileName.AttributesOutLine(font: fonts().iPadfonts25, title: "\((self.profileResponse?.response?.mainInfo?.username!)!)", strokeWidth: 4.0)
                    cell.profileId.AttributesOutLine(font: fonts().iPadfonts25, title: "\((self.profileResponse?.response?.mainInfo?.ref_id!)!)", strokeWidth: 4.0)
                    cell.firstProfileTitleForeGround.font = fonts().iPadfonts
                }
                cell.profileCup.text = "\((self.profileResponse?.response?.mainInfo?.cups!)!)"
                cell.profileLevel.text = "\((self.profileResponse?.response?.mainInfo?.level!)!)"
                
                return cell
                
                
            case 1 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "profileButtonsCell", for: indexPath) as! profileButtonsCell
                
                cell.contentView.backgroundColor = .grayColor
                
                if (self.profileResponse?.response?.mainInfo?.id!)! == UserDefaults.standard.string(forKey: "userid") ?? String() {
                    
                    //userProfile
                    if (self.profileResponse?.response?.mainInfo?.status!)! != "2" {
                        //signUp Profile
                        cell.completingProfile.isHidden = false
                        cell.profileCompletingTitle.isHidden = false
                        cell.profileCompletingTitleForeGround.isHidden = false
                        cell.profileCompletingTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "ثبت نام کنید", strokeWidth: 8.0)
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
                    if ((self.profileResponse?.response?.mainInfo?.is_my_friend!)!) == 1 {
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
                        cell.profileCompletingTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "درخواست دوستی", strokeWidth: 8.0)
                        cell.profileCompletingTitleForeGround.font = fonts().iPhonefonts
                        cell.profileCompletingTitleForeGround.text = "درخواست دوستی"
                        cell.friendshipRequest.addTarget(self, action: #selector(requestFriendShip) , for: UIControlEvents.touchUpInside)
                    }
                }
                
                cell.playRequest.addTarget(self, action: #selector(playRequestGame), for: UIControlEvents.touchUpInside)
                cell.cancelFriendship.addTarget(self, action: #selector(cancellingFriendShip), for: UIControlEvents.touchUpInside)
                
                return cell
                
                
            case 2 :
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "profileGroupCell", for: indexPath) as! profileGroupCell
                
                if self.profileResponse?.response?.calnData?.clanMembers != nil {
                    if self.profileResponse?.response?.calnData?.clanMembers?.count != 0 {
                        
                        cell.showGroupButton.action1.addTarget(self, action: #selector(showGroup), for: UIControlEvents.touchUpInside)
                        cell.groupName.text = "\((self.profileResponse?.response?.calnData?.clan_title!)!)"
                        cell.groupImage.setImageWithKingFisher(url: "\(urls().clan)\((self.profileResponse?.response?.calnData?.caln_logo!)!)")
                        cell.cupCountShow.cupCountLabel.text = "\((self.profileResponse?.response?.calnData?.clan_point!)!)"
                        cell.memberRoll.text = (self.profileResponse?.response?.calnData?.clan_roll!)!
                        //User Profile
                        if ((self.profileResponse?.response?.calnData?.clanMembers?.lastIndex(where: {$0.id == matchViewController.userid})) != nil) {
                            cell.promoteDemoteView.isHidden = true
                        } else {
                            //other ClanMember
                            
                            if login.res?.response?.calnData?.clanid != nil {
                                if (self.profileResponse?.response?.calnData?.clanid!)! != (login.res?.response?.calnData?.clanid!)! {
                                    cell.promoteDemoteView.isHidden = true
                                } else {
                                    let profileMemberRoll = Int((login.res?.response?.calnData?.member_roll!)!)
                                    let otherProfileMemberRoll = Int((self.profileResponse?.response?.calnData?.member_roll!)!)
                                    
                                    if profileMemberRoll! / otherProfileMemberRoll! < 1 {
                                        cell.promoteDemoteView.isHidden = false
                                                                               
                                        if otherProfileMemberRoll! == 3 {
                                            
                                            cell.setTitles(demoteTitle : "اخراج از گروه")
                                        } else {
                                            cell.setTitles(demoteTitle : "کاهش سطح")
                                        }
                                        cell.promoteDemoteView.action1.addTarget(self, action: #selector(promote), for: UIControlEvents.touchUpInside)
                                        
                                        cell.promoteDemoteView.action3.addTarget(self, action: #selector(demote), for: UIControlEvents.touchUpInside)
                                    } else {
                                        cell.promoteDemoteView.isHidden = true
                                    }
                                }
                            } else {
                                cell.promoteDemoteView.isHidden = true
                            }
                        }
                    } else {
                        
                    }
                } else {
                    
                }
                return cell
            case 3 :
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "profile2Cell", for: indexPath) as! profile2Cell
                cell.secondProfileTitleForeGround.text = "آمار و نتایج بازی ها"
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.secondProfileTitle.AttributesOutLine(font: fonts().iPhonefonts18, title: "آمار و نتایج بازی ها", strokeWidth: 8.0)
                    cell.secondProfileTitleForeGround.font = fonts().iPhonefonts18
                } else {
                    cell.secondProfileTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "آمار و نتایج بازی ها", strokeWidth: 8.0)
                    cell.secondProfileTitleForeGround.font = fonts().iPadfonts25
                }
                cell.contentView.backgroundColor = .grayColor
                cell.drawCount.text = "\((self.profileResponse?.response?.mainInfo?.draw_count!)!)"
                cell.winCount.text = "\((self.profileResponse?.response?.mainInfo?.win_count!)!)"
                cell.loseCount.text = "\((self.profileResponse?.response?.mainInfo?.lose_count!)!)"
                cell.cleanSheetCount.text = "\((self.profileResponse?.response?.mainInfo?.clean_sheet_count!)!)"
                cell.mostScores.text = "\((self.profileResponse?.response?.mainInfo?.max_wins_count!)!)"
                return cell
                
            case 4 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "profile3Cell", for: indexPath) as! profile3Cell
                cell.contentView.backgroundColor = .grayColor
                cell.maximumScores.text = "\((self.profileResponse?.response?.mainInfo?.max_point!)!)"
                cell.maximumWinCount.text = "\((self.profileResponse?.response?.mainInfo?.max_wins_count!)!)"
                cell.thirdProfileTitleForeGround.text = "آمار و نتایج جام های حذفی"
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.thirdProfileTitle.AttributesOutLine(font: fonts().iPhonefonts18, title: "آمار و نتایج جام های حذفی", strokeWidth: 8.0)
                    cell.thirdProfileTitleForeGround.font = fonts().iPhonefonts18
                } else {
                    cell.thirdProfileTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "آمار و نتایج جام های حذفی", strokeWidth: 8.0)
                    cell.thirdProfileTitleForeGround.font = fonts().iPadfonts25
                }
                return cell
                
            default :
                let cell = tableView.dequeueReusableCell(withIdentifier: "profile4Cell", for: indexPath) as! profile4Cell
                cell.contentView.backgroundColor = .grayColor
                cell.fourthProfileTitleForeGround.text = "استادیوم"
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.fourthProfileTitle.AttributesOutLine(font: fonts().iPhonefonts18, title: "استادیوم", strokeWidth: 8.0)
                    cell.fourthProfileTitleForeGround.font = fonts().iPhonefonts18
                } else {
                    cell.fourthProfileTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "استادیوم", strokeWidth: 8.0)
                    cell.fourthProfileTitleForeGround.font = fonts().iPadfonts25
                }
                
                let url = "\(urlClass.stadium)\((self.profileResponse?.response?.mainInfo?.stadium!)!)"
                print(url)
                let realmID = self.realm.objects(tblStadiums.self).filter("img_logo == '\(url)'")
                if realmID.count != 0 {
                    let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    cell.stadiumImage.image = UIImage(data: dataDecoded as Data)
                    if realmID.first?.img_base64 == "" {
                        cell.stadiumImage.setImageWithKingFisher(url: url)
                    } else {}
                } else {
                    cell.stadiumImage.setImageWithKingFisher(url: url)
                }
                return cell
            }
            
        default:
            if indexPath.row == 0 {
                
                
                if (login.res?.response?.mainInfo?.email!)!.contains("@gmail.com") {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "googleSignOutCell", for: indexPath) as! googleSignOutCell
                    
                    if UIDevice().userInterfaceIdiom == .phone {
                        cell.userEmail.AttributesOutLine(font: fonts().iPhonefonts, title: "\((login.res?.response?.mainInfo?.email!)!)", strokeWidth: 8.0)
                        cell.userEmailForeGround.font = fonts().iPhonefonts
                    } else {
                        cell.userEmail.AttributesOutLine(font: fonts().iPadfonts, title: "\((login.res?.response?.mainInfo?.email!)!)", strokeWidth: 8.0)
                        cell.userEmailForeGround.font = fonts().iPadfonts
                    }
                    
                    cell.userEmailForeGround.text = "\((login.res?.response?.mainInfo?.email!)!)"
                    
                    cell.signOut.addTarget(self, action: #selector(googleSigningOut), for: UIControlEvents.touchUpInside)
                    
                    return cell
                    
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "googleEntranceCell", for: indexPath) as! googleEntranceCell
                    
                    cell.googleSignIn.addTarget(self, action: #selector(googleSigningIn), for: UIControlEvents.touchUpInside)
                    
                    
                    return cell
                }
                
            } else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "changeUserNameAndPasswordCell", for: indexPath) as! changeUserNameAndPasswordCell
                
                cell.changePassword.addTarget(self, action: #selector(changePass), for: UIControlEvents.touchUpInside)
                cell.changeUserName.addTarget(self, action: #selector(changeUser), for: UIControlEvents.touchUpInside)
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! settingsCell
                
                if UIDevice().userInterfaceIdiom == .phone {
                    cell.settingLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(settingsTitle[indexPath.row - 1])", strokeWidth: 8.0)
                    cell.settingLabelForeGround.font = fonts().iPhonefonts
                } else {
                    cell.settingLabel.AttributesOutLine(font: fonts().iPadfonts, title: "\(settingsTitle[indexPath.row - 1])", strokeWidth: 8.0)
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
    
    @objc func selectClan(_ sender : UIButton!) {
        if pageState == "LeaderBoard" {
            if self.leaderBoardState == "PREDICTION_CLANSCORES" {
                if let id = self.res?.response?[sender.tag].id {
                    self.clanId = id
                    self.isComeFromGropPage = false
                    self.performSegue(withIdentifier: "showProfileGroup", sender: self)
                }
            }
        }
    }
    
    @objc func showGroup() {
        self.clanId = (self.profileResponse?.response?.calnData?.clanid!)!
        self.performSegue(withIdentifier: "showProfileGroup", sender: self)
    }
    
    @objc func promote() {
        self.stateOfFriendAlert = "PromoteUser"
        self.performSegue(withIdentifier: "askForFriendlyMatch", sender: self)
    }
    
    func promoteUser() {
        promoteMember().promote(dest_user_id: (self.profileResponse?.response?.mainInfo?.id!)!,
            completionHandler: {String in
                print(String)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.delegate?.dismissing()
                self.delegate?.updateClanData()
                })
        })
    }
    
    @objc func demote() {
        self.stateOfFriendAlert = "DemoteUser"
        self.performSegue(withIdentifier: "askForFriendlyMatch", sender: self)
    }
    
    func forceKick() {
        demoteMember().forceKickMember(dest_user_id: (self.profileResponse?.response?.mainInfo?.id!)!, completionHandler: {String in
            print(String)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.delegate?.dismissing()
                self.delegate?.updateClanData()
            })
    })
    }
    
    func demoteUser() {
        if ((self.profileResponse?.response?.calnData?.member_roll!)!) == "3" {
            demoteMember().kickMember(dest_user_id: (self.profileResponse?.response?.mainInfo?.id!)!, completionHandler: {String in
                print(String)
                if String == "USER_IN_AN_ACTIVE_WAR" {
                    self.stateOfFriendAlert = "ForceDemoteUser"
                    self.performSegue(withIdentifier: "askForFriendlyMatch", sender: self)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.delegate?.dismissing()
                    self.delegate?.updateClanData()
                    })
                }
            })
        } else {
            demoteMember().demoteMember(dest_user_id: (self.profileResponse?.response?.mainInfo?.id!)!, completionHandler: {String in
                print(String)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.delegate?.dismissing()
                self.delegate?.updateClanData()
                })
            })
        }
    }
    
    var reciverInvitationGroupId = String()
    @objc func iviteFriendToClan(_ sender : UIButton!) {
        self.stateOfFriendAlert = "inviteClan"
        self.reciverInvitationGroupId = (self.friensRes?.response?[sender.tag].id!)!
        self.performSegue(withIdentifier: "askForFriendlyMatch", sender: self)
    }
    
    @objc func googleSigningIn() {
        PubProc.wb.showWaiting()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            DispatchQueue.main.async {
                PubProc.wb.hideWaiting()
            }
        } else {
            self.view.isUserInteractionEnabled = false
            // Perform any operations on signed in user here.
            let email = user.profile.email
            GoogleSigningIn(email : email!)
        }
    }
    
    @objc func GoogleSigningIn(email : String) {
        PubProc.isSplash = false
        PubProc.wb.hideWaiting()
        signInOrOut(mode: "AddEmail", email: email)
        
    }
    
    @objc func signInOrOut(mode : String , email : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_updtUser", JSONStr: "{'mode' : '\(mode)' , 'email' : '\(email)' , 'userid' : '\(matchViewController.userid)'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                let res = String(data: data!, encoding: String.Encoding.utf8)
                
               
                login.init().loging(userid: matchViewController.userid, rest: false, completionHandler: {
                    DispatchQueue.main.async {
                        
                        if res!.contains("OK") {
                            
                            
                            
                            
                        } else if res!.contains("EMAIL_CONNECTED_BEFORE") {
                            
                            
                            
                            
                        } else if res!.contains("EMAIL_IS_EXISTS") {
                            
                            
                            
                            
                        }
                        PubProc.wb.hideWaiting()
                        self.dismiss(animated: true, completion: nil)
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("changingUserPassNotification"), object: nil , userInfo : nil)
                    }
                })
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
                self.signInOrOut(mode: mode , email : email)
                    })
                }
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
    }
    
    @objc func googleSigningOut() {
        GIDSignIn.sharedInstance().signOut()
        signInOrOut(mode: "AddEmail", email: "")
        //google SingnOut
    }
    
    @objc func acceptingGameOrFriend(_ sender : UIButton!) {
        if ((self.alertsRes?.response?[sender.tag].type!)!) == "1" {
            // accept friendship Request
            acceptOrRejectFriendShipRequest(mode: "CONFIRM_REQUEST", user1_id: (self.alertsRes?.response?[sender.tag].reciver_id!)!, user2_id: (self.alertsRes?.response?[sender.tag].sender_id!)!, message_id: (self.alertsRes?.response?[sender.tag].id!)!)
            
        } else  if ((self.alertsRes?.response?[sender.tag].type!)!) == "5" {
            if login.res?.response?.calnData?.clanid != nil {
            self.acceptOrRejectClanRequest(mode: "JOIN_ON_REQUEST", user_id: "\(((self.alertsRes?.response?[sender.tag].sender_id!)!))", clan_id: "\(((login.res?.response?.calnData?.clanid!)!))")
            }
        } else {
            //accept gameRequest
            acceptFriendlyMatch(userid: (self.alertsRes?.response?[sender.tag].reciver_id!)!, friendid: (self.alertsRes?.response?[sender.tag].sender_id!)!, massageId: (self.alertsRes?.response?[sender.tag].id!)!)
        }
    }
    
    @objc func cancelGameOrFriend(_ sender : UIButton!) {
        if ((self.alertsRes?.response?[sender.tag].type!)!) == "5" {
            if login.res?.response?.calnData?.clanid != nil {
            self.acceptOrRejectClanRequest(mode: "REJECT_JOIN", user_id: "\(((self.alertsRes?.response?[sender.tag].sender_id!)!))", clan_id: "\(((login.res?.response?.calnData?.clanid!)!))")
            }
        } else {
            //reject friendship Request & reject gameRequest
            acceptOrRejectFriendShipRequest(mode: "REJECT_REQUEST", user1_id: (self.alertsRes?.response?[sender.tag].reciver_id!)!, user2_id: (self.alertsRes?.response?[sender.tag].sender_id!)!, message_id: (self.alertsRes?.response?[sender.tag].id!)!)
        }
    }
    
    @objc func acceptOrRejectClanRequest(mode: String , user_id : String , clan_id: String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : '\(mode)' ,'user_id':'\(user_id)' , 'clan_id' : '\(clan_id)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    print(String(data: data!, encoding: String.Encoding.utf8)!)
                    //                print(data ?? "")
                    
                    self.alertsJson()
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
                    self.acceptOrRejectClanRequest(mode: mode, user_id: user_id, clan_id: clan_id)
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    @objc func acceptFriendlyMatch(userid: String , friendid: String , massageId : String) {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_UpdateGameResult", JSONStr: "{'mode' : 'START_FRIENDLY_GAME' ,'userid':'\(userid)' , 'friendid' : '\(friendid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    print((String(data: data!, encoding: String.Encoding.utf8) as String?)!)
                    
                    
                    self.messageRead(id: massageId, matchID: (String(data: data!, encoding: String.Encoding.utf8) as String?)!)
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
                    self.acceptFriendlyMatch(userid: userid, friendid: friendid, massageId: massageId)
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
        
    }
    
    @objc func acceptOrRejectFriendShipRequest(mode: String , user1_id : String , user2_id: String , message_id : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleFriends", JSONStr: "{'mode' : '\(mode)' ,'user1_id':'\(user1_id)' , 'user2_id' : '\(user2_id)' , 'message_id' : '\(message_id)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    self.alertsJson()
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
                    self.acceptOrRejectFriendShipRequest(mode: mode, user1_id: user1_id, user2_id: user2_id, message_id: message_id)
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
    @objc func messageRead(id : String , matchID : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_HandleMessages", JSONStr: "{'mode' : 'SET_READ' ,'message_id':'\(id)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    //                    self.alertsJson()
                    
                    DispatchQueue.main.async {
                        PubProc.wb.hideWaiting()
                    }
                    if matchID.contains("UNFINISHED_MATCH") {
                        self.dismiss(animated: false, completion: nil)
                    } else {
                        let info : [String : String] = ["matchID" : matchID]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startNewMatch"), object: nil, userInfo: info)
                        self.dismiss(animated: false, completion: nil)
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
                    self.messageRead(id: id, matchID: matchID)
                        })
                    }
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
    
    
    //    var collectingItemAchievement : String? = nil;
    //
    //    @objc func achievementReceive(id : Int) {
    //        PubProc.HandleDataBase.readJson(wsName: "ws_updateAchievements", JSONStr: "{'achievement_id' : '\(id)' ,'userid':'\(loadingViewController.userid)'}") { data, error in
    //            DispatchQueue.main.async {
    //
    //                if data != nil {
    //
    //                    //                print(data ?? "")
    //                    DispatchQueue.main.async {
    //                        PubProc.cV.hideWarning()
    //                    }
    //
    //                    self.collectingItemAchievement = String(data: data!, encoding: String.Encoding.utf8) as String?
    //
    //                    print(((self.collectingItemAchievement)!))
    //                    if ((self.collectingItemAchievement)!).contains("OK") {
    //                        loadingAchievements.init().loadAchievements(userid: loadingViewController.userid, rest: false, completionHandler: {
    //                            DispatchQueue.main.async {
    //                                self.achievementsTV.reloadData()
    //                                PubProc.wb.hideWaiting()
    //                                thirdSoundPlay().playCollectItemSound()
    //                            }
    //                        })
    //                    } else {
    //                        DispatchQueue.main.async {
    //                            PubProc.wb.hideWaiting()
    //                        }
    //                    }
    //                } else {
    //                    self.achievementReceive(id : id)
    //                    print("Error Connection")
    //                    print(error as Any)
    //                    // handle error
    //                }
    //            }
    //            }.resume()
    //    }
    
    @objc func receivingGift(_ sender : UIButton!) {
        let aId = Int((loadingAchievements.res?.response?[sender.tag].id!)!)
        achievementsReceive().achievementReceive(id : aId!, completionHandler: {
            self.achievementsTV.reloadData()
        })
    }
    
    var profileName = String()
    
    
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
                } else if self.leaderBoardState == "PREDICTION_CLANSCORES" {
                    return 70
                } else {
                    return 70
                }
            } else {
                return 100
            }
        case "alerts":
            if (self.alertsRes?.response?[indexPath.row].type!)! == "2" {
                if UIDevice().userInterfaceIdiom == .phone {
                    //                    return 350
                    return UITableViewAutomaticDimension
                } else {
                    //                    return 350
                    return UITableViewAutomaticDimension
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
                
                if self.profileResponse?.response?.mainInfo?.id == UserDefaults.standard.string(forKey: "userid") ?? String() && (profileResponse?.response?.mainInfo?.status!)! == "2"{
                    return 0
                } else {
                    return 50
                }
                
            case 2 :
                if self.profileResponse?.response?.calnData?.clanMembers != nil {
                    if self.profileResponse?.response?.calnData?.clanMembers?.count != 0 {
                        return 200
                    } else {
                        return 0
                    }
                } else {
                    return 0
                }
            case 3 :
                if UIDevice().userInterfaceIdiom == .phone {
                    return 280
                } else {
                    return 300
                }
            case 4 :
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
                
                if (login.res?.response?.mainInfo?.email_connected!)! != "1" {
                    if UIDevice().userInterfaceIdiom == .phone {
                        return 60
                    } else {
                        return 100
                    }
                } else {
                    if UIDevice().userInterfaceIdiom == .phone {
                        return 120
                    } else {
                        return 160
                    }
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
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(id)' , 'load_stadium' : 'false' , 'my_userid' : '\(matchViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    
                    if String(id) == matchViewController.userid {
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
                        do {
                            
                            login.res2 = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
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
                    self.getUserInfo(id : id, isResfresh: isResfresh)
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
    var profileResponse : loginStructure.Response? = nil
    var profileIndex = Int()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? menuViewController {
            vc.menuState = "profile"
            vc.profileResponse = login.res2
        }
        
        if let vc = segue.destination as? menuAlert2ButtonsViewController {
            if self.stateOfFriendAlert ==  "askFriendlyMatch" {
                vc.jsonStr = "{'mode':'BATTEL_REQUEST' , 'sender_id' : '\(matchViewController.userid)' , 'reciver_id' : '\((profileResponse?.response?.mainInfo?.id!)!)'}"
                vc.alertAcceptLabel = "بلی"
                vc.alertBody = "آیا از درخواست مسابقه اطمینان دارید؟"
                vc.alertTitle = "درخواست مسابقه"
                vc.state = "friendlyMatch"
            } else if self.stateOfFriendAlert == "cancelFriendlyMatch" {
                vc.jsonStr = "{'mode':'CANCEL_FRIEND' , 'user1_id' : '\(matchViewController.userid)' , 'user2_id' : '\((profileResponse?.response?.mainInfo?.id!)!)' , 'message_id' : '0'}"
                vc.alertAcceptLabel = "بلی"
                vc.alertBody = "آیا برای لغو دوستی اطمینان دارید؟"
                vc.alertTitle = "فوتبالیکا"
                vc.state = "cancelFrindShip"
                vc.userid = (login.res?.response?.mainInfo?.id!)!
            } else if self.stateOfFriendAlert == "requestFriendShip" {
                vc.jsonStr = "{'mode':'FRIEND_REQUEST' , 'sender_id' : '\(matchViewController.userid)' , 'reciver_id' : '\((profileResponse?.response?.mainInfo?.id!)!)'}"
                vc.alertAcceptLabel = "بلی"
                vc.alertBody = "آیا برای ارسال درخواست دوستی اطمینان دارید؟"
                vc.alertTitle = "فوتبالیکا"
                vc.state = "requestFriendShip"
                vc.userid = (profileResponse?.response?.mainInfo?.id!)!
                
            } else if self.stateOfFriendAlert == "inviteClan" {
                vc.jsonStr = "{'mode':'SEND_INVENTATION' , 'sender_id' : '\(matchViewController.userid)' , 'reciver_id' : '\(self.reciverInvitationGroupId)' , 'clan_id' : '\((login.res?.response?.calnData?.clanid!)!)'}"
                vc.alertAcceptLabel = "بلی"
                vc.alertBody = "آیا برای ارسال دعوتنامه اطمینان دارید؟"
                vc.alertTitle = "فوتبالیکا"
                vc.state = "clanInviteFriend"
            } else if self.stateOfFriendAlert == "DemoteUser" {
                vc.alertAcceptLabel = "بلی"
                vc.alertBody = "آیا برای کاهش سطح کاربر اطمینان دارید؟"
                vc.alertTitle = "فوتبالیکا"
                vc.state = "DemoteUser"
                vc.demoteKickDelegate = self
                
            } else if self.stateOfFriendAlert == "ForceDemoteUser" {
                vc.alertAcceptLabel = "بلی"
                vc.alertBody = "گاربر در بازی گروهی است آیا برای کاهش سطح اطمینان دارید؟"
                vc.alertTitle = "فوتبالیکا"
                vc.state = "ForceDemoteUser"
                vc.demoteKickDelegate = self
                
            } else if self.stateOfFriendAlert == "PromoteUser" {
                vc.alertAcceptLabel = "بلی"
                vc.alertBody = "آیا برای ارتقاء سطح کاربر اطمینان دارید؟"
                vc.alertTitle = "فوتبالیکا"
                vc.state = "PromoteUser"
                vc.demoteKickDelegate = self                
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
            vc.changeUserPassDelegate2 = self
        }
        
        if let vc = segue.destination as? groupDetailViewController {
            vc.id = self.clanId
            vc.isComeFromProfile = true
            vc.isComeFromGropPage = self.isComeFromGropPage
        }
    }
    
    var isComeFromGropPage = true
    var clanId = String()
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
