//
//  GroupsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

class GroupsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , searchFriendsCellDelegate {
    
    var searchText = String()
    func didEditedSearchTextField(searchText: String) {
        self.searchText = searchText
    }
    

    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var friendsOutlet: RoundButton!
    @IBOutlet weak var searchOutlet: RoundButton!
    var state = "friendsList"
    var searchCount = 1
    @objc func getFriendsList() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_getFriendList", JSONStr: "{'userid':'1'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.res = try JSONDecoder().decode(friendList.Response.self , from : data!)
                        
                        
                        
                        DispatchQueue.main.async {
                            if self.res?.response?.count == 0 {
                                self.friendsTableView.isScrollEnabled = false
                            }
                            self.friendsTableView.reloadData()
                        }
                        
                    } catch {
                        self.getFriendsList()
                        print(error)
                    }
                } else {
                    self.getFriendsList()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
        
    }
    
    var res : friendList.Response? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriendsList()
        friendsActionColor()
        friendsTableView.keyboardDismissMode = .onDrag
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
    }
    
    var resUser : usersSearchLists.Response? = nil
    @objc func searchFunction() {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode' : 'GetByRefID' , 'ref_id' : '\(self.searchText)' , 'userid' : '1' }") { data, error in
            
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.resUser = try JSONDecoder().decode(usersSearchLists.Response.self , from : data!)
                        
                        print((self.resUser?.response?.count)!)
                        if (self.resUser?.response?.count)! != 0 {
                            self.searchCount = 1 + (self.resUser?.response?.count)!
                            DispatchQueue.main.async {
                                self.friendsTableView.reloadData()
                            }
                        } else {
                            self.searchCount = 1
                            DispatchQueue.main.async {
                                self.friendsTableView.reloadData()
                            }
                        }
//                        print((self.resUser?.response?[0].avatar!)!)
                        
                    } catch {
                        self.getFriendsList()
                        print(error)
                    }
                } else {
                    self.getFriendsList()
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
        if self.res != nil {
            if self.res?.response?.count == 0 {
                return 1
            } else {
            return (self.res?.response?.count)!
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
                let urls = URL(string : url)
                cell.friendAvatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
                if self.resUser?.response?[indexPath.row - 1].badge_name != nil {
                    let url2 = "\(urlClass.badge)\((self.resUser?.response?[indexPath.row - 1].badge_name!)!)"
                    let urls2 = URL(string : url2)
                    cell.friendLogo.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
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
            
        if self.res?.response?.count != 0 {

        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell

        let url = "\(urlClass.avatar)\((self.res?.response?[indexPath.row].avatar!)!)"
        let urls = URL(string : url)
        cell.friendAvatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
        if self.res?.response?[indexPath.row].badge_name != nil {
        let url2 = "\(urlClass.badge)\((self.res?.response?[indexPath.row].badge_name!)!)"
        let urls2 = URL(string : url2)
        cell.friendLogo.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
        }
        cell.friendCup.text = "\((self.res?.response?[indexPath.row].cups!)!)"
        cell.friendName.text = "\((self.res?.response?[indexPath.row].username!)!)"
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
            
            return cell
        }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if state == "friendsList" {
        if self.res?.response?.count != 0 {
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
        self.performSegue(withIdentifier: "showUserProfile", sender: self)
        } else {
        getProfile()
        }
    }
    
    @objc func getProfile() {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\((self.res?.response?[selectedProfile].friend_id!)!)' , 'load_stadium' : 'false'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        self.performSegue(withIdentifier: "showUserProfile", sender: self)
                        
                    } catch {
                        self.getProfile()
                        print(error)
                    }
                } else {
                    self.getProfile()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? menuViewController {
            if state == "searchList" {
            vc.menuState = "profile"
            vc.otherProfiles = true
            vc.oPStadium = ((self.resUser?.response?[selectedProfile - 1].stadium!)!)
            vc.opName = ((self.resUser?.response?[selectedProfile - 1].username!)!)
            vc.opAvatar = "\(urlClass.avatar)\(((self.resUser?.response?[selectedProfile - 1].avatar!)!))"
            vc.opBadge = "\(urlClass.badge)\(((self.resUser?.response?[selectedProfile - 1].badge_name!)!))"
            vc.opID = ((self.resUser?.response?[selectedProfile - 1].ref_id!)!)
            vc.opCups = ((self.resUser?.response?[selectedProfile - 1].cups!)!)
            vc.opLevel = ((self.resUser?.response?[selectedProfile - 1].level!)!)
            vc.opWinCount = ((self.resUser?.response?[selectedProfile - 1].win_count!)!)
            vc.opCleanSheetCount = ((self.resUser?.response?[selectedProfile - 1].clean_sheet_count!)!)
            vc.opLoseCount = ((self.resUser?.response?[selectedProfile - 1].lose_count!)!)
            vc.opMostScores = ((self.resUser?.response?[selectedProfile - 1].max_points_gain!)!)
            vc.opDrawCount = ((self.resUser?.response?[selectedProfile - 1].draw_count!)!)
            vc.opMaximumWinCount = ((self.resUser?.response?[selectedProfile - 1].max_wins_count!)!)
            vc.opMaximumScore = ((self.resUser?.response?[selectedProfile - 1].max_point!)!)
            vc.uniqueId = ((self.resUser?.response?[selectedProfile - 1].id!)!)
            } else {
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
            }
        }
    }
    
    func friendsActionColor() {
        self.searchOutlet.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.friendsOutlet.backgroundColor = UIColor.white
    }
    
    
    @IBAction func friendsAction(_ sender: RoundButton) {
        friendsActionColor()
        state = "friendsList"
        self.friendsTableView.reloadData()
    }
    
    
    @IBAction func searchAction(_ sender: RoundButton) {
    
        self.friendsOutlet.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.searchOutlet.backgroundColor = UIColor.white
        state = "searchList"
        self.friendsTableView.reloadData()
    
    }
    
    
    
    

}
