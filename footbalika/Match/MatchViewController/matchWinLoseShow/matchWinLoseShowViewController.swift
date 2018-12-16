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
    
    var state = "WIN"
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
        
//        self.mainView.winLoseTable.viewCoin.helpImage.image = publicImages().coin
//        self.mainView.winLoseTable.viewCup.helpImage.image = publicImages().cup
//        self.mainView.winLoseTable.viewMoney.helpImage.image = publicImages().money
//        self.mainView.winLoseTable.viewLevel.helpImage.image = publicImages().badge
        
    }
    
    @objc func detectWinLose() {
        switch self.state {
        case "WIN" :
            print("\((loadingViewController.loadGameData?.response?.gameRewards[2].id!)!)")
            print("\((loadingViewController.loadGameData?.response?.gameRewards[2].title!)!)")
//            self.setTableNumbers(coin: <#T##String#>, money: <#T##String#>, level: <#T##String#>, cup: <#T##String#>)
        case "DRAW" :
            print("\((loadingViewController.loadGameData?.response?.gameRewards[3].id!)!)")
            print("\((loadingViewController.loadGameData?.response?.gameRewards[3].title!)!)")
//            self.setTableNumbers(coin: <#T##String#>, money: <#T##String#>, level: <#T##String#>, cup: <#T##String#>)
        case "LOSE" :
            print("\((loadingViewController.loadGameData?.response?.gameRewards[4].id!)!)")
            print("\((loadingViewController.loadGameData?.response?.gameRewards[4].title!)!)")
//            self.setTableNumbers(coin: <#T##String#>, money: <#T##String#>, level: <#T##String#>, cup: <#T##String#>)
        default :
            break
        }
    }
    
    @objc func setTableNumbers(coin : String , money : String , level : String , cup : String) {
        self.mainView.winLoseTable.viewCoin.helpTitle.text = coin
        self.mainView.winLoseTable.viewCup.helpTitle.text = cup
        self.mainView.winLoseTable.viewLevel.helpTitle.text = level
        self.mainView.winLoseTable.viewMoney.helpTitle.text = money
    }
    
    @objc func dismissing() {
        self.dismiss(animated: true, completion: nil)
    }
}
