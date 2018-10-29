//
//  groupDetailViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/1/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class groupDetailViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UITableViewDelegate , UITableViewDataSource {
    
    var delegate : groupDetailViewControllerDelegate!
    var realm : Realm!
    var id = String()
    var res : clanGroup.Response? = nil
    let urlClass = urls()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.res != nil {
            return (self.res?.response?.clanMembers?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupMemberCell", for: indexPath) as! groupMemberCell
        
        cell.memberClanCup.text = "\((self.res?.response?.clanMembers?[indexPath.row].clan_score!)!)"
        cell.memberCup.text = "\((self.res?.response?.clanMembers?[indexPath.row].cups!)!)"
        cell.countNumber.text = "\(indexPath.row + 1)"
        cell.memberName.text = "\((self.res?.response?.clanMembers?[indexPath.row].username!)!)"
        cell.memberRole.text = "\((self.res?.response?.clanMembers?[indexPath.row].roll_title!)!)"
        
        
        let url = "\(urlClass.avatar)\((self.res?.response?.clanMembers?[indexPath.row].avatar!)!)"
        
        let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
        if realmID.count != 0 {
            let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
            cell.memberAvatar.image = UIImage(data: dataDecoded as Data)
        } else {
            let urls = URL(string : url)
            let resource = ImageResource(downloadURL: urls!, cacheKey: url)
            cell.memberAvatar.kf.setImage(with: resource ,options:[.transition(ImageTransition.fade(0.5))])
        }
        
        if ((self.res?.response?.clanMembers?[indexPath.row].user_id!)!) == "\(loadingViewController.userid)" {
            self.isJoined = true
            switch ((self.res?.response?.clanMembers?[indexPath.row].member_roll!)!){
            case publicConstants().teamCaptain:
                self.isCharge = true
            case publicConstants().teamStarPlayer:
                self.isCharge = true
            default :
                self.isCharge = false
            }
        } else {
            self.isJoined = false
            self.isCharge = false
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    var clanDetailTitles = ["شناسه گروه" ,
                            "حداقل کاپ" ,
                            "نوع گروه" ,
                            "تعداد اعضاء" ,
                            "امتیاز گروه" ]
   
    var clanDetailImages = ["ic_tag" , "ic_cup" , "invite_friend" , "ic_member_count" , "clan_cup"]
    
    @IBOutlet weak var clanMembersTV: UITableView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.res != nil {
            return 5
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clanDetailCell", for: indexPath) as! clanDetailCell
        
        cell.clanDetailTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(clanDetailTitles[indexPath.item])", strokeWidth: -5.0)
        cell.clanDetailTitleForeGround.font = fonts().iPhonefonts
        cell.clanDetailTitleForeGround.text = clanDetailTitles[indexPath.item]
        cell.clanDetailImage.image = UIImage(named: "\(clanDetailImages[indexPath.item])")
        
        var text = String()
        switch indexPath.item {
        case 0:
            text = "\((self.res?.response?.clan_tag!)!)"
        case 1:
            text = "\((self.res?.response?.require_trophy!)!)"
        case 2:
            text = "\((self.res?.response?.clan_type_title!)!)"
        case 3:
            text = "\((self.res?.response?.member_count!)!)"
        default:
            text = "\((self.res?.response?.clan_score!)!)"
        }
        
        cell.clanDetailAmount.AttributesOutLine(font: fonts().iPhonefonts, title: "\(text)", strokeWidth: -5.0)
        cell.clanDetailAmountForeGround.font = fonts().iPhonefonts
        cell.clanDetailAmountForeGround.text = text
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: UIScreen.main.bounds.width / 5 - 12 , height: UIScreen.main.bounds.height / 6 - 20)
        
      return size
        
    }
    
    @objc func getClanData(id : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'READ_CLAN' , 'clan_id' : '\(id)'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                do {
                    
                    self.res = try JSONDecoder().decode(clanGroup.Response.self , from : data!)
                    
                    //                        print((self.resUser?.response?.count)!)
                    
                    DispatchQueue.main.async {
                        self.clanMembersTV.reloadData()
                        self.fillClanData()
                        self.setupView(isHidden : false)
                        self.setGroupButtons()
                        PubProc.wb.hideWaiting()
                        
                    }
                    
                    
                } catch {
                    self.getClanData(id: id)
                    print(error)
                }
            } else {
                self.getClanData(id: id)
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
    }

    @IBOutlet weak var clanCup: UILabel!
    
    @IBOutlet weak var clanImage: UIImageView!
    
    @IBOutlet weak var groupDetailsCV: UICollectionView!
    
    @IBOutlet weak var clanName: UILabel!
    
    @IBOutlet weak var groupTitle: UILabel!
    
    @IBOutlet weak var groupTitleForeGround: UILabel!
    
    @IBOutlet weak var actionLargeButton: actionLargeButton!
    
    @IBOutlet weak var groupDescription: UILabel!
    
    
    var isJoined = Bool()
    var isCharge = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try? Realm()
        
        self.groupDetailsCV.register(UINib(nibName: "clanDetailCell", bundle: nil), forCellWithReuseIdentifier: "clanDetailCell")
        
        self.clanMembersTV.register(UINib(nibName: "groupMemberCell", bundle: nil), forCellReuseIdentifier: "groupMemberCell")
        
        self.clanCup.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
        
        self.groupTitle.AttributesOutLine(font: fonts().iPadfonts, title: "گروه", strokeWidth: -7.0)
        self.groupTitleForeGround.font = fonts().iPadfonts
        self.groupTitleForeGround.text = "گروه"
        
        self.actionLargeButton.actionButton.addTarget(self, action: #selector(joinGroup), for: UIControlEvents.touchUpInside)
        setTitles()
        setGroupButtons()
        setupView(isHidden : true)
        getClanData(id: self.id)
       
    }
    
    func fillClanData() {
        self.groupDetailsCV.reloadData()
        self.clanCup.text = "\((self.res?.response?.clan_score!)!)"
        self.clanName.text = "\((self.res?.response?.title!)!)"
        self.groupDescription.text = "\((self.res?.response?.clan_status!)!)"
        let url = "\(urls().clan)\((self.res?.response?.caln_logo!)!)"
        let Urls = URL(string : url)
        let resource = ImageResource(downloadURL: Urls!, cacheKey: url)
        self.clanImage.kf.setImage(with: resource ,options:[.transition(ImageTransition.fade(0.5))])
    }
    
    func setupView(isHidden : Bool) {
        self.actionLargeButton.setButtons(hideAction: isHidden, hideAction1: isHidden, hideAction2: isHidden, hideAction3: isHidden)
        if isHidden {
            self.clanName.text = ""
            self.clanCup.text = ""
            self.groupDescription.text = ""
        }
    }
    
    @objc func setTitles() {
        self.actionLargeButton.setTitles(actionTitle: "عضویت در گروه", action1Title: "تنظیمات گروه", action2Title: "ارسال دعوتنامه", action3Title: "ترک کردن گروه")
    }
    
    @objc func setGroupButtons() {
        self.actionLargeButton.setButtons(hideAction: isJoined, hideAction1: !isCharge, hideAction2: !isJoined, hideAction3: !isJoined )
    }
    
    @objc func joinGroup() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'JOIN_CLAN' , 'user_id' : '\(loadingViewController.userid)' , 'clan_id' : '\(id)' }") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                
                //                print(data ?? "")
                
                let Res = String(data: data!, encoding: String.Encoding.utf8) as String?
                if ((Res)!).contains("USER_JOINED") {
                    self.isJoined = true
                    self.delegate?.joinOrLeaveGroup(state : "join" , clan_id : self.id)
                } else if ((Res)!).contains("NO_REQUIRE_TROPHY") {
                    self.delegate?.joinOrLeaveGroup(state : "NO_REQUIRE_TROPHY" , clan_id : self.id)
                } else if ((Res)!).contains("USER_HAS_CLAN") {
                    self.delegate?.joinOrLeaveGroup(state : "USER_HAS_CLAN" , clan_id : self.id)
                } else {
                    self.delegate?.joinOrLeaveGroup(state : "REQUEST_EXPIRED" , clan_id : self.id)
                }
                        PubProc.wb.hideWaiting()
                }
            } else {
                self.joinGroup()
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closingGroupDetails(_ sender: RoundButton) {
        self.dismiss(animated : true , completion : nil)
    }


}
