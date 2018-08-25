//
//  predictMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/21/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

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
        if self.state == "today"  {
            if self.todayRes != nil {
                print((self.todayRes?.response?.count)!)
            return (self.todayRes?.response?.count)!
            } else {
                return 0 
            }
            
            } else if self.state == "past" {
            if self.pastRes != nil {
                print((self.pastRes?.response?.count)!)
                return (self.pastRes?.response?.count)!
            } else {
                return 0
            }
            
        } else {
            if self.predictLeaderBoardRes != nil {
                print((self.predictLeaderBoardRes?.response?.count)!)
                return (self.predictLeaderBoardRes?.response?.count)!
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.state == "today" || self.state == "past" {
        return 150
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.state == "today" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! todayCell
        
        cell.mainTitle.text = "\((self.todayRes?.response?[indexPath.row].p_game_time!)!)"
        cell.team1Title.text = "\((self.todayRes?.response?[indexPath.row].home_name!)!)"
        cell.team2Title.text = "\((self.todayRes?.response?[indexPath.row].away_name!)!)"
        cell.team1Resault.text = "\((self.todayRes?.response?[indexPath.row].home_result!)!)"
        cell.team2Resault.text = "\((self.todayRes?.response?[indexPath.row].home_result!)!)"
        let team1LogoUrl = "\((self.todayRes?.response?[indexPath.row].home_image!)!)"
        let team1ImgUrl = URL(string: team1LogoUrl)
        cell.team1Logo.kf.setImage(with: team1ImgUrl ,options:[.transition(ImageTransition.fade(0.5))])
        let team2LogoUrl = "\((self.todayRes?.response?[indexPath.row].away_image!)!)"
        let team2ImgUrl = URL(string: team2LogoUrl)
        cell.team2Logo.kf.setImage(with: team2ImgUrl ,options:[.transition(ImageTransition.fade(0.5))])
        cell.submitPrediction.tag = indexPath.row
            cell.submitPrediction.addTarget(self, action: #selector(submitting), for: UIControlEvents.touchUpInside)
        if ((self.todayRes?.response?[indexPath.row].status)!) != "0" {
        cell.team1Prediction.text = "\((self.todayRes?.response?[indexPath.row].home_prediction!)!)"
        cell.team2Prediction.text = "\((self.todayRes?.response?[indexPath.row].away_prediction!)!)"
        cell.submitPrediction.isHidden = true
        cell.submitTitleForeGround.isHidden = true
        cell.submitTitle.isHidden = true
            cell.team1Prediction.isHidden = false
            cell.team2Prediction.isHidden = false

            } else {
            
            cell.submitTitleForeGround.isHidden = false
            cell.submitTitle.isHidden = false
            cell.submitPrediction.isHidden = false
            cell.team1Prediction.text = ""
            cell.team2Prediction.text = ""
            cell.team1Prediction.isHidden = true
            cell.team2Prediction.isHidden = true
            }
            
        return cell
          
        } else if self.state == "past" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! todayCell
            
            cell.submitTitleForeGround.isHidden = true
            cell.submitTitle.isHidden = true
            cell.submitPrediction.isHidden = true
            cell.team1Prediction.isHidden = false
            cell.team2Prediction.isHidden = false
            cell.mainTitle.text = "\((self.pastRes?.response?[indexPath.row].p_game_time!)!)"
            cell.team1Title.text = "\((self.pastRes?.response?[indexPath.row].home_name!)!)"
            cell.team2Title.text = "\((self.pastRes?.response?[indexPath.row].away_name!)!)"
            cell.team1Resault.text = "\((self.pastRes?.response?[indexPath.row].home_result!)!)"
            cell.team2Resault.text = "\((self.pastRes?.response?[indexPath.row].home_result!)!)"
            let team1LogoUrl = "\((self.pastRes?.response?[indexPath.row].home_image!)!)"
            let team1ImgUrl = URL(string: team1LogoUrl)
            cell.team1Logo.kf.setImage(with: team1ImgUrl ,options:[.transition(ImageTransition.fade(0.5))])
            let team2LogoUrl = "\((self.pastRes?.response?[indexPath.row].away_image!)!)"
            let team2ImgUrl = URL(string: team2LogoUrl)
            cell.team2Logo.kf.setImage(with: team2ImgUrl ,options:[.transition(ImageTransition.fade(0.5))])
            cell.team1Prediction.text = "\((self.pastRes?.response?[indexPath.row].home_prediction!)!)"
            cell.team2Prediction.text = "\((self.pastRes?.response?[indexPath.row].away_prediction!)!)"
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "predictLeaderBoardCell", for: indexPath) as! predictLeaderBoardCell
            
            let leaderAvatarUrl = "\(urls().avatar)\((self.predictLeaderBoardRes?.response?[indexPath.row].avatar!)!)"
            let leaderA = URL(string: leaderAvatarUrl)
            cell.userAvatar.kf.setImage(with: leaderA ,options:[.transition(ImageTransition.fade(0.5))])
            cell.userName.text = "\((self.predictLeaderBoardRes?.response?[indexPath.row].username!)!)"
            cell.number.text = "\(indexPath.row + 1)"
            cell.userScore.text = "\((self.predictLeaderBoardRes?.response?[indexPath.row].cups!)!)"
            return cell
        }
    }
    
    
    var selectedPredict = Int()
    
    @objc func submitting(_ sender : RoundButton!) {
        if self.state == "today" {
        selectedPredict = sender.tag
        self.performSegue(withIdentifier: "predictOne", sender: self)
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.state == "today" {
//            selectedPredict = indexPath.row
//            self.performSegue(withIdentifier: "predictOne", sender: self)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! predictOneMatchViewController
        vc.homeImg = "\((self.todayRes?.response?[selectedPredict].home_image!)!)"
        vc.awayImg = "\((self.todayRes?.response?[selectedPredict].away_image!)!)"
        vc.predictionId = Int((self.todayRes?.response?[selectedPredict].id!)!)!
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
    
    var todayRes : prediction.Response? = nil
    var predictLeaderBoardRes : predictionLeaderBoard.Response? = nil
    var pastRes : prediction.Response? = nil

    
    @objc func refreshAfterPredict(notification: Notification){
        todayJson()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todayJson()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAfterPredict(notification:)), name: Notification.Name("refreshPrediction"), object: nil)

        
        topLabelFunction(text: "امتیاز شما")
        scoreAnimation()
        self.leaderBoardConstraint.constant = 0
        pageTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "پیش بینی", strokeWidth: -6.0)
        pageTitleForeGround.font = fonts().iPadfonts25
        pageTitleForeGround.text = "پیش بینی"
        self.todayOutlet.backgroundColor = UIColor.white

    }
    
    
    @objc func topLabelFunction(text : String) {
        yourScoreTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "\(text)", strokeWidth: -6.0)
        yourScoreTitleForeGround.font = fonts().iPadfonts25
        yourScoreTitleForeGround.text = "\(text)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func todayAction(_ sender: RoundButton) {
        self.predictLeaderBoardOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.pastOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.todayOutlet.backgroundColor = UIColor.white
        self.state = "today"
        todayJson()
    }
    
    @IBAction func predictLeaderBoardAction(_ sender: RoundButton) {
        self.todayOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.pastOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.predictLeaderBoardOutlet.backgroundColor = UIColor.white
        self.state = "leaderBoard"
        leaderBoardJson()

    }
    
    @IBAction func pastAction(_ sender: RoundButton) {
        self.todayOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.predictLeaderBoardOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.pastOutlet.backgroundColor = UIColor.white
        self.state = "past"
        pastJson()
    }
    
    
    @objc func pastJson() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handlePredictions", JSONStr: "{'mode':'GET_PREV_GAMES' , 'userid' : '\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.pastRes = try JSONDecoder().decode(prediction.Response.self , from : data!)
                        DispatchQueue.main.async {
                            self.predictMatchTV.reloadData()
                                PubProc.cV.hideWarning()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            UIView.animate(withDuration: 0.5) {
                                self.leaderBoardConstraint.constant = 0
                                self.view.layoutIfNeeded()
                            }
                        })
                        PubProc.wb.hideWaiting()
                    } catch {
                        self.pastJson()
                        print(error)
                    }
                } else {
                    self.pastJson()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    @objc func todayJson() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handlePredictions", JSONStr: "{'mode':'GET_TODAY_GAMES' , 'userid' : '\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.todayRes = try JSONDecoder().decode(prediction.Response.self , from : data!)
                        DispatchQueue.main.async {
                                PubProc.cV.hideWarning()
                            if self.todayRes?.response?.count == 0 {
                                self.topLabelFunction(text: "در حال حاضر بازی ای وجود ندارد")
                                UIView.animate(withDuration: 0.5) {
                                    self.leaderBoardConstraint.constant = 40
                                    self.view.layoutIfNeeded()
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                    UIView.animate(withDuration: 0.5) {
                                        self.leaderBoardConstraint.constant = 0
                                        self.view.layoutIfNeeded()
                                    }
                                })
                            }
                            self.predictMatchTV.reloadData()
                        }
                        

                        PubProc.wb.hideWaiting()
                    } catch {
                        self.pastJson()
                        print(error)
                    }
                } else {
                    self.pastJson()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    @objc func leaderBoardJson() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handlePredictions", JSONStr: "{'mode':'LEADERBOARD' , 'userid' : '\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.predictLeaderBoardRes = try JSONDecoder().decode(predictionLeaderBoard.Response.self , from : data!)
                        
                        self.topLabelFunction(text: "امتیاز شما : \((self.predictLeaderBoardRes?.user_pts)!)")
                        DispatchQueue.main.async {
                            self.predictMatchTV.reloadData()
                            PubProc.cV.hideWarning()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            UIView.animate(withDuration: 0.5) {
                                self.leaderBoardConstraint.constant = 40
                                self.view.layoutIfNeeded()
                            }
                        })

                        PubProc.wb.hideWaiting()
                    } catch {
                        self.pastJson()
                        print(error)
                    }
                } else {
                    self.pastJson()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
    @IBAction func dismissing(_ sender: RoundButton) {
        self.dismiss(animated : true , completion: nil)
    }
    
    
    
}
