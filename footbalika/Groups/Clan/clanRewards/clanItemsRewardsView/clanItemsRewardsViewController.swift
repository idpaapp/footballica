//
//  clanItemsRewardsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/14/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class clanItemsRewardsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var itemView: itemReawrdView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clanRewardsCell", for: indexPath) as! clanRewardsCell
        
        cell.rewardImage.image = list[indexPath.row]
        cell.rewardTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(amounts[indexPath.row])", strokeWidth: 8.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    var alphaTimer : Timer!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        alphaTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAlpha), userInfo: nil, repeats: true)
    }
    
    var rewardsItems : warRewards.reward? = nil
    var list = [UIImage]()
    var amounts = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPlay().playBuyItem()
        self.itemView.rewardsTV.register(UINib(nibName: "clanRewardsCell", bundle: nil), forCellReuseIdentifier: "clanRewardsCell")
        self.itemView.rewardsTV.delegate = self
        self.itemView.rewardsTV.dataSource = self
        
        setOutlets()
        checkRewards()
    }
    
    @objc func updateAlpha() {
        if self.itemView.shinyImage.alpha != 1.0 {
            UIView.animate(withDuration: 1.0) {
                self.itemView.shinyImage.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.itemView.shinyImage.alpha = 0.3
            }
        }
    }
    
    func checkRewards() {
        if rewardsItems != nil {
            if rewardsItems?.gold != 0 {
                self.list.append(publicImages().coin!)
                self.amounts.append((rewardsItems?.gold)!)
            }
            if rewardsItems?.money != 0 {
                self.list.append(publicImages().money!)
                self.amounts.append((rewardsItems?.money)!)
            }
            if rewardsItems?.bomb != 0 {
                self.list.append(publicImages().bomb!)
                self.amounts.append((rewardsItems?.bomb)!)
            }
            if rewardsItems?.freeze != 0 {
                self.list.append(publicImages().freezeTimer!)
                self.amounts.append((rewardsItems?.freeze)!)
            }
            DispatchQueue.main.async {
                self.itemView.rewardsTV.reloadData()
            }
        }
    }
    
    func setOutlets() {
        self.itemView.buttonTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "دریافت", strokeWidth: 8.0)
        self.itemView.buttonTitleForeGround.font = fonts().iPhonefonts
        self.itemView.buttonTitleForeGround.text = "دریافت"
        
        self.itemView.headerTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "جایزه شما", strokeWidth: 8.0)
        self.itemView.headerTitleForeGround.font = fonts().iPhonefonts
        self.itemView.headerTitleForeGround.text = "جایزه شما"
        
        self.itemView.receiveGift.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
    }
    
    @objc func dismissing() {
        self.dismiss(animated: true, completion: nil)
    }
}
