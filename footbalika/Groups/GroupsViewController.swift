//
//  GroupsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

class GroupsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var friendsOutlet: RoundButton!
    @IBOutlet weak var searchOutlet: RoundButton!
    
    @objc func getFriendsList() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_getFriendList", JSONStr: "{'userid':'1'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.res = try JSONDecoder().decode(friendList.Response.self , from : data!)
                        
                        
                        
                        
                        DispatchQueue.main.async {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.res != nil {
            return (self.res?.response?.count)!
        } else {
            return 0
        }
    }
    
    var urlClass = urls()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
            return 80
        } else {
            return 100
        }
    }
    
    @IBAction func friendsAction(_ sender: RoundButton) {
    
    
    
    
    }
    
    
    @IBAction func searchAction(_ sender: RoundButton) {
    
    
    
    
    }
    
    
    
    

}
