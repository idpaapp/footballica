//
//  achievementsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/22/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class achievementsViewController : UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var achievementsTV: UITableView!

    var pageState = String()
    var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    var settingsTitle = ["صداهای بازی",
                         "موسیقی بازی",
                         "اعلان ها"]
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var switchStates = [Bool]()
    
    let playgameSounds = UserDefaults.standard.bool(forKey: "gameSounds")
    let playMenuMusic = UserDefaults.standard.bool(forKey: "menuMusic")
    let alerts = UserDefaults.standard.bool(forKey: "alerts")

    
    override func viewDidLoad() {
        super.viewDidLoad()

        switchStates.append(playgameSounds)
        switchStates.append(playMenuMusic)
        switchStates.append(alerts)
        
        for _ in 0...achievementCount - 1 {
            achievementsProgress.append(0.5)
            achievementsTitles.append("تیتر")
        }
        
         if pageState == "Achievements" {
            self.achievementsTV.bounces = true
            self.achievementsTV.isScrollEnabled = true
         } else {
            self.achievementsTV.bounces = false
            self.achievementsTV.isScrollEnabled = false
        }
    }
    
    var achievementCount = Int()
    var achievementsProgress = [Float]()
    var achievementsTitles = [String]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievementCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if pageState == "Achievements" {
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
            
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "googleEntranceCell", for: indexPath) as! googleEntranceCell
                
                
                return cell
            } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! settingsCell

                if UIDevice().userInterfaceIdiom == .phone {
                cell.settingLabel.AttributesOutLine(font: iPhonefonts, title: "\(settingsTitle[indexPath.row - 1])", strokeWidth: -4.0)
                cell.settingLabelForeGround.font = iPhonefonts
                } else {
                    cell.settingLabel.AttributesOutLine(font: iPadfonts, title: "\(settingsTitle[indexPath.row - 1])", strokeWidth: -4.0)
                    cell.settingLabelForeGround.font = iPadfonts
                }
                cell.settingLabelForeGround.text = "\(settingsTitle[indexPath.row - 1])"
                cell.switchSet.tag = indexPath.row - 1
                cell.switchSet.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
                cell.switchSet.setOn(switchStates[indexPath.row - 1], animated: false)
                
                if cell.switchSet.isOn {
                    if let ThumbImg = UIImage(named: "ic_green_ball") {
                        cell.switchSet.thumbTintColor = UIColor(patternImage: ThumbImg)
                    }
                } else {
                    if let ThumbImg = UIImage(named: "ic_red_ball") {
                        cell.switchSet.thumbTintColor = UIColor(patternImage: ThumbImg)
                    }
                }
                
        return cell
            }
        }
        
    }
    
    
    let playingMusic = musicPlay()
    let playSound = soundPlay()
    
    @objc func switchChanged(_ sender : UISwitch!) {
         if (sender.isOn == true){
            switchStates[sender.tag] = true
            UserDefaults.standard.set(switchStates[0], forKey: "gameSounds")
            UserDefaults.standard.set(switchStates[1], forKey: "menuMusic")
            UserDefaults.standard.set(switchStates[2], forKey: "alerts")
         } else {
            switchStates[sender.tag] = false
            UserDefaults.standard.set(switchStates[0], forKey: "gameSounds")
            UserDefaults.standard.set(switchStates[1], forKey: "menuMusic")
            UserDefaults.standard.set(switchStates[2], forKey: "alerts")
        }
        playSound.playClick()
        if sender.tag == 1 {
            playingMusic.playMusic()
        }
        
        UIView.performWithoutAnimation {
            self.achievementsTV.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if pageState == "Achievements" {
        if UIDevice().userInterfaceIdiom == .phone {
            return 150
        } else {
            return 220
            }
        } else {
            if indexPath.row == 0 {
                if UIDevice().userInterfaceIdiom == .phone {
                    return 60
                } else {
                    return 100
                }
            } else {
          if UIDevice().userInterfaceIdiom == .phone {
                return 70
            } else {
                return 90
            }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
