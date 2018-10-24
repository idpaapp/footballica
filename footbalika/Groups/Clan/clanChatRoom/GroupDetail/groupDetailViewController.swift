//
//  groupDetailViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/1/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class groupDetailViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupMemberCell", for: indexPath) as! groupMemberCell
        
        cell.memberClanCup.text = "120"
        cell.memberCup.text = "12"
        cell.countNumber.text = "\(indexPath.row + 1)"
        cell.memberName.text = "حجت الاسلام و المسلمین سید قلی خامه ای"
        cell.memberRole.text = "گدای عالم"
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
    
    var clanDetailAmounts = ["#63653" , "200" , "عمومی" , "0" , "1200"]
    
    
    @IBOutlet weak var clanMembersTV: UITableView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clanDetailCell", for: indexPath) as! clanDetailCell
        
        cell.clanDetailTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(clanDetailTitles[indexPath.item])", strokeWidth: -5.0)
        cell.clanDetailTitleForeGround.font = fonts().iPhonefonts
        cell.clanDetailTitleForeGround.text = clanDetailTitles[indexPath.item]
        cell.clanDetailImage.image = UIImage(named: "\(clanDetailImages[indexPath.item])")
        cell.clanDetailAmount.AttributesOutLine(font: fonts().iPhonefonts, title: "\(clanDetailAmounts[indexPath.item])", strokeWidth: -5.0)
        cell.clanDetailAmountForeGround.font = fonts().iPhonefonts
        cell.clanDetailAmountForeGround.text = clanDetailAmounts[indexPath.item]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: UIScreen.main.bounds.width / 5 - 12 , height: UIScreen.main.bounds.height / 6 - 20)
        
      return size
        
    }
    

    @IBOutlet weak var clanCup: UILabel!
    
    @IBOutlet weak var clanImage: UIImageView!
    
    @IBOutlet weak var groupDetailsCV: UICollectionView!
    
    @IBOutlet weak var clanName: UILabel!
    
    @IBOutlet weak var groupTitle: UILabel!
    
    @IBOutlet weak var groupTitleForeGround: UILabel!
    
    @IBOutlet weak var actionLargeButton: actionLargeButton!
    
    var isJoined = Bool()
    var isCharge = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.groupDetailsCV.register(UINib(nibName: "clanDetailCell", bundle: nil), forCellWithReuseIdentifier: "clanDetailCell")
        
        self.clanMembersTV.register(UINib(nibName: "groupMemberCell", bundle: nil), forCellReuseIdentifier: "groupMemberCell")
        
        self.clanCup.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
       
        self.clanCup.text = " 2575"
        self.groupTitle.AttributesOutLine(font: fonts().iPadfonts, title: "گروه", strokeWidth: -7.0)
        self.groupTitleForeGround.font = fonts().iPadfonts
        self.groupTitleForeGround.text = "گروه"
        
        self.clanName.text = "اینتر دیوانه"
        
        
        self.actionLargeButton.actionButton.addTarget(self, action: #selector(joinGroup), for: UIControlEvents.touchUpInside)
        setTitles()
        setGroupButtons()
        
       
    }
    
    
    @objc func setTitles() {
        self.actionLargeButton.setTitles(actionTitle: "عضویت در گروه", action1Title: "تنظیمات گروه", action2Title: "ارسال دعوتنامه", action3Title: "ترک کردن گروه")
    }
    
    @objc func setGroupButtons() {
        self.actionLargeButton.setButtons(hideAction: isJoined, hideAction1: !isCharge, hideAction2: !isJoined, hideAction3: !isJoined )
    }
    
    @objc func joinGroup() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closingGroupDetails(_ sender: RoundButton) {
        self.dismiss(animated : true , completion : nil)
    }


}
