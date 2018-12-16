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
    @IBOutlet weak var yourScoreSelect: RoundButton!
    @IBOutlet weak var leaderBoardConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var pageTitleForeGround: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        switch self.state {
        case  "today":
            if self.todayRes != nil {
                print((self.todayRes?.response?.count)!)
                return (self.todayRes?.response?.count)!
            } else {
                return 0
            }
        case "past" :
            if self.pastRes != nil {
                print((self.pastRes?.response?.count)!)
                return (self.pastRes?.response?.count)!
            } else {
                return 0
            }
        case "leaderBoard" :
            if self.predictLeaderBoardRes != nil {
                print((self.predictLeaderBoardRes?.response?.count)!)
                return (self.predictLeaderBoardRes?.response?.count)!
            } else {
                return 0
            }
        default:
            return 0
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
            
        cell.team1Logo.setImageWithKingFisher(url: "\((self.todayRes?.response?[indexPath.row].home_image!)!)")
            
        cell.team2Logo.setImageWithKingFisher(url: "\((self.todayRes?.response?[indexPath.row].away_image!)!)")
            
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
            
            cell.team1Logo.setImageWithKingFisher(url: "\((self.pastRes?.response?[indexPath.row].home_image!)!)")
            
            cell.team2Logo.setImageWithKingFisher(url: "\((self.pastRes?.response?[indexPath.row].away_image!)!)")
            cell.team1Prediction.text = "\((self.pastRes?.response?[indexPath.row].home_prediction!)!)"
            cell.team2Prediction.text = "\((self.pastRes?.response?[indexPath.row].away_prediction!)!)"
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "predictLeaderBoardCell", for: indexPath) as! predictLeaderBoardCell
            
            DispatchQueue.main.async {
//                cell.userAvatar.setImageWithKingFisher(url: "\(urls().avatar)\((self.predictLeaderBoardRes?.response?[indexPath.row].avatar!)!)")

                cell.aVURL = "\(urls().avatar)\((self.predictLeaderBoardRes?.response?[indexPath.row].avatar!)!)"
                cell.updateImage()
                
                if "\((self.predictLeaderBoardRes?.response?[indexPath.row].id!)!)" == loadingViewController.userid {
                    cell.userBackGroud.backgroundColor = publicColors().currentUser
                } else {
                    cell.userBackGroud.backgroundColor = publicColors().otherUsers
                }
            
            cell.userName.text = "\((self.predictLeaderBoardRes?.response?[indexPath.row].username!)!)"
            cell.number.text = "\(indexPath.row + 1)"
            cell.userScore.text = "\((self.predictLeaderBoardRes?.response?[indexPath.row].cups!)!)"
            }
            cell.selectLeaderBoardUser.tag = indexPath.row
            cell.selectLeaderBoardUser.addTarget(self, action: #selector(getUserInfo), for: UIControlEvents.touchUpInside)
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
    
    var urlClass = urls()
    var profileResponse : loginStructure.Response? = nil
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? predictOneMatchViewController {
        vc.homeImg = "\((self.todayRes?.response?[selectedPredict].home_image!)!)"
        vc.awayImg = "\((self.todayRes?.response?[selectedPredict].away_image!)!)"
        vc.predictionId = Int((self.todayRes?.response?[selectedPredict].id!)!)!
        }
        
        if let vc = segue.destination as? menuViewController {
            vc.menuState = "profile"
            vc.profileResponse = self.profileResponse
        }
        
        if let vc = segue.destination as? helpViewController {
            vc.desc = self.helpDescTitle
            vc.acceptTitle = self.helpAcceptTitle
            vc.state = "PREDICTION_HELP"
        }
    }

    @IBOutlet weak var predictMatchTV: UITableView!
    
    @IBOutlet weak var todayOutlet: RoundButton!
    
    @IBOutlet weak var predictLeaderBoardOutlet: RoundButton!
    
    @IBOutlet weak var pastOutlet: RoundButton!
    
    var state = "today"
    
    @objc func getUserInfo(_ sender : UIButton!) {
        print((self.predictLeaderBoardRes?.response?[sender.tag].id!)!)
        getProfile(userid : (self.predictLeaderBoardRes?.response?[sender.tag].id!)!)
    }
    
    @objc func getProfile(userid : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(userid)' , 'load_stadium' : 'false' , 'my_userid' : '\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    PubProc.cV.hideWarning()
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.profileResponse = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        
                        self.performSegue(withIdentifier: "showProfile", sender: self)
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                        }
                    } catch {
                        self.getProfile(userid: userid)
                        print(error)
                    }
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.getProfile(userid: userid)
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
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
        
            if UIDevice().userInterfaceIdiom == .pad
                && UIScreen.main.nativeBounds.size.height >= 2224 {
                
                
            }
        
        todayJson()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAfterPredict(notification:)), name: Notification.Name("refreshPrediction"), object: nil)
        
        topLabelFunction(text: "امتیاز شما")
        scoreAnimation()
        self.leaderBoardConstraint.constant = 0
        pageTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "پیش بینی", strokeWidth: 8.0)
        pageTitleForeGround.font = fonts().iPadfonts25
        pageTitleForeGround.text = "پیش بینی"
        self.todayOutlet.backgroundColor = UIColor.white

    }
    
    
    @objc func topLabelFunction(text : String) {
        yourScoreTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "\(text)", strokeWidth: 8.0)
        yourScoreTitleForeGround.font = fonts().iPadfonts25
        yourScoreTitleForeGround.text = "\(text)"
        self.yourScoreSelect.addTarget( self, action: #selector(scrollToMyRow), for: UIControlEvents.touchUpInside)
    }
    
    @objc func scrollToMyRow() {
        if self.state == "leaderBoard" {
        let index = self.predictLeaderBoardRes?.response?.index(where : {$0.id == loadingViewController.userid})
            if index != nil {
        self.predictMatchTV.scrollToRow(at: IndexPath(row: index!, section: 0), at: .top, animated: true)
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func todayAction(_ sender: RoundButton) {
        if  self.state != "today" {
        self.predictLeaderBoardOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.pastOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.todayOutlet.backgroundColor = UIColor.white
        todayJson()
        }
    }
    
    @IBAction func predictLeaderBoardAction(_ sender: RoundButton) {
        if self.state != "leaderBoard" {
        self.todayOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.pastOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.predictLeaderBoardOutlet.backgroundColor = UIColor.white
        leaderBoardJson()
        }
    }
    
    @IBAction func pastAction(_ sender: RoundButton) {
        if  self.state != "past" {
        self.todayOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.predictLeaderBoardOutlet.backgroundColor = colors().lightBrownBackGroundColor
        self.pastOutlet.backgroundColor = UIColor.white
        pastJson()
        }
    }
    
    @objc func pastJson() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handlePredictions", JSONStr: "{'mode':'GET_PREV_GAMES' , 'userid' : '\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.pastRes = try JSONDecoder().decode(prediction.Response.self , from : data!)
                        DispatchQueue.main.async {
                            UIView.performWithoutAnimation {
                                self.state = "past"
                                self.predictMatchTV.reloadData()
                                if self.pastRes?.response?.count != 0 {
                                    self.predictMatchTV.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                                }
                            }
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
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.pastJson()
                        })
                    }
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
                            UIView.performWithoutAnimation {
                                self.state = "today"
                                self.predictMatchTV.reloadData()
                                if self.todayRes?.response?.count != 0 {
                                    self.predictMatchTV.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                                }
                            }
                        }
                        PubProc.wb.hideWaiting()
                    } catch {
                        self.pastJson()
                        print(error)
                    }
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.pastJson()
                        })
                    }
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
                            UIView.performWithoutAnimation {
                                self.state = "leaderBoard"
                                self.predictMatchTV.reloadData()
                                if self.predictLeaderBoardRes?.response?.count != 0 {
                                    self.predictMatchTV.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                                }
                            }
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
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.pastJson()
                        })
                    }
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

    var helpDescTitle = [String]()
    var helpAcceptTitle = [String]()
    
    @objc func predictionHelping() {
        getHelp().gettingHelp(mode: "PREDICTION_HELP", completionHandler: {
            for i in 0...(helpViewController.helpRes?.response?.count)! - 1 {
                if helpViewController.helpRes?.response?[i].desc_text != nil {
                    self.helpDescTitle.append((helpViewController.helpRes?.response?[i].desc_text!)!)
                } else {
                    self.helpDescTitle.append("")
                }
                if helpViewController.helpRes?.response?[i].key_title != nil {
                    self.helpAcceptTitle.append((helpViewController.helpRes?.response?[i].key_title!)!)
                } else {
                    self.helpAcceptTitle.append("")
                }
            }
            self.performSegue(withIdentifier: "predictionHelp", sender: self)
        })
    }
    
    @IBAction func predictionHelp(_ sender: RoundButton) {
        predictionHelping()
    }
    
    
}
