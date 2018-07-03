//
//  startMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

class startMatchViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {


    @IBOutlet weak var startMatchTV: UITableView!
    
    @IBOutlet weak var player1Avatar: UIImageView!
    
    @IBOutlet weak var player1Name: UILabel!
    
    @IBOutlet weak var player1Level: UILabel!
    
    @IBOutlet weak var player2Avatar: UIImageView!
    
    @IBOutlet weak var player2Name: UILabel!
    
    @IBOutlet weak var player2Level: UILabel!
    
    @IBOutlet weak var player1Score: UILabel!
    
    @IBOutlet weak var player2Score: UILabel!
    
    var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    
    var res : matchDetails.Response? = nil;
    var redBall = UIImage(named: "ic_red_ball")
    var greenBall = UIImage(named: "ic_green_ball")
    var emptyBall =  UIImage()
    func loadMatchData() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_getMatchData", JSONStr: "{'matchid':'2548'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.res = try JSONDecoder().decode(matchDetails.Response.self , from : data!)
                        
                        DispatchQueue.main.async {
                            let url = "http://volcan.ir/adelica/images/avatars/\((self.res?.response?.matchData?.player1_avatar)!)"
                            let urls = URL(string: url)
                            self.player1Avatar.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
                            
                            let url2 = "http://volcan.ir/adelica/images/avatars/\((self.res?.response?.matchData?.player2_avatar)!)"
                            let urls2 = URL(string: url2)
                            self.player2Avatar.kf.setImage(with: urls2 ,options:[.transition(ImageTransition.fade(0.5))])
                            
                            self.player1Name.text = "\((self.res?.response?.matchData?.player1_username)!)"
                            
                            self.player1Level.text = "\((self.res?.response?.matchData?.player1_level)!)"
                            
                            self.player2Name.text = "\((self.res?.response?.matchData?.player2_username)!)"
                            
                            self.player2Level.text = "\((self.res?.response?.matchData?.player2_level)!)"
                            
                            self.player1Score.text = "\((self.res?.response?.matchData?.player1_result)!)"
                            
                            self.player2Score.text = "\((self.res?.response?.matchData?.player2_result)!)"
                            self.startMatchTV.reloadData()
                        }
                    } catch {
                        self.loadMatchData()
                        print(error)
                    }
                } else {
                    self.loadMatchData()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMatchData()
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.res != nil {
            return (self.res?.response?.detailData?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "startMatchCell", for: indexPath) as! startMatchCell
        if UIDevice().userInterfaceIdiom == .phone {
        cell.matchResult.AttributesOutLine(font: iPhonefonts, title: "\((self.res?.response?.detailData?[indexPath.row].player1_result)!) - \((self.res?.response?.detailData?[indexPath.row].player2_result)!) ", strokeWidth: -3.0)
        cell.matchTitle.AttributesOutLine(font: iPhonefonts, title: "\((self.res?.response?.detailData?[indexPath.row].game_type_name)!)", strokeWidth: -3.0)
        } else {
        cell.matchResult.AttributesOutLine(font: iPadfonts, title: "\((self.res?.response?.detailData?[indexPath.row].player1_result)!) - \((self.res?.response?.detailData?[indexPath.row].player2_result)!) ", strokeWidth: -3.0)
        cell.matchTitle.AttributesOutLine(font: iPadfonts, title: "\((self.res?.response?.detailData?[indexPath.row].game_type_name)!)", strokeWidth: -3.0)
        }
        
        if self.res?.response?.detailData?[indexPath.row].player1_result_sheet != nil {
        if (self.res?.response?.detailData?[indexPath.row].player1_result_sheet?.ans_1)! == 0 {
           cell.bl1.image = redBall
        } else {
            cell.bl1.image = greenBall
        }
        
        if (self.res?.response?.detailData?[indexPath.row].player1_result_sheet?.ans_2)! == 0 {
            cell.bl2.image = redBall
        } else {
            cell.bl2.image = greenBall
        }
        
        if (self.res?.response?.detailData?[indexPath.row].player1_result_sheet?.ans_3)! == 0 {
            cell.bl3.image = redBall
        } else {
            cell.bl3.image = greenBall
        }
        if (self.res?.response?.detailData?[indexPath.row].player1_result_sheet?.ans_4)! == 0 {
            cell.bl4.image = redBall
        } else {
            cell.bl4.image = greenBall
        }
        } else {
            cell.bl1.image = emptyBall
            cell.bl2.image = emptyBall
            cell.bl3.image = emptyBall
            cell.bl4.image = emptyBall
        }

        if self.res?.response?.detailData?[indexPath.row].player2_result_sheet != nil {
        if (self.res?.response?.detailData?[indexPath.row].player2_result_sheet?.ans_1)! == 0 {
            cell.br4.image = redBall
        } else {
            cell.br4.image = greenBall
        }
        
        if (self.res?.response?.detailData?[indexPath.row].player2_result_sheet?.ans_2)! == 0 {
            cell.br3.image = redBall
        } else {
            cell.br3.image = greenBall
        }
        
        if (self.res?.response?.detailData?[indexPath.row].player2_result_sheet?.ans_3)! == 0 {
            cell.br2.image = redBall
        } else {
            cell.br2.image = greenBall
        }
        
        if (self.res?.response?.detailData?[indexPath.row].player2_result_sheet?.ans_4)! == 0 {
            cell.br1.image = redBall
        } else {
            cell.br1.image = greenBall
        }
        } else {
            cell.br1.image = emptyBall
            cell.br2.image = emptyBall
            cell.br3.image = emptyBall
            cell.br4.image = emptyBall
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
            return 90
        } else {
            return 130
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
