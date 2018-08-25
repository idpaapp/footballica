//
//  GamesList.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

class GamesList: UIViewController , UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var currentGames: RoundButton!
    
    @IBOutlet weak var endedGames: RoundButton!
    
    @IBOutlet weak var gameListTV: UITableView!
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        gameLists()
    }
    
    var res :  gamesList.Response? = nil;
    var res0 : gamesList.Response? = nil;
    var res1 : gamesList.Response? = nil;
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        gameLists()
    }
    
    @objc func gameLists() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_getMatchList", JSONStr: "{'mode': 'USERMATCH','userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.res = try JSONDecoder().decode(gamesList.Response.self , from : data!)
                        
                        
                        guard let res = self.res else {
                            print("res not found")
                            return
                        }

                        let playerStatuses = res.response.filter { $0.status != nil }
                        let playersWithStatus1 = playerStatuses.filter({ $0.status == "1" })
                        let playersWithStatus0 = playerStatuses.filter({ $0.status != "1" })
                        
                        self.res0 = gamesList.Response(status: "1", response: playersWithStatus1)
                        self.res1 = gamesList.Response(status: "0", response: playersWithStatus0)
                        
                        DispatchQueue.main.async {
                            self.gameListTV.reloadData()
                            PubProc.wb.hideWaiting()
                            self.refreshControl.endRefreshing()
                        }
                        
                        
                        
                    } catch {
                        self.gameLists()
                        print(error)
                    }
                } else {
                    self.gameLists()
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
        
        gameLists()
        currentGamesListColor()
        NotificationCenter.default.addObserver(self, selector: #selector(gameLists), name: NSNotification.Name(rawValue: "reloadGameData"), object: nil)

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
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.res != nil {
             if self.gameListState == "currentGames" {
                if self.res0?.response.count != nil {
                    return ((self.res0?.response.count)!)
                } else {
                    return 0
                }
             } else {
                 if self.res1?.response.count != nil {
                    return ((self.res1?.response.count)!)
                 } else {
                return 0
                }
            }
        } else {
            return 0
        }
    }
    
    var urlClass = urls()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gamesCell", for: indexPath) as! gamesCell
        
        if self.gameListState == "currentGames" {
            
            cell.result.text = "\((self.res0?.response[indexPath.row].player1_result)!) _ \((self.res0?.response[indexPath.row].player2_result)!)"
            
            if self.res0?.response[indexPath.row].p_game_start != nil {
            cell.timeLabel.text = (self.res0?.response[indexPath.row].p_game_start)!
            } else {
              cell.timeLabel.text = "چندی قبل"
            }
            
            cell.player1Level.text = (self.res0?.response[indexPath.row].player1_level)!
            cell.player1Cup.text = (self.res0?.response[indexPath.row].player1_cup)!
            cell.player1Name.text = (self.res0?.response[indexPath.row].player1_username)!
            let url = "\(urlClass.avatar)\((self.res0?.response[indexPath.row].player1_avatar)!)"
            let urls = URL(string : url)
            cell.player1Avatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
            
            cell.player2Level.text = (self.res0?.response[indexPath.row].player2_level)!
            cell.player2Cup.text = (self.res0?.response[indexPath.row].player2_cup)!
            cell.player2Name.text = (self.res0?.response[indexPath.row].player2_username)!
            let url2 = "\(urlClass.avatar)\((self.res0?.response[indexPath.row].player2_avatar)!)"
            let urls2 = URL(string : url2)
            cell.player2Avatar.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
            if (self.res0?.response[indexPath.row].status_result)! == "MY_TURN" {
                cell.turnLabel.text = "نوبت شما"
                cell.turnLabel.textColor = UIColor.init(red: 184/255, green: 219/255, blue: 31/255, alpha: 1.0)
            } else if (self.res0?.response[indexPath.row].status_result)! == "OTHER_TURN" {
                cell.turnLabel.text = "نوبت حریف"
                 cell.turnLabel.textColor = UIColor.white
            }
            cell.player1Select.tag = indexPath.row
            cell.player1Select.addTarget(self, action: #selector(player1Select), for: UIControlEvents.touchUpInside)
            cell.player2Select.tag = indexPath.row
            cell.player2Select.addTarget(self, action: #selector(player2Select), for: UIControlEvents.touchUpInside)
            
        } else {
            
            cell.result.text = "\((self.res1?.response[indexPath.row].player1_result)!) _ \((self.res1?.response[indexPath.row].player2_result)!)"
            cell.timeLabel.text = (self.res1?.response[indexPath.row].p_game_start)!
            cell.player1Level.text = (self.res1?.response[indexPath.row].player1_level)!
            cell.player1Cup.text = (self.res1?.response[indexPath.row].player1_cup)!
            cell.player1Name.text = (self.res1?.response[indexPath.row].player1_username)!
            let url = "\(urlClass.avatar)\((self.res1?.response[indexPath.row].player1_avatar)!)"
            let urls = URL(string : url)
            cell.player1Avatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
            
            cell.player2Level.text = (self.res1?.response[indexPath.row].player2_level)!
            cell.player2Cup.text = (self.res1?.response[indexPath.row].player2_cup)!
            cell.player2Name.text = (self.res1?.response[indexPath.row].player2_username)!
            let url2 = "\(urlClass.avatar)\((self.res1?.response[indexPath.row].player2_avatar)!)"
            let urls2 = URL(string : url2)
            cell.player2Avatar.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
            
            if (self.res1?.response[indexPath.row].status_result)! == "DRAW" {
                cell.turnLabel.text = "مساوی"
                cell.turnLabel.textColor = UIColor.init(red: 233/255, green: 241/255, blue: 0/255, alpha: 1.0)
            } else if (self.res1?.response[indexPath.row].status_result)! == "WIN" {
                cell.turnLabel.text = "بردی"
                cell.turnLabel.textColor = UIColor.init(red: 184/255, green: 219/255, blue: 31/255, alpha: 1.0)
            } else if (self.res1?.response[indexPath.row].status_result)! == "LOSE" {
                cell.turnLabel.text = "باختی"
                cell.turnLabel.textColor = UIColor.init(red: 238/255, green: 70/255, blue: 70/255, alpha: 1.0)
            } else if (self.res1?.response[indexPath.row].status_result)! == "DEFER" {
                cell.turnLabel.text = "تسلیم"
                cell.turnLabel.textColor = UIColor.init(red: 255/255, green: 119/255, blue: 29/255, alpha: 1.0)
            } else if (self.res1?.response[indexPath.row].status_result)! == "TIME_OUT" {
                cell.turnLabel.text = "وقت تمام شد"
                cell.turnLabel.textColor = UIColor.init(red: 255/255, green: 119/255, blue: 29/255, alpha: 1.0)
            }
            
            cell.player1Select.tag = indexPath.row
            cell.player1Select.addTarget(self, action: #selector(player1Select), for: UIControlEvents.touchUpInside)
            cell.player2Select.tag = indexPath.row
            cell.player2Select.addTarget(self, action: #selector(player2Select), for: UIControlEvents.touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
            return 160
        } else {
            return  UIScreen.main.bounds.height / 6
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
        self.gameListTV.reloadData()
    }
    
    @IBAction func showEndedGames(_ sender: RoundButton) {
        self.currentGames.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.endedGames.backgroundColor = UIColor.white
        self.gameListState = "endedGames"
        self.gameListTV.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? startMatchViewController {
            if self.gameListState == "currentGames" {
                vc.matchID = (self.res0?.response[self.selectedMatch].id)!
            } else {
                vc.matchID = (self.res1?.response[self.selectedMatch].id)!
            }
        }
        if let vC = segue.destination as? menuViewController {
            vC.menuState = "profile"
        }
    }
    
    @objc func player1Select(_ sender : UIButton!) {
        if self.gameListState == "currentGames" {
            getUserData(id : (self.res0?.response[sender.tag].player1_id)!)
        } else {
            getUserData(id : (self.res1?.response[sender.tag].player1_id)!)
        }
    }
    
    @objc func player2Select(_ sender : UIButton!) {
        
        if self.gameListState == "currentGames" {
            getUserData(id : (self.res0?.response[sender.tag].player2_id)!)
        } else {
            getUserData(id : (self.res1?.response[sender.tag].player2_id)!)
        }
    }
    
    @objc func getUserData(id : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(id)' , 'load_stadium' : 'false'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        self.performSegue(withIdentifier: "showProfile", sender: self)
                        PubProc.wb.hideWaiting()
                    } catch {
                        self.getUserData(id : id)
                        print(error)
                    }
                } else {
                    self.getUserData(id : id)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
}
