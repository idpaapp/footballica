//
//  matchRewardsResultTableViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class matchRewardsResultTableViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var window: windows!
    
    @IBOutlet weak var matchResultTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWindow()
        setTVDataSource()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchHelpTVCell", for: indexPath) as! matchHelpTVCell        
        
        //coin Reward
        cell.viewCoin.helpImage.image = publicImages().coin
        cell.viewCoin.helpTitle.text = "\((loadingViewController.loadGameData?.response?.gameRewards[indexPath.row].coin!)!)"
        setTextColor(number: Int((loadingViewController.loadGameData?.response?.gameRewards[indexPath.row].coin!)!)!, label: cell.viewCoin.helpTitle)
        //cup Reward
        cell.viewCup.helpImage.image = publicImages().cup
        cell.viewCup.helpTitle.text = "\((loadingViewController.loadGameData?.response?.gameRewards[indexPath.row].cup!)!)"
        setTextColor(number: Int((loadingViewController.loadGameData?.response?.gameRewards[indexPath.row].cup!)!)!, label: cell.viewCup.helpTitle)

        //money Reward
        cell.viewMoney.helpImage.image = publicImages().money
        cell.viewMoney.helpTitle.text = "\((loadingViewController.loadGameData?.response?.gameRewards[indexPath.row].money!)!)"
        setTextColor(number: Int((loadingViewController.loadGameData?.response?.gameRewards[indexPath.row].money!)!)!, label: cell.viewMoney.helpTitle)

        // level Reward
        cell.viewLevel.helpImage.image = publicImages().badge
        cell.viewLevel.helpTitle.text = "\((loadingViewController.loadGameData?.response?.gameRewards[indexPath.row].xp!)!)"
         setTextColor(number: Int((loadingViewController.loadGameData?.response?.gameRewards[indexPath.row].xp!)!)!, label: cell.viewLevel.helpTitle)
        
        //main Title
       cell.matchTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\((loadingViewController.loadGameData?.response?.gameRewards[indexPath.row].title!)!)", strokeWidth: 8.0)
        cell.matchTitleForeGround.font = fonts().iPhonefonts
        cell.matchTitleForeGround.text = "\((loadingViewController.loadGameData?.response?.gameRewards[indexPath.row].title!)!)"
        
        return cell
    }
    
    @objc func setTextColor(number : Int , label : UILabel) {
        switch number {
        case 0:
            label.textColor = UIColor.orange
        case ..<0 :
            label.textColor = UIColor.red
        default:
            label.textColor = UIColor.darkGray
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @objc func setTVDataSource() {
        self.matchResultTV.register(UINib(nibName: "matchHelpTVCell", bundle: nil), forCellReuseIdentifier: "matchHelpTVCell")
    }
    
    @objc func  setWindow() {
        window.addSubview(self.matchResultTV)
        window.closePage.addTarget(self, action: #selector(setDismissing), for: UIControlEvents.touchUpInside)
    }
    
    @objc func setDismissing() {
        self.dismiss(animated: true, completion: nil)
    }

}
