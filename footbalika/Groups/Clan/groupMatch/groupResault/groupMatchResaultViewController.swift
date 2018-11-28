//
//  groupMatchResaultViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/22/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class groupMatchResaultViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var menuWindow: windows!
    
    @IBOutlet weak var clanRightView: clanRightResaultView!
    
    @IBOutlet weak var clanLeftView: clanLeftResaultView!
    
    @IBOutlet weak var clanMembers: clanMembersListView!
  
    var matchResaultRes : getActiveWar.Response? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuWindow.closePage.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        
        self.setClansResaults()
        self.addViews(view: self.clanRightView)
        self.addViews(view: self.clanLeftView)
        self.addViews(view: self.clanMembers)
        self.setMembersView()
        self.clanMembersData()
    }
    
    @objc func clanMembersData() {
        self.clanMembers.membersTV.dataSource = self
        self.clanMembers.membersTV.delegate = self
        self.clanMembers.membersTV.register(UINib(nibName: "groupMemberCell", bundle: nil), forCellReuseIdentifier: "groupMemberCell")
    }
    
    @objc func addViews(view : UIView) {
        self.menuWindow.addSubview(view)
        self.menuWindow.bringSubview(toFront: view)
    }
    
    @objc func setClansResaults() {
        self.clanRightView.clanImage.setImageWithKingFisher(url: "\(urls().clan)\((self.matchResaultRes?.response?.opp_clan_logo!)!)")
        self.clanRightView.clanName.text = "\((self.matchResaultRes?.response?.opp_clan_title!)!)"
        self.clanRightView.clanResault.text = "\((self.matchResaultRes?.response?.opp_war_point!)!)"
        
        self.clanLeftView.clanImage.setImageWithKingFisher(url: "\(urls().clan)\((login.res?.response?.calnData?.caln_logo!)!)")
        self.clanLeftView.clanName.text = "\((login.res?.response?.calnData?.clan_title!)!)"
        self.clanLeftView.clanResault.text = "\((self.matchResaultRes?.response?.war_point!)!)"
        self.clanMembers.useButtonPriceTitle.isHidden = true
        self.clanMembers.useButtonPrice.textAlignment = .left
        self.clanMembers.useButtonPriceForeGround.textAlignment = .left
    }
    
    @objc func setMembersView() {
        self.clanMembers.warningTitle.text = ""
        self.clanMembers.topTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "تعداد بازیکنان : \((self.matchResaultRes?.response?.members?.count)!)", strokeWidth: 4.0)
        self.clanMembers.topTitleForeGround.font = fonts().iPhonefonts
        self.clanMembers.topTitleForeGround.text = "تعداد بازیکنان : \((self.matchResaultRes?.response?.members?.count)!)"
        self.clanMembers.useButton.setBackgroundImage(publicImages().activeButton, for: UIControlState.normal)
        self.clanMembers.noPriceTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "خب", strokeWidth: 4.0)
        self.clanMembers.noPriceTitleForeGround.font = fonts().iPhonefonts
        self.clanMembers.noPriceTitleForeGround.text = "خب"
        self.clanMembers.useButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        self.clanMembers.useButton.setBackgroundImage(publicImages().action_back_large_btn, for: UIControlState.normal)
        
        setLabels()
    }
    
    @objc func setLabels() {
        self.clanMembers.noPriceTitle.setLabelHide(isHide : false)
        self.clanMembers.noPriceTitleForeGround.setLabelHide(isHide : false)
        self.clanMembers.useButtonPriceForeGround.setLabelHide(isHide : true)
        self.clanMembers.useButtonPrice.setLabelHide(isHide : true)
        self.clanMembers.useButtonPriceIcon.isHidden = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print((self.matchResaultRes?.response?.members?.count)!)
        return (self.matchResaultRes?.response?.members?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupMemberCell", for: indexPath) as! groupMemberCell
        
        cell.countNumber.text = "\(indexPath.row + 1 )"
        
        cell.memberLogo.setImageWithRealmPath(url: "\(urls().badge)\((self.matchResaultRes?.response?.members?[indexPath.row].badge_name!)!)")
        
        if cell.memberLogo.image == UIImage() {
            cell.memberLogo.setImageWithKingFisher(url: "\(urls().badge)\((self.matchResaultRes?.response?.members?[indexPath.row].badge_name!)!))")
        }
        cell.memberName.text = "\((self.matchResaultRes?.response?.members?[indexPath.row].username!)!)"
        
        switch (self.matchResaultRes?.response?.members?[indexPath.row].member_roll!)! {
        case publicConstants().teamCaptain:
            cell.memberRole.text = "کاپیتان"
        case publicConstants().teamPlayer:
            cell.memberRole.text = "بازیکن"
        default:
            cell.memberRole.text = "بازیکن کلیدی"
        }
        
        cell.memberAvatar.setImageWithRealmPath(url: "\(urls().avatar)\((self.matchResaultRes?.response?.members?[indexPath.row].avatar!)!)")
        if cell.memberAvatar.image == UIImage() {
            cell.memberAvatar.setImageWithKingFisher(url: "\(urls().avatar)\((self.matchResaultRes?.response?.members?[indexPath.row].avatar!)!)")
        }
        
        cell.topImage.image = publicImages().greenBall
        cell.bottomImage.image = publicImages().ic_timer
        var time = "+ \((self.matchResaultRes?.response?.members?[indexPath.row].user_time!)!)"
        if (self.matchResaultRes?.response?.members?[indexPath.row].user_time!)! == "0" {
            time.removeFirst(1)
        } else {
            
        }
        cell.memberClanCup.text = time
        cell.memberCup.text = "\((self.matchResaultRes?.response?.members?[indexPath.row].user_point!)!)"
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func dismissing() {
        self.dismiss(animated: true, completion: nil)
    }
}
