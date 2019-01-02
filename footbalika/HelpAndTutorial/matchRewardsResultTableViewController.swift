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
        cell.mRT.viewCoin.helpImage.image = publicImages().coin
        cell.mRT.viewCoin.helpTitle.text = "\((gameDataModel.loadGameData?.response?.gameRewards[indexPath.row].coin!)!)"
        setTextColor(number: Int((gameDataModel.loadGameData?.response?.gameRewards[indexPath.row].coin!)!)!, label: cell.mRT.viewCoin.helpTitle)
        //cup Reward
        cell.mRT.viewCup.helpImage.image = publicImages().cup
        cell.mRT.viewCup.helpTitle.text = "\((gameDataModel.loadGameData?.response?.gameRewards[indexPath.row].cup!)!)"
        setTextColor(number: Int((gameDataModel.loadGameData?.response?.gameRewards[indexPath.row].cup!)!)!, label: cell.mRT.viewCup.helpTitle)

        //money Reward
        cell.mRT.viewMoney.helpImage.image = publicImages().money
        cell.mRT.viewMoney.helpTitle.text = "\((gameDataModel.loadGameData?.response?.gameRewards[indexPath.row].money!)!)"
        setTextColor(number: Int((gameDataModel.loadGameData?.response?.gameRewards[indexPath.row].money!)!)!, label: cell.mRT.viewMoney.helpTitle)

        // level Reward
        cell.mRT.viewLevel.helpImage.image = publicImages().badge
        cell.mRT.viewLevel.helpTitle.text = "\((gameDataModel.loadGameData?.response?.gameRewards[indexPath.row].xp!)!)"
         setTextColor(number: Int((gameDataModel.loadGameData?.response?.gameRewards[indexPath.row].xp!)!)!, label: cell.mRT.viewLevel.helpTitle)
        
        //main Title
       cell.mRT.matchTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\((gameDataModel.loadGameData?.response?.gameRewards[indexPath.row].title!)!)", strokeWidth: 8.0)
        cell.mRT.matchTitleForeGround.font = fonts().iPhonefonts
        cell.mRT.matchTitleForeGround.text = "\((gameDataModel.loadGameData?.response?.gameRewards[indexPath.row].title!)!)"
        
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
