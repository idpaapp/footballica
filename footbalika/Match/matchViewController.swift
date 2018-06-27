//
//  matchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

class matchViewController: UIViewController {

    @IBOutlet weak var startLabelForeGround: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var friendlyLabel: UILabel!
    @IBOutlet weak var eliminateCupLabel: UILabel!
    @IBOutlet weak var mainCupImage: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var cup: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var xp: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var coin: UILabel!
    @IBOutlet weak var xpProgress: UIProgressView!
    @IBOutlet weak var xpProgressBackGround: UIView!
    
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
    
//     var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
//     var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    
    var menuState = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        level.text = (login.res?.response?.mainInfo?.level)!
        money.text = (login.res?.response?.mainInfo?.cashs)!
        xp.text = "\((login.res?.response?.mainInfo?.max_points_gain)!)/\((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)"
        coin.text = (login.res?.response?.mainInfo?.coins)!
        xp.minimumScaleFactor = 0.5
        xp.adjustsFontSizeToFitWidth = true
        xpProgressBackGround.layer.cornerRadius  = 3
        profileName.text = (login.res?.response?.mainInfo?.username)!
        cup.text = (login.res?.response?.mainInfo?.cups)!
        self.xpProgress.progress = 0.0
        let urlAvatar = "http://volcan.ir/adelica/images/avatars/\((login.res?.response?.mainInfo?.avatar)!)"
        let urlsurlAvatar = URL(string: urlAvatar)
        avatar.kf.setImage(with: urlsurlAvatar ,options:[.transition(ImageTransition.fade(0.5))])
        
        let url = "\((loadingViewController.loadGameData?.response?.gameLeagues[Int((login.res?.response?.mainInfo?.league_id)!)!].img_logo!)!)"
        
        let urls = URL(string: url)
        mainCupImage.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
        if UIDevice().userInterfaceIdiom == .phone  {
        startLabel.AttributesOutLine(font: fonts.init().iPhonefonts, title: "شروع بازی", strokeWidth: 6.0)
        friendlyLabel.AttributesOutLine(font: UIFont(name: "DPA_Game", size: 18)!, title: "دوستانه", strokeWidth: -4.0)
        eliminateCupLabel.AttributesOutLine(font: UIFont(name: "DPA_Game", size: 18)!, title: "جام حذفی", strokeWidth: -4.0)
        startLabelForeGround.text =  "شروع بازی"
        startLabelForeGround.font = fonts.init().iPhonefonts
        } else {
        startLabel.AttributesOutLine(font: fonts.init().iPadfonts, title: "شروع بازی", strokeWidth: -4.0)
        friendlyLabel.AttributesOutLine(font: fonts.init().iPadfonts, title: "دوستانه", strokeWidth: -4.0)
        eliminateCupLabel.AttributesOutLine(font: fonts.init().iPadfonts, title: "جام حذفی", strokeWidth: -4.0)
        startLabelForeGround.text =  "شروع بازی"
        startLabelForeGround.font = fonts.init().iPadfonts
            
        }
        
        self.startLabelForeGround.minimumScaleFactor = 0.5
        self.startLabel.minimumScaleFactor = 0.5
        self.friendlyLabel.minimumScaleFactor = 0.5
        self.eliminateCupLabel.minimumScaleFactor = 0.5
        self.startLabel.adjustsFontSizeToFitWidth = true
        self.startLabelForeGround.adjustsFontSizeToFitWidth = true
        self.friendlyLabel.adjustsFontSizeToFitWidth = true
        self.eliminateCupLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let pageIndexDict:[String: Int] = ["button": 2]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
        self.xpProgress.progress = 0.0
        DispatchQueue.main.async {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.xpProgress.setProgress(Float((login.res?.response?.mainInfo?.max_points_gain)!)! / Float((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)!, animated: true)
        })
        }
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
        if let vc = segue.destination as? giftsAndChargesViewController {
            vc.pageState = self.menuState
        }
        
        if let VC = segue.destination as? menuAlertViewController {
            VC.alertTitle = "اخطار"
            VC.alertBody = "بخش کارخانه سوال به زودی راه اندازی خواهد شد"
            VC.alertAcceptLabel = "تأیید"
        }
    }
    
    @IBAction func showLeagus(_ sender: UIButton) {
        self.performSegue(withIdentifier: "leagueShow", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gifts(_ sender: RoundButton) {
        self.menuState = "gifts"
        self.performSegue(withIdentifier: "giftsAndCharges", sender: self)
    }
    @IBAction func gameCharge(_ sender: RoundButton) {
        self.menuState = "gameCharge"
        self.performSegue(withIdentifier: "giftsAndCharges", sender: self)
    }
    
    
    @IBAction func questionsBank(_ sender: RoundButton) {
        self.performSegue(withIdentifier: "alert", sender: self)
    }
    
    @IBAction func showLeaderBoard(_ sender: RoundButton) {
        self.menuState = "LeaderBoard"
        self.performSegue(withIdentifier: "achievement", sender: self)
    }
    
    @IBAction func alerts(_ sender: RoundButton) {
        self.menuState = "alerts"
        self.performSegue(withIdentifier: "achievement", sender: self)
    }
    
    
    
}
