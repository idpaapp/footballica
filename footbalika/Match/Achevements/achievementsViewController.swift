//
//  achievementsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/22/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

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

    var res : leaderBoard.Response? = nil ;
    var userNames = [String]()
    var userImages = [String]()
    var userCups = [String]()
    var userLogo = [String]()
    @objc func leaderBoardJson() {
        
            PubProc.HandleDataBase.readJson(wsName: "ws_getLeaderBoard", JSONStr: "{}") { data, error in
                DispatchQueue.main.async {
                    
                    if data != nil {
                        
                        //                print(data ?? "")
                        
                        do {
                            
                            self.res = try JSONDecoder().decode(leaderBoard.Response.self , from : data!)

                            for i in  0...(self.res?.response?.count)! - 1 {
                                self.userNames.append((self.res?.response?[i].username!)!)
                                self.userImages.append((self.res?.response?[i].avatar!)!)
                                self.userCups.append((self.res?.response?[i].cups!)!)
                                self.userLogo.append((self.res?.response?[i].badge_name!)!)
                            }
                            DispatchQueue.main.async {
                                self.achievementCount = (self.res?.response?.count)!
                                self.achievementsTV.reloadData()
                            }
                        } catch {
                            self.leaderBoardJson()
                            print(error)
                        }
                    } else {
                        self.leaderBoardJson()
                        print("Error Connection")
                        print(error as Any)
                        // handle error
                    }
                }
                }.resume()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if pageState == "LeaderBoard" {
            leaderBoardJson()
        }
        switchStates.append(playgameSounds)
        switchStates.append(playMenuMusic)
        switchStates.append(alerts)
        
        if pageState != "LeaderBoard" {
        for _ in 0...achievementCount - 1 {
            achievementsProgress.append(0.5)
            achievementsTitles.append("تیتر")
        }
        }
         if pageState == "Achievements" {
            self.achievementsTV.bounces = true
            self.achievementsTV.isScrollEnabled = true
         } else if pageState == "LeaderBoard" {
            self.achievementsTV.bounces = true
            self.achievementsTV.isScrollEnabled = true
         } else if self.pageState == "alerts" {
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
        if pageState == "Achievements" {
        return (loadingAchievements.res?.response?.count)!
        } else {
          return achievementCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if pageState == "Achievements" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "achievementsCell", for: indexPath) as! achievementsCell
            
//            print((loadingAchievements.res?.response?[indexPath.row].level_gain_reward!)!)
//            print((loadingAchievements.res?.response?[indexPath.row].cash_reward!)!)
//            print((loadingAchievements.res?.response?[indexPath.row].coin_reward!)!)
//            print((loadingAchievements.res?.response?[indexPath.row].progress!)!)

            cell.coinLabel.text = (loadingAchievements.res?.response?[indexPath.row].coin_reward!)!
            cell.moneyLabel.text = (loadingAchievements.res?.response?[indexPath.row].cash_reward!)!

        if UIDevice().userInterfaceIdiom == .phone {
            cell.progressTitle.AttributesOutLine(font: iPhonefonts, title: "\((loadingAchievements.res?.response?[indexPath.row].progress)!)/10", strokeWidth: -3.0)
            cell.acievementTitle.AttributesOutLine(font: iPhonefonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: -4.0)
        } else {
            cell.progressTitle.AttributesOutLine(font: iPadfonts, title: "\((loadingAchievements.res?.response?[indexPath.row].progress)!)/10", strokeWidth: -3.0)
            cell.acievementTitle.AttributesOutLine(font: iPadfonts, title: "\((loadingAchievements.res?.response?[indexPath.row].title!)!)", strokeWidth: -4.0)
        }
        cell.achievementDesc.text = "\((loadingAchievements.res?.response?[indexPath.row].describtion!)!)"
            let progressAchievement = (Float((loadingAchievements.res?.response?[indexPath.row].progress)!)!) / 10.0
            print("progress\(progressAchievement)")
        cell.achievementProgress.progress = progressAchievement
        return cell
         
        } else if pageState == "LeaderBoard" {

            let cell = tableView.dequeueReusableCell(withIdentifier: "leaderBoardCell", for: indexPath) as! leaderBoardCell
            
            cell.number.text = "\(indexPath.row + 1)"
            cell.playerName.text = "\(userNames[indexPath.row])"
            let url = "http://volcan.ir/adelica/images/avatars/\(self.userImages[indexPath.row])"
            let urls = URL(string : url)
            cell.avatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
            let url2 = "http://volcan.ir/adelica/images/badge/\(self.userLogo[indexPath.row])"
            let urls2 = URL(string : url2)
            cell.playerLogo.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
            cell.playerCup.text = "\(self.userCups[indexPath.row])"
            return cell

            
        } else if self.pageState == "alerts" {
            
            
            
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "googleEntranceCell", for: indexPath) as! googleEntranceCell
                
                
                return cell
            } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! settingsCell

                if UIDevice().userInterfaceIdiom == .phone {
                cell.settingLabel.AttributesOutLine(font: iPhonefonts, title: "\(settingsTitle[indexPath.row - 1])", strokeWidth: -7.0)
                cell.settingLabelForeGround.font = iPhonefonts
                } else {
                    cell.settingLabel.AttributesOutLine(font: iPadfonts, title: "\(settingsTitle[indexPath.row - 1])", strokeWidth: -7.0)
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
            
        } else if pageState == "LeaderBoard" {
            
            if UIDevice().userInterfaceIdiom == .phone {
                return 70
            } else {
                return 100
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
