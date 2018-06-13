//
//  matchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class matchViewController: UIViewController {

    @IBOutlet weak var startLabelForeGround: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var friendlyLabel: UILabel!
    @IBOutlet weak var eliminateCupLabel: UILabel!
    
    @IBAction func addMoney(_ sender: UIButton) {
        scrollPageViewController(index: 4)
        menuButtonChanged(index: 4)
    }

    @IBAction func addCoin(_ sender: UIButton) {
        scrollPageViewController(index: 4)
        menuButtonChanged(index: 4)
    }
    
    @objc func menuButtonChanged(index : Int) {
        let pageIndexDict:[String: Int] = ["button": index]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
    }
    
    @objc func scrollPageViewController(index : Int) {
        let pageIndexDict:[String: Int] = ["pageIndex": index]
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
    }
    
    var fonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    
    var menuState = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice().userInterfaceIdiom == .phone  {
        startLabel.AttributesOutLine(font: fonts, title: "شروع بازی", strokeWidth: 6.0)
        friendlyLabel.AttributesOutLine(font: UIFont(name: "DPA_Game", size: 18)!, title: "دوستانه", strokeWidth: -4.0)
        eliminateCupLabel.AttributesOutLine(font: UIFont(name: "DPA_Game", size: 18)!, title: "جام حذفی", strokeWidth: -4.0)
        startLabelForeGround.text =  "شروع بازی"
        startLabelForeGround.font = fonts
        } else {
        startLabel.AttributesOutLine(font: iPadfonts, title: "شروع بازی", strokeWidth: -4.0)
        friendlyLabel.AttributesOutLine(font: iPadfonts, title: "دوستانه", strokeWidth: -4.0)
        eliminateCupLabel.AttributesOutLine(font: iPadfonts, title: "جام حذفی", strokeWidth: -4.0)
        startLabelForeGround.text =  "شروع بازی"
        startLabelForeGround.font = iPadfonts
            
        }
        
        self.startLabelForeGround.minimumScaleFactor = 0.5
        self.startLabel.minimumScaleFactor = 0.5
        self.friendlyLabel.minimumScaleFactor = 0.5
        self.eliminateCupLabel.minimumScaleFactor = 0.5
        self.startLabel.adjustsFontSizeToFitWidth = true
        self.startLabelForeGround.adjustsFontSizeToFitWidth = true
        self.friendlyLabel.adjustsFontSizeToFitWidth = true
        self.eliminateCupLabel.adjustsFontSizeToFitWidth = true


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        let pageIndexDict:[String: Int] = ["button": 2]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)

    }
    
    @IBAction func achievements(_ sender: RoundButton) {
        self.menuState = "Achievements"
        self.performSegue(withIdentifier: "achievement", sender: self)
    }
    
    @IBAction func setting(_ sender: RoundButton) {
        self.menuState = "Settings"
        self.performSegue(withIdentifier: "achievement", sender: self)
    }
    
    
    
    
    @IBAction func eliminateCupAction(_ sender: RoundButton) {
        scrollPageViewController(index: 1)
        menuButtonChanged(index: 1)
    }
    
    @IBAction func StartAMatch(_ sender: RoundButton) {
        self.performSegue(withIdentifier: "startingMatch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vC = segue.destination as? menuViewController {
            vC.menuState = self.menuState
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
