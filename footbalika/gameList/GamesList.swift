//
//  GamesList.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import RealmSwift

class GamesList: UIViewController , UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var currentGames: RoundButton!
    
    @IBOutlet weak var endedGames: RoundButton!
    
    @IBOutlet weak var gameListTV: UITableView!
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        if self.gameListState == "currentGames"{
            gameLists(mode: "UNFINISHED_GAMES", isSplash: false)
        } else {
            gameLists(mode: "FINISHED_GAMES", isSplash: false)
        }
    }
    
    var realm : Realm!
    
    @objc func refreshingGameList() {
        PubProc.wb.showWaiting()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            PubProc.wb.hideWaiting()
            if self.gameListState == "currentGames"{
                self.gameLists(mode: "UNFINISHED_GAMES", isSplash: false)
            } else {
                self.gameLists(mode: "FINISHED_GAMES", isSplash: false)
            }
        }
    }
    
    var res :  gamesList.Response? = nil;
    
    
    @objc func gameLists(mode : String , isSplash : Bool) {
        if isSplash {
            PubProc.isSplash = true
        } else {
           PubProc.isSplash = false
        }
        PubProc.HandleDataBase.readJson(wsName: "ws_getMatchListData", JSONStr: "{'mode': '\(mode)','userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.res = try JSONDecoder().decode(gamesList.Response.self , from : data!)
                        
                        PubProc.isSplash = false
                        
                        DispatchQueue.main.async {
//                            if self.res?.response.count != 0 {
//                                self.gameListTV.isScrollEnabled = true
//                            } else {
//                                self.gameListTV.isScrollEnabled = false
//                            }
                            self.gameListTV.reloadData()
                            PubProc.wb.hideWaiting()
                            self.refreshControl.endRefreshing()
                        }
                        
                    } catch {
                        self.gameLists(mode: mode, isSplash: isSplash)
                        print(error)
                    }
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.gameLists(mode: mode, isSplash: isSplash)
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    private let refreshControl = UIRefreshControl()
    
    var gameListState = "currentGames"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameListTV.register(UINib(nibName: "NoGameCell", bundle: nil), forCellReuseIdentifier: "NoGameCell")

        realm = try? Realm()
        currentGamesListColor()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshingGameList), name: NSNotification.Name(rawValue: "reloadGameData"), object: nil)

        refreshControl.tintColor = UIColor.white
        
        if #available(iOS 10.0, *) {
            gameListTV.refreshControl = refreshControl
        } else {
            gameListTV.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let pageIndexDict:[String: Int] = ["button": 0]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
        if self.gameListState == "currentGames"{
            gameLists(mode: "UNFINISHED_GAMES", isSplash: true)
        } else {
            gameLists(mode: "FINISHED_GAMES", isSplash: true)
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.res != nil {
            if self.res?.response.count != 0 {
            return (self.res?.response.count)!
            } else {
                return 1
            }
        } else {
            return 0
        }
    }
    
    var urlClass = urls()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.res?.response.count != 0 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gamesCell", for: indexPath) as! gamesCell
        
            cell.result.text = "\((self.res?.response[indexPath.row].player1_result)!) _ \((self.res?.response[indexPath.row].player2_result)!)"
        if self.res?.response[indexPath.row].p_game_start != nil {
            cell.timeLabel.text = (self.res?.response[indexPath.row].p_game_start)!
        } else {
            cell.timeLabel.text = "چندی قبل"
        }
            cell.player1Level.text = (self.res?.response[indexPath.row].player1_level)!
            cell.player1Cup.text = (self.res?.response[indexPath.row].player1_cup)!
            cell.player1Name.text = (self.res?.response[indexPath.row].player1_username)!
            let url = "\(urlClass.avatar)\((self.res?.response[indexPath.row].player1_avatar)!)"
        
        let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
        if realmID.count != 0 {
            let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
            cell.player1Select.setImage(UIImage(data: dataDecoded as Data), for: .normal)
        } else {
            cell.player1Select.setImageWithKingFisher(url: url)
        }
        
            cell.player2Level.text = (self.res?.response[indexPath.row].player2_level)!
            cell.player2Cup.text = (self.res?.response[indexPath.row].player2_cup)!
            cell.player2Name.text = (self.res?.response[indexPath.row].player2_username)!
        
            let url2 = "\(urlClass.avatar)\((self.res?.response[indexPath.row].player2_avatar)!)"
        let realmID2 = self.realm.objects(tblShop.self).filter("image_path == '\(url2)'")
        if realmID2.count != 0 {
            let dataDecoded:NSData = NSData(base64Encoded: (realmID2.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
            cell.player2Select.setImage(UIImage(data: dataDecoded as Data), for: .normal)
        } else {
            cell.player2Select.setImageWithKingFisher(url: url2)
        }
        
        
        
        if (self.res?.response[indexPath.row].status_result)! == "MY_TURN" {
            cell.turnLabel.text = "نوبت شما"
            cell.turnLabel.textColor = UIColor.init(red: 184/255, green: 219/255, blue: 31/255, alpha: 1.0)
        } else if (self.res?.response[indexPath.row].status_result)! == "OTHER_TURN" {
            cell.turnLabel.text = "نوبت حریف"
            cell.turnLabel.textColor = UIColor.white
        } else if (self.res?.response[indexPath.row].status_result)! == "DRAW" {
                cell.turnLabel.text = "مساوی"
                cell.turnLabel.textColor = UIColor.init(red: 233/255, green: 241/255, blue: 0/255, alpha: 1.0)
            } else if (self.res?.response[indexPath.row].status_result)! == "WIN" {
                cell.turnLabel.text = "بردی"
                cell.turnLabel.textColor = UIColor.init(red: 184/255, green: 219/255, blue: 31/255, alpha: 1.0)
            } else if (self.res?.response[indexPath.row].status_result)! == "LOSE" {
                cell.turnLabel.text = "باختی"
                cell.turnLabel.textColor = UIColor.init(red: 238/255, green: 70/255, blue: 70/255, alpha: 1.0)
            } else if (self.res?.response[indexPath.row].status_result)! == "DEFER" {
                cell.turnLabel.text = "تسلیم"
                cell.turnLabel.textColor = UIColor.init(red: 255/255, green: 119/255, blue: 29/255, alpha: 1.0)
            } else if (self.res?.response[indexPath.row].status_result)! == "TIME_OUT" {
                cell.turnLabel.text = "وقت تمام شد"
                cell.turnLabel.textColor = UIColor.init(red: 255/255, green: 119/255, blue: 29/255, alpha: 1.0)
            }
            
            cell.player1Select.tag = indexPath.row
            cell.player1Select.addTarget(self, action: #selector(player1Select), for: UIControlEvents.touchUpInside)
            cell.player2Select.tag = indexPath.row
            cell.player2Select.addTarget(self, action: #selector(player2Select), for: UIControlEvents.touchUpInside)
//        }
        
        return cell
            
        } else {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoGameCell", for: indexPath) as! NoGameCell
        
        var font = UIFont()
        if UIDevice().userInterfaceIdiom == .phone {
            font = fonts().iPhonefonts
        } else {
            font = fonts().iPadfonts
        }
        let noGameTitle = "لیست بازی های شما خالی است"
        cell.noGameTitle.AttributesOutLine(font: font, title: noGameTitle, strokeWidth: 5.0)
        cell.noGameTitleForeGround.font = font
        cell.noGameTitleForeGround.text = noGameTitle
        return cell
    
    }
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.res?.response.count == 0 {
            return 100
        } else {
        
        if UIDevice().userInterfaceIdiom == .phone {
            return 160
        } else {
//            return  UIScreen.main.bounds.height / 7
            return 180
        }
        }
    }
    
    
    var selectedMatch = Int()
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedMatch = indexPath.row
        self.performSegue(withIdentifier: "continueMatch", sender: self)
    }
    
    
    func currentGamesListColor() {
        self.endedGames.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.currentGames.backgroundColor = UIColor.white
    }
    
    @IBAction func showCurrentGames(_ sender: RoundButton) {
        currentGamesListColor()
        self.gameListState = "currentGames"
        gameLists(mode: "UNFINISHED_GAMES", isSplash: false)
//        self.gameListTV.reloadData()
    }
    
    @IBAction func showEndedGames(_ sender: RoundButton) {
        self.currentGames.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.endedGames.backgroundColor = UIColor.white
        self.gameListState = "endedGames"
        gameLists(mode: "FINISHED_GAMES", isSplash: false)
//        self.gameListTV.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? startMatchViewController {
            vc.matchID = (self.res?.response[self.selectedMatch].id)!
            if self.gameListState == "currentGames" {
                 vc.showWinLoseTable = true
            } else {
                vc.showWinLoseTable = false
            }
        }
        if let vC = segue.destination as? menuViewController {
            vC.menuState = "profile"
            vC.profileResponse = self.userStructure
        }
    }
    
    @objc func player1Select(_ sender : UIButton!) {
        getUserData(id : (self.res?.response[sender.tag].player1_id)!)
    }
    
    @objc func player2Select(_ sender : UIButton!) {
        getUserData(id : (self.res?.response[sender.tag].player2_id)!)
    }
    
    var userStructure : loginStructure.Response? = nil
    @objc func getUserData(id : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(id)' , 'load_stadium' : 'false'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.userStructure = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        self.performSegue(withIdentifier: "showProfile", sender: self)
                        PubProc.wb.hideWaiting()
                    } catch {
                        self.getUserData(id : id)
                        print(error)
                    }
                    PubProc.countRetry = 0 
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.getUserData(id : id)
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
}
