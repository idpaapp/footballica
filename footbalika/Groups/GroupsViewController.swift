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
