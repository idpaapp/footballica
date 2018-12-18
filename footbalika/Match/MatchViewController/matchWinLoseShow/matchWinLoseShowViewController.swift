//
//  matchWinLoseShowViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/25/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class matchWinLoseShowViewController: UIViewController {

    @IBOutlet weak var mainView: matchWinLoseShowView!
    
    var state = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOutlets()
        detectWinLose()
    }

    @objc func setOutlets() {
        self.mainView.okButton.setTitles(actionTitle: "خب", action1Title: "", action2Title: "", action3Title: "")
        self.mainView.okButton.setButtons(hideAction: false, hideAction1: true, hideAction2: true, hideAction3: true)
        self.mainView.okButton.actionButton.addTarget(self, action: #selector(dismissing), for: UIControl.Event.touchUpInside)
        self.mainView.mainWindow.closePage.addTarget(self, action: #selector(dismissing), for: UIControl.Event.touchUpInside)
        self.mainView.winLoseTable.viewCoin.helpImage.image = publicImages().coin
        self.mainView.winLoseTable.viewCup.helpImage.image = publicImages().cup
        self.mainView.winLoseTable.viewMoney.helpImage.image = publicImages().money
        self.mainView.winLoseTable.viewLevel.helpImage.image = publicImages().badge
        self.mainView.winLoseTable.matchTitle.textAlignment = .center
        self.mainView.winLoseTable.matchTitleForeGround.textAlignment = .center
    }
    
    @objc func detectWinLose() {
        switch self.state {
        case "WIN" :
            soundPlay().playSpecialSound(name : "league_up")
           stateOfGame(number: 1)
        case "DRAW" :
            stateOfGame(number: 2)
        case "LOSE" :
            soundPlay().playSpecialSound(name : "league_down")
            stateOfGame(number: 3)
        default :
            break
        }
    }
    
    
    @objc func stateOfGame(number : Int) {
        self.setTableNumbers(coin: "\((loadingViewController.loadGameData?.response?.gameRewards[number].coin!)!)", money: "\((loadingViewController.loadGameData?.response?.gameRewards[number].money!)!)", level: "\((loadingViewController.loadGameData?.response?.gameRewards[number].xp!)!)", cup: "\((loadingViewController.loadGameData?.response?.gameRewards[number].cup!)!)", TopTitle: "\((loadingViewController.loadGameData?.response?.gameRewards[number].title!)!)ی")
    }
    
    @objc func setTableNumbers(coin : String , money : String , level : String , cup : String , TopTitle : String) {
        self.mainView.winLoseTable.viewCoin.helpTitle.text = coin
        self.mainView.winLoseTable.viewCup.helpTitle.text = cup
        self.mainView.winLoseTable.viewLevel.helpTitle.text = level
        self.mainView.winLoseTable.viewMoney.helpTitle.text = money
        var topT = String()
        switch self.state {
        case "WIN":
            self.mainView.winLoseTable.matchTitleForeGround.textColor = publicColors().winColor
            topT = TopTitle
        case "DRAW":
            topT = String(TopTitle.dropLast(1))
        case "LOSE":
            self.mainView.winLoseTable.matchTitleForeGround.textColor = publicColors().lostColor
            topT = TopTitle
        default:
            topT = TopTitle
        }
        self.mainView.winLoseTable.matchTitle.AttributesOutLine(font: fonts().iPhonefonts, title: topT, strokeWidth: 8.0)
        self.mainView.winLoseTable.matchTitleForeGround.font = fonts().iPhonefonts
        self.mainView.winLoseTable.matchTitleForeGround.text = topT
    }
    
    @objc func dismissing() {
        self.dismiss(animated: true, completion: nil)
    }
}
