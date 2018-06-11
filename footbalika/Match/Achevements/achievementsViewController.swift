//
//  achievementsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/13/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class achievementsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var mainBackGround: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var maintitle: UILabel!
    
    @IBOutlet weak var subMainBackGround: UIView!
    
    @IBOutlet weak var achievementsTV: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    
    var achievementCount = Int()
    var achievementsProgress = [Float]()
    var achievementsTitles = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        achievementCount = 10
        for _ in 0...achievementCount - 1 {
            achievementsProgress.append(0.5)
            achievementsTitles.append("تیتر")
        }
    self.mainBackGround.layer.cornerRadius = 15
        self.topView.layer.cornerRadius = 15
        self.subMainBackGround.layer.cornerRadius = 15
        if UIDevice().userInterfaceIdiom == .phone {
        maintitle.AttributesOutLine(font: iPhonefonts, title: "دستاوردها", strokeWidth: -4.0)
        } else {
            maintitle.AttributesOutLine(font: iPadfonts, title: "دستاوردها", strokeWidth: -4.0)
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievementCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "achievementsCell", for: indexPath) as! achievementsCell
        if UIDevice().userInterfaceIdiom == .phone {
        cell.progressTitle.AttributesOutLine(font: iPhonefonts, title: "5/10", strokeWidth: -3.0)
        cell.acievementTitle.AttributesOutLine(font: iPhonefonts, title: achievementsTitles[indexPath.row], strokeWidth: -4.0)
        } else {
        cell.progressTitle.AttributesOutLine(font: iPadfonts, title: "5/10", strokeWidth: -3.0)
        cell.acievementTitle.AttributesOutLine(font: iPadfonts, title: achievementsTitles[indexPath.row], strokeWidth: -4.0)
        }
        cell.achievementDesc.text = "تو بازی همه رو ببر "
        cell.achievementProgress.progress = achievementsProgress[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
        return 150
        } else {
        return 220
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
