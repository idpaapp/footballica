//
//  achievementsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/13/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class menuViewController: UIViewController {
    
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    
    @IBOutlet weak var menuWidth: NSLayoutConstraint!
    
    @IBOutlet weak var mainBackGround: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var maintitle: UILabel!
    
    @IBOutlet weak var mainTitleForeGround: UILabel!
    
    @IBOutlet weak var subMainBackGround: UIView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    
    var menuState = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.mainBackGround.layer.cornerRadius = 15
        self.topView.layer.cornerRadius = 15
        self.subMainBackGround.layer.cornerRadius = 15
        self.mainTitleForeGround.text = "دستاوردها"

        if UIDevice().userInterfaceIdiom == .phone {
        maintitle.AttributesOutLine(font: iPhonefonts, title: "دستاوردها", strokeWidth: -4.0)
            self.mainTitleForeGround.font = iPhonefonts
        } else {
            maintitle.AttributesOutLine(font: iPadfonts, title: "دستاوردها", strokeWidth: -4.0)
            self.mainTitleForeGround.font = iPadfonts
        }
        
        if menuState == "Achievements" {
            if UIDevice().userInterfaceIdiom == .phone {
                self.menuHeight.constant = ((8 * UIScreen.main.bounds.height) / 9)
                self.menuWidth.constant = 280
            } else {
                self.menuHeight.constant = ((8 * UIScreen.main.bounds.height) / 9)
                self.menuWidth.constant = 550
            }
        } else {
            if UIDevice().userInterfaceIdiom == .phone {
            self.menuHeight.constant = 318
            self.menuWidth.constant = 280
            } else {
             self.menuHeight.constant = 418
             self.menuWidth.constant = 370
            }
        }
    }

    @objc func dismissing() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func crossDismiss(_ sender: UIButton) {
        dismissing()
    }
    @IBAction func dismissAction(_ sender: UIButton) {
        dismissing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vC = segue.destination as? achievementsViewController {
            vC.pageState = self.menuState
            if self.menuState == "Achievements" {
                vC.achievementCount = 10
            } else {
                vC.achievementCount = 4
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
