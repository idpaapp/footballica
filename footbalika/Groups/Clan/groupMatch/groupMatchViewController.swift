//
//  groupMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/30/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class groupMatchViewController: UIViewController {

    @IBOutlet weak var startGameButton: actionLargeButton!
    
    @IBOutlet weak var bombCount: UILabel!
    
    @IBOutlet weak var freezeCount: UILabel!
    
    @IBOutlet weak var magnifier: UIImageView!
    
    @IBOutlet weak var ronaldoAndMessi: UIImageView!
    
    var state = "Searching"
    var isCharge = false
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc func updateGroupMatch(state : String , isCharge : Bool) {
        switch state {
        case "Searching" :
            self.ronaldoAndMessi.isHidden = true
            self.magnifier.isHidden = false
        default :
            self.ronaldoAndMessi.isHidden = false
            self.magnifier.isHidden = true
            if isCharge {
                self.startGameButton.isHidden = false
            } else {
                self.startGameButton.isHidden = true
            }
        }
        self.bombCount.text = "2"
        self.freezeCount.text = "2"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGroupMatch(state: self.state, isCharge: self.isCharge)
        setStartGroupGameButton()
    }
    
    
    @objc func setStartGroupGameButton() {
    self.startGameButton.setButtons(hideAction: false, hideAction1: true, hideAction2: true, hideAction3: true)
    self.startGameButton.setTitles(actionTitle: "شروع بازی گروهی", action1Title: "", action2Title: "", action3Title: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            viewDidLayoutSubviews()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if state == "Searching" {
        var heightOfButtomMenu = CGFloat()
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                heightOfButtomMenu = 135
            } else {
                heightOfButtomMenu = 85
            }
        } else {
            heightOfButtomMenu = 135
        }
        self.magnifier.animatingImageView(Radius : 50, circleCenter: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - heightOfButtomMenu))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
