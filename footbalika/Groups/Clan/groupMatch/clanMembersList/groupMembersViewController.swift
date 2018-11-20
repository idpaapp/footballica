//
//  groupMembersViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/20/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import RealmSwift

class groupMembersViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    @IBOutlet weak var clanMembersList: clanMembersListView!
    var realm : Realm!
    var delegate : groupMembersViewControllerDelegate!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.membersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupMemberCell", for: indexPath) as! groupMemberCell
        cell.contentView.backgroundColor = .clear
        cell.topImage.image = publicImages().greenBall
        cell.bottomImage.image = publicImages().ic_timer
        cell.memberName.text = ((self.activeWarRes?.response?.members?[indexPath.row].username!)!)
        cell.memberRole.text = ((self.activeWarRes?.response?.members?[indexPath.row].roll_title!)!)
        let url = "\(urls().avatar)\((self.activeWarRes?.response?.members?[indexPath.row].avatar!)!)"
        let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
        if realmID.count != 0 {
            let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
            cell.memberAvatar.image = UIImage(data: dataDecoded as Data)
        } else {
            cell.memberAvatar.setImageWithKingFisher(url: url)
        }
        
        let url2 = "\(urls().badge)\((self.activeWarRes?.response?.members?[indexPath.row].badge_name!)!)"
        let realmID2 = self.realm.objects(tblShop.self).filter("image_path == '\(url2)'")
        if realmID2.count != 0 {
            let dataDecoded:NSData = NSData(base64Encoded: (realmID2.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
            cell.memberLogo.image = UIImage(data: dataDecoded as Data)
        } else {
            cell.memberLogo.setImageWithKingFisher(url: url2)
        }
        
        cell.countNumber.text = "\(indexPath.row + 1)"
        cell.memberCup.text = "\((self.activeWarRes?.response?.members?[indexPath.row].user_point!)!)"
        cell.memberClanCup.text = "\((self.activeWarRes?.response?.members?[indexPath.row].user_time!)!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    var membersCount = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
        self.clanMembersList.membersTV.dataSource = self
        self.clanMembersList.membersTV.delegate = self
        self.clanMembersList.membersTV.register(UINib(nibName: "groupMemberCell", bundle: nil), forCellReuseIdentifier: "groupMemberCell")
        checkButtonAction()
    }
    
    var isActiveStartButton = Bool()
    @objc func checkButtonAction() {
        if isWarStart {
            self.clanMembersList.useButton.addTarget(self, action: #selector(startClanWar), for: UIControlEvents.touchUpInside)
            if self.activeWarRes?.response?.members != nil {
            for i in 0...(self.activeWarRes?.response?.members?.count)! - 1 {
                if (self.activeWarRes?.response?.members?[i].user_id!)! == loadingViewController.userid {
                    
                    if (self.activeWarRes?.response?.members?[i].status!)! == "2" {
                        self.isActiveStartButton = false
                        self.clanMembersList.useButton.setBackgroundImage(publicImages().inactiveLargeButton, for: UIControlState.normal)
                    } else {
                        self.isActiveStartButton = true
                        self.clanMembersList.useButton.setBackgroundImage(publicImages().action_back_large_btn, for: UIControlState.normal)
                    }
                }
                break
            }
            }
            
        } else {
            self.isActiveStartButton = false
            self.clanMembersList.useButton.addTarget(self, action: #selector(joiningClan), for: UIControlEvents.touchUpInside)
        }
    }
    
    @objc func startClanWar() {
        if self.isActiveStartButton {
            print("startWar")
        }
        
    }
    
    
    
    @objc func enableOrDisableJoinWar(isEnable : Bool) {
        self.clanMembersList.useButton.isEnabled = isEnable
    }
    
    var activeWarRes : getActiveWar.Response? = nil
    var startWarRes : startWar.Response? = nil
    @objc func joiningClan() {
        if isJoinActive {
            self.enableOrDisableJoinWar(isEnable: false)
            self.delegate?.joinWar()
        }
    }
    
    var isWarStart = false
    var isJoinActive = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.clanMembersList.mainView.round(corners: [.bottomLeft , .bottomRight], radius: 10)
        
        if isWarStart {
            startWarUpdate()
            self.clanMembersList.noPriceTitle.isHidden = false
            self.clanMembersList.noPriceTitleForeGround.isHidden = false
        } else {
            self.clanMembersList.noPriceTitle.isHidden = true
            self.clanMembersList.noPriceTitleForeGround.isHidden = true
        self.clanMembersList.useButtonPriceTitle.text = "پیوستن به بازی گروهی"
        self.clanMembersList.useButtonPrice.AttributesOutLine(font: fonts().iPhonefonts, title: "\((loadingViewController.loadGameData?.response?.join_war_price!)!)", strokeWidth: 5.0)
        self.clanMembersList.useButtonPriceForeGround.font = fonts().iPhonefonts
        self.clanMembersList.useButtonPriceForeGround.text = "\((loadingViewController.loadGameData?.response?.join_war_price!)!)"
        switch String((loadingViewController.loadGameData?.response?.join_war_price_type!)!) {
        case publicConstants().coinCase :
            self.clanMembersList.useButtonPriceIcon.image = publicImages().coin
        case publicConstants().moneyCase :
            self.clanMembersList.useButtonPriceIcon.image = publicImages().money
        default:
            self.clanMembersList.useButtonPriceIcon.image = UIImage()
        }
        }
    }
    
    func reloadingData(members : Int) {
        self.membersCount = members
        self.clanMembersList.topTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "تعداد بازیکنان : \(self.membersCount)", strokeWidth: 5.0)
        if self.activeWarRes != nil {
            if self.activeWarRes?.response?.members != nil {
                if ((self.activeWarRes?.response?.members?.index(where : {$0.user_id == loadingViewController.userid})) != nil) {
                    self.clanMembersList.useButton.setBackgroundImage(publicImages().inactiveLargeButton, for: UIControlState.normal)
                    self.isJoinActive = false
                } else {
                    self.clanMembersList.useButton.setBackgroundImage(publicImages().activeButton, for: UIControlState.normal)
                    self.isJoinActive = true
                }
            }
        } else {
            if self.startWarRes?.response?.members != nil {
                if ((self.startWarRes?.response?.members?.index(where : {$0.user_id == loadingViewController.userid})) != nil) {
                    self.clanMembersList.useButton.setBackgroundImage(publicImages().inactiveLargeButton, for: UIControlState.normal)
                    self.isJoinActive = false
                } else {
                    self.clanMembersList.useButton.setBackgroundImage(publicImages().activeButton, for: UIControlState.normal)
                    self.isJoinActive = true
                }
            }
        }
        self.clanMembersList.topTitleForeGround.font = fonts().iPhonefonts
        self.clanMembersList.topTitleForeGround.text = "تعداد بازیکنان : \(self.membersCount)"
        DispatchQueue.main.async {
            if self.membersCount < 6 {
                self.clanMembersList.warningTitle.text = "برای شروع بازی گروهی حداقل باید 6 نفر عضو شوند"
                self.clanMembersList.warningTitle.textColor = publicColors().badNewsColor
            } else {
                self.clanMembersList.warningTitle.text = ""
            }
            self.clanMembersList.membersTV.reloadData()
        }
    }
    
    @objc func startWarUpdate() {
        self.isWarStart = true
        self.checkButtonAction()
        self.clanMembersList.useButtonPrice.text = ""
        self.clanMembersList.useButtonPriceForeGround.text = ""
        self.clanMembersList.useButtonPriceTitle.text = ""
        self.clanMembersList.noPriceTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "شروع بازی", strokeWidth: -5.0)
        self.clanMembersList.noPriceTitleForeGround.font = fonts().iPhonefonts
        self.clanMembersList.useButtonPriceIcon.image = UIImage()
        self.clanMembersList.noPriceTitleForeGround.text = "شروع بازی"
        self.clanMembersList.useButton.setBackgroundImage(publicImages().action_back_large_btn, for: UIControlState.normal)
    }
}
