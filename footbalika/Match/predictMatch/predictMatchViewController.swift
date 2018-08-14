//
//  predictMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/21/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class predictMatchViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var yourScoreTitle: UILabel!
    @IBOutlet weak var yourScoreTitleForeGround: UILabel!
    
    @IBOutlet weak var leaderBoardConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var pageTitleForeGround: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if state == "today" || state == "past" {
        return 150
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if state == "today" || state == "past" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! todayCell
        
        cell.mainTitle.text = "زمان شروع بازی : 15:00"
        cell.team1Title.text = "شموشک"
        cell.team2Title.text = "نفت اراک"
        cell.team1Resault.text = "5"
        cell.team2Resault.text = "3"
        
        return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "predictLeaderBoardCell", for: indexPath) as! predictLeaderBoardCell
            
            cell.userAvatar.image = UIImage(named: "avatar")
            cell.userName.text = "پلنگ"
            cell.number.text = "\(indexPath.row + 1)"
            cell.userScore.text = "\(Int(arc4random_uniform(75)))"
            return cell
        }
    }
    

    @IBOutlet weak var predictMatchTV: UITableView!
    
    @IBOutlet weak var todayOutlet: RoundButton!
    
    @IBOutlet weak var predictLeaderBoardOutlet: RoundButton!
    
    @IBOutlet weak var pastOutlet: RoundButton!
    
    var state = "today"
    
    func scoreAnimation() {
        if yourScoreTitle.transform.isIdentity {
            UIView.animate(withDuration: 0.7) {
                self.yourScoreTitle.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
                self.yourScoreTitleForeGround.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
            }
        } else {
            UIView.animate(withDuration: 0.7) {
                self.yourScoreTitle.transform = CGAffineTransform.identity
                self.yourScoreTitleForeGround.transform = CGAffineTransform.identity
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now () + 0.7) {
            self.scoreAnimation()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yourScoreTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "امتیاز شما", strokeWidth: -6.0)
        yourScoreTitleForeGround.font = fonts().iPadfonts25
        yourScoreTitleForeGround.text = "امتیاز شما"
        scoreAnimation()
        self.leaderBoardConstraint.constant = 0
        pageTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "پیش بینی", strokeWidth: -6.0)
        pageTitleForeGround.font = fonts().iPadfonts25
        pageTitleForeGround.text = "پیش بینی"
        self.todayOutlet.backgroundColor = UIColor.white

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func todayAction(_ sender: RoundButton) {
        self.predictLeaderBoardOutlet.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.pastOutlet.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.todayOutlet.backgroundColor = UIColor.white
        state = "today"
        self.predictMatchTV.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.leaderBoardConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func predictLeaderBoardAction(_ sender: RoundButton) {
        self.todayOutlet.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.pastOutlet.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.predictLeaderBoardOutlet.backgroundColor = UIColor.white
        state = "leaderBoard"
        self.predictMatchTV.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.leaderBoardConstraint.constant = 40
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func pastAction(_ sender: RoundButton) {
        self.todayOutlet.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.predictLeaderBoardOutlet.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.pastOutlet.backgroundColor = UIColor.white
        state = "past"
        self.predictMatchTV.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.leaderBoardConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func dismissing(_ sender: RoundButton) {
        self.dismiss(animated : true , completion: nil)
    }
    
    
    
    
    
}
