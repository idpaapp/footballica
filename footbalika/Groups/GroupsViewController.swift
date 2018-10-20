//
//  GroupsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

protocol TutorialGroupsDelegate {
    func finishTutorial()
}

class GroupsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , searchFriendsCellDelegate , TutorialGroupsDelegate {

    
    
    let defaults = UserDefaults.standard
    
    func finishTutorial() {
        scrollToPage().scrollPageViewController(index: 2)
        scrollToPage().menuButtonChanged(index: 2)
        defaults.set(false , forKey: "tutorial")
        matchViewController.isTutorial = false
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
    
    
    var state = "friendsList"
    var searchCount = 1
    
    @objc func getFriendsList(isSplash : Bool) {
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
                        
                        
                        DispatchQueue.main.async {
                            if GroupsViewController.friendsRes?.response?.count == 0 {
                                self.friendsTableView.isScrollEnabled = false
                            }
                            self.friendsTableView.reloadData()
                        }
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                        }
                        
                    } catch {
                        self.getFriendsList(isSplash: isSplash)
                        print(error)
                    }
                } else {
                    self.getFriendsList(isSplash: isSplash)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
        
    }
    
    static var friendsRes : friendList.Response? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if matchViewController.isTutorial {
            searchingState()
        } else {
            
        }
        
//        getFriendsList(isSplash: true)
    }
    
    
    @objc func refreshUserData(notification : Notification) {
        getFriendsList(isSplash: false)
    }
    
    
     @objc func showTutorial(notification : Notification) {
        self.performSegue(withIdentifier: "lastTutorialPage", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
//        getFriendsList(isSplash: true)
        friendsActionColor()
        friendsTableView.keyboardDismissMode = .onDrag
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUserData(notification:)), name: NSNotification.Name(rawValue: "refreshUsersAfterCancelling"), object: nil)

        if matchViewController.isTutorial {
            NotificationCenter.default.addObserver(self, selector: #selector(self.showTutorial(notification:)), name: Notification.Name("showShopTutorial"), object: nil)
        }
        
    
        self.groupOutlet.addTarget(self, action: #selector(groupAction), for: UIControlEvents.touchUpInside)
        
        self.groupGameOutlet.addTarget(self, action: #selector(groupGameAction), for: UIControlEvents.touchUpInside)
        self.groupsGamePage.round(corners: [.topLeft, .topRight], radius: 10)
        self.groupsGamePage.isHidden = true
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
        getFriendsList(isSplash: true)
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
                                self.friendsTableView.reloadData()
                                PubProc.wb.hideWaiting()
                            }
                        } else {
                            self.searchCount = 1
                            DispatchQueue.main.async {
                                self.friendsTableView.reloadData()
                                PubProc.wb.hideWaiting()
                            }
                        }
//                        print((self.resUser?.response?[0].avatar!)!)
                        
                    } catch {
                        self.searchFunction()
                        print(error)
                    }
                } else {
                    self.searchFunction()
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
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell
                
                let url = "\(urlClass.avatar)\((self.resUser?.response?[indexPath.row - 1].avatar!)!)"
                
                let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
                if realmID.count != 0 {
                    let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    cell.friendAvatar.image = UIImage(data: dataDecoded as Data)
                } else {
                    let urls = URL(string : url)
                    cell.friendAvatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
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
                        let urls2 = URL(string : url2)
                        cell.friendLogo.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
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
                    let urls = URL(string : url)
                    cell.friendAvatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
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
                    let urls2 = URL(string : url2)
                    cell.friendLogo.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
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
            cell.noFriendTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(noFriendsTitle)", strokeWidth: -4.0)
            cell.noFriendButtonTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(noFriendsButtonTitle)", strokeWidth: -4.0)
            } else {
                
            cell.noFriendTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(noFriendsTitle)", strokeWidth: -4.0)
            cell.noFriendButtonTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(noFriendsButtonTitle)", strokeWidth: -4.0)
            }
            
            cell.noFriendTitleForeGround.text = noFriendsTitle
            cell.noFriendButtonTitleForeGround.text = noFriendsButtonTitle
            cell.noFriendButton.addTarget(self, action: #selector(searchingState), for: UIControlEvents.touchUpInside)
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
        selectedProfile = sender.tag
        if state == "searchList" {
            getProfile(userid: ((self.resUser?.response?[selectedProfile - 1].id!)!))
//        self.performSegue(withIdentifier: "showUserProfile", sender: self)
        } else {
            getProfile(userid: (GroupsViewController.friendsRes?.response?[selectedProfile].friend_id!)!)
        }
    }
    
    @objc func getProfile(userid : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(userid)' , 'load_stadium' : 'false' , 'my_userid' : '\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                        PubProc.cV.hideWarning()
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        
                        self.performSegue(withIdentifier: "showUserProfile", sender: self)
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                        }
                    } catch {
                        self.getProfile(userid: userid)
                        print(error)
                    }
                } else {
                    self.getProfile(userid: userid)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? menuViewController {
//            if state == "searchList" {
//            vc.menuState = "profile"
//            vc.otherProfiles = true
//            vc.oPStadium = ((self.resUser?.response?[selectedProfile - 1].stadium!)!)
//            vc.opName = ((self.resUser?.response?[selectedProfile - 1].username!)!)
//            vc.opAvatar = "\(urlClass.avatar)\(((self.resUser?.response?[selectedProfile - 1].avatar!)!))"
//            vc.opBadge = "\(urlClass.badge)\(((self.resUser?.response?[selectedProfile - 1].badge_name!)!))"
//            vc.opID = ((self.resUser?.response?[selectedProfile - 1].ref_id!)!)
//            vc.opCups = ((self.resUser?.response?[selectedProfile - 1].cups!)!)
//            vc.opLevel = ((self.resUser?.response?[selectedProfile - 1].level!)!)
//            vc.opWinCount = ((self.resUser?.response?[selectedProfile - 1].win_count!)!)
//            vc.opCleanSheetCount = ((self.resUser?.response?[selectedProfile - 1].clean_sheet_count!)!)
//            vc.opLoseCount = ((self.resUser?.response?[selectedProfile - 1].lose_count!)!)
//            vc.opMostScores = ((self.resUser?.response?[selectedProfile - 1].max_points_gain!)!)
//            vc.opDrawCount = ((self.resUser?.response?[selectedProfile - 1].draw_count!)!)
//            vc.opMaximumWinCount = ((self.resUser?.response?[selectedProfile - 1].max_wins_count!)!)
//            vc.opMaximumScore = ((self.resUser?.response?[selectedProfile - 1].max_point!)!)
//            vc.uniqueId = ((self.resUser?.response?[selectedProfile - 1].id!)!)
//
//            } else {
                vc.menuState = "profile"
                vc.otherProfiles = true
                vc.oPStadium = (login.res?.response?.mainInfo?.stadium!)!
                vc.opName = (login.res?.response?.mainInfo?.username!)!
                vc.opAvatar = "\(urlClass.avatar)\((login.res?.response?.mainInfo?.avatar!)!)"
                vc.opBadge = "\(urlClass.badge)\(((login.res?.response?.mainInfo?.badge_name!)!))"
                vc.opID = ((login.res?.response?.mainInfo?.ref_id!)!)
                vc.opCups = ((login.res?.response?.mainInfo?.cups!)!)
                vc.opLevel = ((login.res?.response?.mainInfo?.level!)!)
                vc.opWinCount = ((login.res?.response?.mainInfo?.win_count!)!)
                vc.opCleanSheetCount = ((login.res?.response?.mainInfo?.clean_sheet_count!)!)
                vc.opLoseCount = ((login.res?.response?.mainInfo?.lose_count!)!)
                vc.opMostScores = ((login.res?.response?.mainInfo?.max_points_gain!)!)
                vc.opDrawCount = ((login.res?.response?.mainInfo?.draw_count!)!)
                vc.opMaximumWinCount = ((login.res?.response?.mainInfo?.max_wins_count!)!)
                vc.opMaximumScore = ((login.res?.response?.mainInfo?.max_point!)!)
                vc.uniqueId = ((login.res?.response?.mainInfo?.id!)!)
//            }
        }
        
        if let vc = segue.destination as? helpViewController {
            vc.state = "lastTutorialPage"
            vc.groupsDelegate = self
        }
    }
    
    func friendsActionColor() {
        self.searchOutlet.backgroundColor = colors().selectedTab
        self.friendsOutlet.backgroundColor = UIColor.white
        self.groupOutlet.backgroundColor = colors().selectedTab
        self.groupGameOutlet.backgroundColor = colors().selectedTab
    }
    
    
    @IBAction func friendsAction(_ sender: RoundButton) {
        friendsActionColor()
        state = "friendsList"
        self.friendsTableView.isHidden = false
        self.groupsGamePage.isHidden = true
        self.friendsTableView.reloadData()
    }
    
    @objc func searchingState() {
        self.friendsOutlet.backgroundColor = colors().selectedTab
        self.searchOutlet.backgroundColor = UIColor.white
        self.groupOutlet.backgroundColor = colors().selectedTab
        self.groupGameOutlet.backgroundColor = colors().selectedTab
        state = "searchList"
        self.friendsTableView.reloadData()
    }
    
    @IBAction func searchAction(_ sender: RoundButton) {
        self.friendsTableView.isHidden = false
        self.groupsGamePage.isHidden = true
        searchingState()
    }
    
    @objc func groupAction() {
        state = "group"
        self.friendsOutlet.backgroundColor = colors().selectedTab
        self.searchOutlet.backgroundColor = colors().selectedTab
        self.groupOutlet.backgroundColor = UIColor.white
        self.groupGameOutlet.backgroundColor = colors().selectedTab
        self.friendsTableView.isHidden = true
        self.groupsGamePage.isHidden = false
        changingClanState(state: "group")
    }
    
    @objc func groupGameAction() {
         state = "groupGame"
        self.friendsOutlet.backgroundColor = colors().selectedTab
        self.searchOutlet.backgroundColor = colors().selectedTab
        self.groupOutlet.backgroundColor = colors().selectedTab
        self.groupGameOutlet.backgroundColor = UIColor.white
        self.friendsTableView.isHidden = true
        self.groupsGamePage.isHidden = false
        changingClanState(state: "groupGame")
    }
    
    @objc func changingClanState(state : String) {
        let CVC = childViewControllers.last as! clanGroupsViewController
        CVC.ChangeclanState(state: "\(state)")
    }
    
}
