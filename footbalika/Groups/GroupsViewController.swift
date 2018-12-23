//
//  GroupsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import RealmSwift

protocol helpViewControllerDelegate2 {
    func finishTutorial()
}

protocol clanGroupsViewControllerDelegate{
    func showGroupInfo(id : String)
    func clanJoinded()
    func showProfile(id : String , isGroupDetailUser : Bool , completionHandler : @escaping () -> Void)
    func showFinishedWarResault(id : String)
}

protocol groupDetailViewControllerDelegate {
    func joinOrLeaveGroup(state : String , clan_id : String)
    func updateGroupInfo(id : String)
    func showProfile(id : String , isGroupDetailUser : Bool, completionHandler : @escaping () -> Void)
}

protocol groupMatchViewControllerDelegate {
    func showRewards(rewardItems : warRewards.reward)
}

class GroupsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , searchFriendsCellDelegate , helpViewControllerDelegate2 , clanGroupsViewControllerDelegate , groupDetailViewControllerDelegate , groupMatchViewControllerDelegate {
    
    var rewardItems : warRewards.reward? = nil
    
    func showRewards(rewardItems : warRewards.reward) {
        self.rewardItems = rewardItems
        self.performSegue(withIdentifier: "showClanRewardsItem", sender: self)
    }
    
    
    func showProfile(id : String , isGroupDetailUser : Bool , completionHandler : @escaping () -> Void) {
        self.getProfile(userid : id, isGroupDetail: isGroupDetailUser, completionHandler: {
            completionHandler()
        })
    }
    
    var matchResaultres : getActiveWar.Response? = nil
    func showFinishedWarResault(id : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'GET_WAR' , 'war_id' : '\(id)'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                DispatchQueue.main.async {
                    PubProc.wb.hideWaiting()
                }
                
                do {
                    
                    self.matchResaultres = try JSONDecoder().decode(getActiveWar.Response.self, from: data!)
                   
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showGroupMatchResault", sender: self)
                    }
                    
                } catch {
                    print(error)
                }
               PubProc.countRetry = 0
            } else {
                PubProc.countRetry = PubProc.countRetry + 1
                if PubProc.countRetry == 10 {
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.showFinishedWarResault(id: id)
                    })
                }
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
    }
    
    
    var cGroups : clanGroupsViewController!
    var gMatchs : groupMatchViewController!
    func joinOrLeaveGroup(state : String , clan_id : String) {
        switch state {
        case "NO_REQUIRE_TROPHY":
            self.alertBody = "شما کاپ مورد نیاز گروه را ندارید"
            self.performSegue(withIdentifier: "groupDetailAlert", sender: self)
        case "REQUEST_EXPIRED":
            self.alertBody = "شما امکان انجام این کار را ندارید!"
            self.performSegue(withIdentifier: "groupDetailAlert", sender: self)
        case "USER_HAS_CLAN" :
            self.alertBody = "شما قبلاً عضو یک گروه هستید!"
            self.performSegue(withIdentifier: "groupDetailAlert", sender: self)
        case "leave" :
            DispatchQueue.main.async {
            self.isSelectedClan = false
                self.updateIsSelectedClan()
                self.checkIsClanSelected()
                self.cGroups?.ChangeclanState()
            }
        case "USER_JOINED" :
            DispatchQueue.main.async {
                self.isSelectedClan = true
                self.updateIsSelectedClan()
                self.checkIsClanSelected()
                self.cGroups.clanID = clan_id
                self.cGroups?.getChatroomData(isChatSend: false, completionHandler: {})
                self.cGroups?.ChangeclanState()
                self.gMatchs?.updateclanGamePage()
            }        default:
            DispatchQueue.main.async {
                self.isSelectedClan = true
                self.updateIsSelectedClan()
                self.checkIsClanSelected()
                self.cGroups.clanID = clan_id
                self.cGroups?.getChatroomData(isChatSend: false, completionHandler: {})
                self.cGroups?.ChangeclanState()
            }
        }
    }
    
    func updateGroupInfo(id : String) {
        DispatchQueue.main.async {
        self.isSelectedClan = true
        self.updateIsSelectedClan()
        self.checkIsClanSelected()
        self.cGroups.clanID = id
        self.cGroups?.getChatroomData(isChatSend: false, completionHandler: {})
        self.cGroups?.ChangeclanState()
        }
    }
    
    func clanJoinded() {
        updateIsSelectedClan()
    }
    
    let defaults = UserDefaults.standard
    var clanId = String()
    var groupId = String()
    @objc func showGroupInfo(id : String) {
        self.groupId = id
        self.performSegue(withIdentifier: "showGroupDetail", sender: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func finishTutorial() {
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            scrollToPage().scrollPageViewController(index: 2)
            scrollToPage().menuButtonChanged(index: 2)
            self.defaults.set(false , forKey: "tutorial")
            matchViewController.isTutorial = false
            loadingViewController.showPublicMassages = true
            self.view.isUserInteractionEnabled = true
        }
    }
    
    var searchText = String()
    func didEditedSearchTextField(searchText: String) {
        self.searchText = searchText
    }
    
    
    var realm : Realm!
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var friendsOutlet: RoundButton!
    @IBOutlet weak var searchOutlet: RoundButton!
    @IBOutlet weak var groupOutlet: RoundButton!
    @IBOutlet weak var groupGameOutlet: RoundButton!
    @IBOutlet weak var groupsGamePage: UIView!
    @IBOutlet weak var groupsMatchPage: UIView!
        
    var state = "friendsList"
    var searchCount = 1
    
    @objc func getFriendsList(isSplash : Bool) {
        if state == "friendsList" {
        if isSplash {
        PubProc.isSplash = true
        } else {
        PubProc.isSplash = false
        }
        PubProc.HandleDataBase.readJson(wsName: "ws_getFriendList", JSONStr: "{'userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        GroupsViewController.friendsRes = try JSONDecoder().decode(friendList.Response.self , from : data!)
                        PubProc.isSplash = false
                        
                        
                            if GroupsViewController.friendsRes?.response?.count == 0 {
                                self.handleScrollEnable(isEnable: false)
                                
                            }
                        DispatchQueue.main.async {
                            self.friendsTableView.reloadData()
                            let firstIndex = IndexPath(row: 0, section: 0)
                            self.friendsTableView.scrollToRow(at: firstIndex, at: .top, animated: false)
                        }
                        
                        if isSplash {
                            DispatchQueue.main.async {
                                PubProc.wb.hideWaiting()
                            }
                        }
                    } catch {
                        self.getFriendsList(isSplash: isSplash)
                        print(error)
                    }
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.getFriendsList(isSplash: isSplash)
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
        }
        
    }
    
    static var friendsRes : friendList.Response? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if matchViewController.isTutorial {
            searchingState()
        }
        checkIsClanSelected()
        updateIsSelectedClan()
//        getFriendsList(isSplash: true)
    }
    
    @objc func checkIsClanSelected() {
        if login.res?.response?.calnData != nil {
            if login.res?.response?.calnData?.clanid != nil {
            self.isSelectedClan = true
            self.clanId = ((login.res?.response?.calnData?.clanid!)!)
            } else {
                self.isSelectedClan = false
            }
        } else {
            self.isSelectedClan = false
        }
    }
    
    @objc func refreshUserData(notification : Notification) {
        getFriendsList(isSplash: false)
    }
    
     @objc func showTutorial(notification : Notification) {
        self.performSegue(withIdentifier: "lastTutorialPage", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        realm = try? Realm()
//        getFriendsList(isSplash: true)
        friendsActionColor()
        if matchViewController.isTutorial {
            self.isSelectedClan = false
        } else {
            checkIsClanSelected()
        }
        friendsTableView.keyboardDismissMode = .onDrag
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUserData(notification:)), name: NSNotification.Name(rawValue: "refreshUsersAfterCancelling"), object: nil)

        if matchViewController.isTutorial {
            NotificationCenter.default.addObserver(self, selector: #selector(self.showTutorial(notification:)), name: Notification.Name("showShopTutorial"), object: nil)
        }
        
    
        self.groupOutlet.addTarget(self, action: #selector(groupAction), for: UIControlEvents.touchUpInside)
        
        self.groupGameOutlet.addTarget(self, action: #selector(groupGameAction), for: UIControlEvents.touchUpInside)
        self.groupsGamePage.round(corners: [.topLeft, .topRight], radius: 10)
        self.groupsGamePage.isHidden = true
        self.groupsMatchPage.round(corners: [.topLeft, .topRight], radius: 10)
        self.groupsMatchPage.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
                
        
        let pageIndexDict:[String: Int] = ["button": 3]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
        if state == "friendsList" {
            getFriendsList(isSplash: true)
        } else if state == "group"{
            self.cGroups?.updatePage()
        } else {
            
        }
    }
    
    var resUser : usersSearchLists.Response? = nil
    
    @objc func searchFunction() {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode' : 'GetByRefID' , 'ref_id' : '\(self.searchText)' , 'userid' : '\(loadingViewController.userid)' }") { data, error in
            
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.resUser = try JSONDecoder().decode(usersSearchLists.Response.self , from : data!)
                        
//                        print((self.resUser?.response?.count)!)
                        if (self.resUser?.response?.count)! != 0 {
                            self.searchCount = 1 + (self.resUser?.response?.count)!
                            DispatchQueue.main.async {
                                self.handleScrollEnable(isEnable: true)
                                self.friendsTableView.reloadData()
                                PubProc.wb.hideWaiting()
                            }
                        } else {
                            self.searchCount = 1
                            DispatchQueue.main.async {
                                self.handleScrollEnable(isEnable: false)
                                self.friendsTableView.reloadData()
                                PubProc.wb.hideWaiting()
                            }
                        }
//                        print((self.resUser?.response?[0].avatar!)!)
                    } catch {
                        self.searchFunction()
                        print(error)
                    }
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.searchFunction()
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if state == "searchList" {
            return searchCount
        } else {
        if GroupsViewController.friendsRes != nil {
            if GroupsViewController.friendsRes?.response?.count == 0 {
                return 1
            } else {
            return (GroupsViewController.friendsRes?.response?.count)!
            }
        } else {
            return 0
        }
        }
    }
    
    var urlClass = urls()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if state == "searchList" {
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchFriendsCell", for: indexPath) as! searchFriendsCell
            
                cell.searchButton.addTarget(self, action: #selector(searchFunction), for: UIControlEvents.touchUpInside)
                cell.delegate = self
            return cell
                
            } else {
                
                if indexPath.row == 1 {
                    self.handleScrollEnable(isEnable: true)
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell
                
                let url = "\(urlClass.avatar)\((self.resUser?.response?[indexPath.row - 1].avatar!)!)"
                
                let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
                if realmID.count != 0 {
                    let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    cell.friendAvatar.image = UIImage(data: dataDecoded as Data)
                } else {
                    cell.friendAvatar.setImageWithKingFisher(url: url)
                }
               
                if self.resUser?.response?[indexPath.row - 1].badge_name != nil {
                    let url2 = "\(urlClass.badge)\((self.resUser?.response?[indexPath.row - 1].badge_name!)!)"
                    
                    if url2 == "http://volcan.ir/adelica/images/badge/" {
                        cell.friendLogo.image = UIImage()
                    } else {
                    let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url2)'")
                    if realmID.count != 0 {
                        let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                        cell.friendLogo.image = UIImage(data: dataDecoded as Data)
                    } else {
                        cell.friendLogo.setImageWithKingFisher(url: url2)
                        }
                    }
                }
                
                cell.friendCup.text = "\((self.resUser?.response?[indexPath.row - 1].cups!)!)"
                cell.friendName.text = "\((self.resUser?.response?[indexPath.row - 1].username!)!)"
                cell.selectFriend.tag = indexPath.row
                cell.selectFriend.addTarget(self, action: #selector(selectingProfile), for: UIControlEvents.touchUpInside)
                cell.selectFriendName.tag = indexPath.row
                cell.selectFriendName.addTarget(self, action: #selector(selectingProfile), for: UIControlEvents.touchUpInside)
                return cell
            }
            
        } else {
            
        if GroupsViewController.friendsRes?.response?.count != 0 {

        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell

        let url = "\(urlClass.avatar)\((GroupsViewController.friendsRes?.response?[indexPath.row].avatar!)!)"
            
                let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
                if realmID.count != 0 {
                    let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    cell.friendAvatar.image = UIImage(data: dataDecoded as Data)
                } else {
                    cell.friendAvatar.setImageWithKingFisher(url: url)
                }
        
        if GroupsViewController.friendsRes?.response?[indexPath.row].badge_name != nil {
        let url2 = "\(urlClass.badge)\((GroupsViewController.friendsRes?.response?[indexPath.row].badge_name!)!)"
            
            if url2 == "http://volcan.ir/adelica/images/badge/" {
                cell.friendLogo.image = UIImage()
            } else {
                let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url2)'")
                if realmID.count != 0 {
                    let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    cell.friendLogo.image = UIImage(data: dataDecoded as Data)
                } else {
                    cell.friendLogo.setImageWithKingFisher(url: url2)
                }
            }
        }
            print("\((GroupsViewController.friendsRes?.response?[indexPath.row].id!)!)")
        cell.friendCup.text = "\((GroupsViewController.friendsRes?.response?[indexPath.row].cups!)!)"
        cell.friendName.text = "\((GroupsViewController.friendsRes?.response?[indexPath.row].username!)!)"
        cell.selectFriend.tag = indexPath.row
        cell.selectFriend.addTarget(self, action: #selector(selectingProfile), for: UIControlEvents.touchUpInside)
        cell.selectFriendName.tag = indexPath.row
        cell.selectFriendName.addTarget(self, action: #selector(selectingProfile), for: UIControlEvents.touchUpInside)
        return cell

        } else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "noFriendCell", for: indexPath) as! noFriendCell
            
            let noFriendsTitle = "کسی در لیست دوستان شما وجود ندارد"
            let noFriendsButtonTitle = "  جستجوی دوستان  "
            if UIDevice().userInterfaceIdiom == .phone {
            cell.noFriendTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(noFriendsTitle)", strokeWidth: 8.0)
            cell.noFriendButtonTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(noFriendsButtonTitle)", strokeWidth: 8.0)
            } else {
                
            cell.noFriendTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(noFriendsTitle)", strokeWidth: 8.0)
            cell.noFriendButtonTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(noFriendsButtonTitle)", strokeWidth: 8.0)
            }
            
            cell.noFriendTitleForeGround.text = noFriendsTitle
            cell.noFriendButtonTitleForeGround.text = noFriendsButtonTitle
            cell.noFriendButton.addTarget(self, action: #selector(searchingState), for: UIControlEvents.touchUpInside)
            self.handleScrollEnable(isEnable: false)
            return cell
        }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if state == "friendsList" {
        if GroupsViewController.friendsRes?.response?.count != 0 {
        if UIDevice().userInterfaceIdiom == .phone {
            return 80
        } else {
            return 100
            }
        } else {
            return 150
        }
        } else {
            if indexPath.row == 0 {
            return 70
            } else {
                if UIDevice().userInterfaceIdiom == .phone {
                    return 80
                } else {
                    return 100
                }
            }
        }
    }
    
    var selectedProfile = Int()
    @objc func selectingProfile(_ sender : UIButton!) {
            self.selectedProfile = sender.tag
            if self.state == "searchList" {
                self.self.getProfile(userid: ((self.resUser?.response?[self.selectedProfile - 1].id!)!), isGroupDetail: false, completionHandler: {})
//        self.performSegue(withIdentifier: "showUserProfile", sender: self)
            } else {
                self.getProfile(userid: (GroupsViewController.friendsRes?.response?[self.selectedProfile].friend_id!)!, isGroupDetail: false, completionHandler: {})
        }
    }
    
    var otherProfile = Bool()
    @objc func getProfile(userid : String , isGroupDetail : Bool , completionHandler : @escaping () -> Void) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(userid)' , 'load_stadium' : 'false' , 'my_userid' : '\(loadingViewController.userid)'}") { data, error in
                
                if data != nil {
                    
                        PubProc.cV.hideWarning()
                    
                    //                print(data ?? "")
                    if userid == loadingViewController.userid {
                        self.otherProfile = false
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        
                        completionHandler()
                        DispatchQueue.main.async {
                            if !isGroupDetail {
                            self.performSegue(withIdentifier: "showUserProfile", sender: self)
                            }
                            PubProc.wb.hideWaiting()
                        }
                   
                    } catch {
                        self.getProfile(userid: userid, isGroupDetail: isGroupDetail, completionHandler: {})
                        print(error)
                        }
                    } else {
                        self.otherProfile = true
                        do {
                            login.res2 = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                            completionHandler()
                            DispatchQueue.main.async {
                                 if !isGroupDetail {
                                self.performSegue(withIdentifier: "showUserProfile", sender: self)
                                }
                                PubProc.wb.hideWaiting()
                            }
                        } catch {
                            self.getProfile(userid: userid, isGroupDetail: isGroupDetail, completionHandler: {})
                            print(error)
                        }
                    }
                    PubProc.countRetry = 0 
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.getProfile(userid: userid, isGroupDetail: isGroupDetail, completionHandler: {})
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? menuViewController {
                vc.menuState = "profile"
            if self.otherProfile {
                vc.profileResponse = login.res2
            } else {
                vc.profileResponse = login.res
            }
        }
        
        if let vc = segue.destination as? helpViewController {
            vc.groupsDelegate = self
            vc.state = "lastTutorialPage"
        }
        if let vc = segue.destination as? clanGroupsViewController {
            DispatchQueue.main.async {
            vc.delegate = self
            self.checkIsClanSelected()
            vc.clanID = self.clanId
            if segue.identifier == "groupsGame" {
                self.cGroups = segue.destination as? clanGroupsViewController
            }
            }
        }
        
        if let vc = segue.destination as? groupDetailViewController {
            vc.id = self.groupId
            vc.delegate = self
        }
        
        if let vc = segue.destination as? menuAlertViewController {
            vc.alertTitle = "فوتبالیکا"
            vc.alertBody = self.alertBody
            vc.alertAcceptLabel = "تأیید"
        }
        
        if let vc = segue.destination as? groupMatchViewController {
            vc.delegate = self
            if segue.identifier == "groupsMatch" {
                self.gMatchs = segue.destination as? groupMatchViewController
            }
        }
        
        if let vc = segue.destination as? groupMatchResaultViewController {
            vc.matchResaultRes = self.matchResaultres
        }
        
        if let vc = segue.destination as? clanItemsRewardsViewController {
            vc.rewardsItems = self.rewardItems
        }
    }
    
    var alertBody = String()
    var isSelectedClan = Bool()
    
    @objc func updateIsSelectedClan() {
        if login.res?.response?.calnData?.clanMembers?.count != 0 {
            self.groupGameOutlet.isHidden = false
        } else {
            self.groupGameOutlet.isHidden = true
        }
    }
    
    
    func friendsActionColor() {
        self.handlePageTitleColor(friendsOutletColor : UIColor.white ,searchOutletColor : colors().selectedTab , groupOutletColor : colors().selectedTab , groupGameOutletColor : colors().selectedTab )
    }
    
    
    @IBAction func friendsAction(_ sender: RoundButton) {
        friendsActionColor()
        state = "friendsList"
        self.handlePageShow(friendsTableViewShow: false, groupsGamePageShow: true, groupsMatchPageShow: true)
        self.friendsTableView.reloadData()
        let firstIndex = IndexPath(row: 0, section: 0)
        self.friendsTableView.scrollToRow(at: firstIndex, at: .top, animated: false)
    }
    
    @objc func searchingState() {
        self.handlePageTitleColor(friendsOutletColor : colors().selectedTab ,searchOutletColor : UIColor.white , groupOutletColor : colors().selectedTab , groupGameOutletColor : colors().selectedTab )
        state = "searchList"
        self.friendsTableView.reloadData()
    }
    
    @IBAction func searchAction(_ sender: RoundButton) {
        self.handlePageShow(friendsTableViewShow: false, groupsGamePageShow: true, groupsMatchPageShow: true)
        searchingState()
    }
    
    @objc func groupAction() {
        state = "group"
        self.handlePageTitleColor(friendsOutletColor : colors().selectedTab ,searchOutletColor : colors().selectedTab , groupOutletColor : UIColor.white , groupGameOutletColor : colors().selectedTab )
        self.handlePageShow(friendsTableViewShow: true, groupsGamePageShow: false, groupsMatchPageShow: true)
    }
    
    @objc func groupGameAction() {
        self.state = "game"
        self.handlePageTitleColor(friendsOutletColor : colors().selectedTab ,searchOutletColor : colors().selectedTab , groupOutletColor : colors().selectedTab , groupGameOutletColor : UIColor.white )

        self.handlePageShow(friendsTableViewShow: true, groupsGamePageShow: true, groupsMatchPageShow: false)

        if login.res?.response?.calnData != nil {
            if login.res?.response?.calnData?.member_roll != nil {
                let vc = childViewControllers.last as! groupMatchViewController
                vc.updateclanGamePage()
//                if ((login.res?.response?.calnData?.member_roll!)!) != "3" {
//                    let vc = childViewControllers.last as! groupMatchViewController
//                    vc.updateGroupMatch(state : state, isCharge : true)
//                    vc.updateclanGamePage()
//                } else {
//                    let vc = childViewControllers.last as! groupMatchViewController
//                    vc.updateGroupMatch(state : state, isCharge : false)
//                }
            }
        }
        
    }
    
    @objc func handlePageShow(friendsTableViewShow : Bool ,groupsGamePageShow : Bool , groupsMatchPageShow : Bool ) {
        self.friendsTableView.isHidden = friendsTableViewShow
        self.groupsGamePage.isHidden = groupsGamePageShow
        self.groupsMatchPage.isHidden = groupsMatchPageShow
    }
    
    @objc func handlePageTitleColor(friendsOutletColor : UIColor ,searchOutletColor : UIColor , groupOutletColor : UIColor , groupGameOutletColor : UIColor ) {
        self.friendsOutlet.backgroundColor = friendsOutletColor
        self.searchOutlet.backgroundColor = searchOutletColor
        self.groupOutlet.backgroundColor = groupOutletColor
        self.groupGameOutlet.backgroundColor = groupGameOutletColor
    }
    
    @objc func handleScrollEnable(isEnable : Bool) {
        self.friendsTableView.bounces = isEnable
    }
}
