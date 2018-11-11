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
        cell.memberRole.text = ((self.activeWarRes?.response?.members?[indexPath.row].member_roll!)!)
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
        self.clanMembersList.useButton.addTarget(self, action: #selector(joiningClan), for: UIControlEvents.touchUpInside)
    }
    var activeWarRes : getActiveWar.Response? = nil
    var startWarRes : startWar.Response? = nil
    @objc func joiningClan() {
        if isJoinActive {
            self.delegate?.joinWar()
        }
    }
    
    var isJoinActive = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.clanMembersList.mainView.round(corners: [.bottomLeft , .bottomRight], radius: 10)
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
                self.clanMembersList.membersTV.reloadData()
            }
        }
    }
}
