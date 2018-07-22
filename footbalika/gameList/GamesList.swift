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
    
    func gameLists() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_getMatchList", JSONStr: "{'mode': 'USERMATCH','userid':'1'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.res = try JSONDecoder().decode(gamesList.Response.self , from : data!)
                        
                        print((self.res?.response[0].status!)!)
                        
                        guard let res = self.res else {
                            print("res not found")
                            return
                        }
                        
                       
                        
                        let playerStatuses = res.response.filter { $0.status != nil }
//                        let number = self.res?.response.filter { $0.status == "1"}
//
                        let playersWithStatus1 = playerStatuses.filter({ $0.status == "1" })
                        let playersWithStatus0 = playerStatuses.filter({ $0.status != "1" })
                        
                        print("Players = ",playerStatuses)
                        print("Player with status 1  =",playersWithStatus1)
                        print("players with status 0 = ",playersWithStatus0)
                        
                        //12
                        //                        print(number)
                        //continue
                        // self.res0 nile bade .response meghadr dehi nemishe khob.!!!khob man  mikham bedoonam chetor mitoonam into meghdar bedam?
                        self.res0?.response = (self.res?.response.filter { $0.status == "1"})!
                        self.res1?.response = (self.res?.response.filter { $0.status != "1"})!
                        let m = (self.res?.response.filter {$0.status == "1"})!
                        print(type(of : m))
                        print(type(of: self.res0?.response))
                        self.res0?.response = m
                        print(self.res0?.response[0].next_play_time)
                        
//                        for i in 0...(self.res0?.responseself.res?.response.count)! - 1 {
//                        if Int((self.res?.response[i].status!)!)! < 2 {
//
//                            self.res0?.response.append((self.res?.response[i])!)
//                        }
//                        }
                        
                        DispatchQueue.main.async {
                            self.gameListTV.reloadData()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.refreshControl.endRefreshing()
                        })
                        
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
                print(((self.res0?.response.count)))
                return ((self.res0?.response.count)!)
             } else {
//                return ((self.res1?.response.count)!)
                return 0
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
            cell.timeLabel.text = (self.res0?.response[indexPath.row].next_play_time)!
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
            
            
        } else {
            
            
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
        return 180
        } else {
        return 250
        }
    }
    
    @IBAction func showCurrentGames(_ sender: RoundButton) {
        self.endedGames.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.currentGames.backgroundColor = UIColor.white
        self.gameListState = "currentGames"
        self.gameListTV.reloadData()
    }
    
    @IBAction func showEndedGames(_ sender: RoundButton) {
        self.currentGames.backgroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
        self.endedGames.backgroundColor = UIColor.white
        self.gameListState = "endedGames"
        self.gameListTV.reloadData()
    }
    
    
}
