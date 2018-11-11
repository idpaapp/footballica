//
//  startMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import RealmSwift

protocol DismissDelegate{
    func dismissAndSurrender(id : String)
}

class startMatchViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , DismissDelegate {

    func dismissAndSurrender(id : String){
        surrenderring(match_id : id)
    }
    
    @IBOutlet weak var surrenderOutlet: RoundButton!
    
    var isHome = Bool()
    @IBAction func selectPlayer1(_ sender: RoundButton) {
        getUserData(id : (self.res?.response?.matchData?.player1_id)!)
    }
    
    @IBAction func selectPlayer2(_ sender: RoundButton) {
        getUserData(id : (self.res?.response?.matchData?.player2_id)!)
    }
    
    @objc func getUserData(id : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(id)' , 'load_stadium' : 'false'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                        }
                        self.performSegue(withIdentifier: "showPF", sender: self)                        
                    } catch {
                        self.getUserData(id : id)
                        print(error)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.getUserData(id : id)
                    })
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
    @IBOutlet weak var playGameOutlet: RoundButton!
    
    @IBOutlet weak var startMatchTV: UITableView!
    
    @IBOutlet weak var player1Avatar: UIImageView!
    
    @IBOutlet weak var player1Name: UILabel!
    
    @IBOutlet weak var player1Level: UILabel!
    
    @IBOutlet weak var player2Avatar: UIImageView!
    
    @IBOutlet weak var player2Name: UILabel!
    
    @IBOutlet weak var player2Level: UILabel!
    
    @IBOutlet weak var player1Score: UILabel!
    
    @IBOutlet weak var player2Score: UILabel!
    
//    var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
//    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    
    var urlClass = urls()
    var res : matchDetails.Response? = nil;
    var matchID = String()

    func loadMatchData(id : String) {
        self.playGameOutlet.isUserInteractionEnabled = false
        
        PubProc.HandleDataBase.readJson(wsName: "ws_getMatchData", JSONStr: "{'matchid': \(id) , 'userid' : \(loadingViewController.userid)}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.res = try JSONDecoder().decode(matchDetails.Response.self , from : data!)
                        
                        print("player1ID\((self.res?.response?.matchData?.player1_id!)!)")
                        print("player2ID\((self.res?.response?.matchData?.player2_id!)!)")
                        
                        if (self.res?.response?.matchData?.player1_id!)! == loadingViewController.userid {
                            self.isHome = true
                        } else {
                            self.isHome = false
                        }
                        
//                        print((self.res?.response?.matchData?.player1_avatar))
                        DispatchQueue.main.async {
                            let url = "\(self.urlClass.avatar)\((self.res?.response?.matchData?.player1_avatar)!)"
                            
                            let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
                            if realmID.count != 0 {
                                let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                                self.player1Avatar.image = UIImage(data: dataDecoded as Data)
                            } else {
                                self.player1Avatar.setImageWithKingFisher(url: url)
                            }
                            
                            let url2 = "\(self.urlClass.avatar)\((self.res?.response?.matchData?.player2_avatar)!)"
                            
                            let realmID2 = self.realm.objects(tblShop.self).filter("image_path == '\(url2)'")
                            if realmID2.count != 0 {
                                let dataDecoded:NSData = NSData(base64Encoded: (realmID2.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                                self.player2Avatar.image = UIImage(data: dataDecoded as Data)
                            } else {
                                self.player2Avatar.setImageWithKingFisher(url: url2)
                            }
                            
                            self.player1Name.text = "\((self.res?.response?.matchData?.player1_username)!)"
                            
                            self.player1Level.text = "\((self.res?.response?.matchData?.player1_level)!)"
                            
                            self.player2Name.text = "\((self.res?.response?.matchData?.player2_username)!)"
                            
                            self.player2Level.text = "\((self.res?.response?.matchData?.player2_level)!)"
                            
                            self.player1Score.text = "\((self.res?.response?.matchData?.player1_result)!)"
                            
                            self.player2Score.text = "\((self.res?.response?.matchData?.player2_result)!)"
                            if (self.res?.response?.isYourTurn)! == true {
                                self.playGameOutlet.setTitle("بازی کن", for: UIControlState.normal)
                                self.playGameOutlet.isUserInteractionEnabled = true
                                self.surrenderOutlet.isHidden = false
                            } else {
                                self.playGameOutlet.setTitle("نوبت بازی حریف", for: UIControlState.normal)
                                self.playGameOutlet.isUserInteractionEnabled = true
                                self.surrenderOutlet.isHidden = false
                            }
                            if (Int((self.res?.response?.matchData?.status)!)!) >= 2 {
                                self.playGameOutlet.setTitle("خروج", for: UIControlState.normal)
                                self.playGameOutlet.isUserInteractionEnabled = true
                                self.surrenderOutlet.isHidden = true
                            }
                            self.startMatchTV.reloadData()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                PubProc.wb.hideWaiting()
                            })
                            
                        }
                    } catch {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            self.loadMatchData(id: id)
                        })
                        print(error)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.loadMatchData(id: id)
                    })
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.isUserInteractionEnabled = true
        self.surrenderOutlet.isHidden = true
        PubProc.wb.showWaiting()
    }
    var lastID = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMatchData(id: self.matchID)
        categoryArraySet()
        lastID = defaults.string(forKey: "lastMatchId") ?? String()
        NotificationCenter.default.addObserver(self, selector: #selector(updateGameReault), name: NSNotification.Name(rawValue: "reloadGameData"), object: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var updateRes : String? = nil;
    
    @objc func updateGameReault() {
        
        let JsonStr = defaults.string(forKey: "gameLeft") ?? String()
        print(JsonStr)
        if JsonStr != "" {
        PubProc.HandleDataBase.readJson(wsName: "ws_UpdateGameResult", JSONStr: "\(JsonStr)") { data, error in
            DispatchQueue.main.async {
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    self.updateRes = String(data: data!, encoding: String.Encoding.utf8) as String?
                    
                    if ((self.updateRes)!).contains("ok") {
                        self.loadMatchData(id: self.matchID)
                        self.defaults.set("", forKey: "gameLeft")
//                        print(self.updateRes!)
                    } else {
                        self.updateGameReault()
                    }
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.updateGameReault()
                    })
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
        }
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
//        print((self.res?.response?.detailData?[indexPath.row].last_questions)!)
        if UIDevice().userInterfaceIdiom == .phone {
        cell.matchResult.AttributesOutLine(font: fonts().iPadfonts25, title: "\((self.res?.response?.detailData?[indexPath.row].player1_result)!) _ \((self.res?.response?.detailData?[indexPath.row].player2_result)!) ", strokeWidth: -3.0)
        cell.matchTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\((self.res?.response?.detailData?[indexPath.row].game_type_name)!)".replacedArabicCharactersToPersian, strokeWidth: -3.0)
        } else {
        cell.matchResult.AttributesOutLine(font: fonts().large35, title: "\((self.res?.response?.detailData?[indexPath.row].player1_result)!) _ \((self.res?.response?.detailData?[indexPath.row].player2_result)!) ", strokeWidth: -3.0)
        cell.matchTitle.AttributesOutLine(font: fonts().large35, title: "\((self.res?.response?.detailData?[indexPath.row].game_type_name)!)".replacedArabicCharactersToPersian, strokeWidth: -3.0)
        }
        
        if self.res?.response?.detailData?[indexPath.row].player1_result_sheet != nil {
        if (self.res?.response?.detailData?[indexPath.row].player1_result_sheet?.ans_1)! == "0" {
           cell.bl1.image = publicImages().redBall
        } else {
            cell.bl1.image = publicImages().greenBall
        }
        
        if (self.res?.response?.detailData?[indexPath.row].player1_result_sheet?.ans_2)! == "0" {
            cell.bl2.image = publicImages().redBall
        } else {
            cell.bl2.image = publicImages().greenBall
        }
        
        if (self.res?.response?.detailData?[indexPath.row].player1_result_sheet?.ans_3)! == "0" {
            cell.bl3.image = publicImages().redBall
        } else {
            cell.bl3.image = publicImages().greenBall
        }
        if (self.res?.response?.detailData?[indexPath.row].player1_result_sheet?.ans_4)! == "0" {
            cell.bl4.image = publicImages().redBall
        } else {
            cell.bl4.image = publicImages().greenBall
        }
        } else {
            cell.bl1.image = publicImages().emptyImage
            cell.bl2.image = publicImages().emptyImage
            cell.bl3.image = publicImages().emptyImage
            cell.bl4.image = publicImages().emptyImage
        }

        if self.res?.response?.detailData?[indexPath.row].player2_result_sheet != nil {
        if (self.res?.response?.detailData?[indexPath.row].player2_result_sheet?.ans_1)! == "0" {
            cell.br4.image = publicImages().redBall
        } else {
            cell.br4.image = publicImages().greenBall
        }
        
        if (self.res?.response?.detailData?[indexPath.row].player2_result_sheet?.ans_2)! == "0" {
            cell.br3.image = publicImages().redBall
        } else {
            cell.br3.image = publicImages().greenBall
        }
        
        if (self.res?.response?.detailData?[indexPath.row].player2_result_sheet?.ans_3)! == "0" {
            cell.br2.image = publicImages().redBall
        } else {
            cell.br2.image = publicImages().greenBall
        }
        
        if (self.res?.response?.detailData?[indexPath.row].player2_result_sheet?.ans_4)! == "0" {
            cell.br1.image = publicImages().redBall
        } else {
            cell.br1.image = publicImages().greenBall
        }
        } else {
            cell.br1.image = publicImages().emptyImage
            cell.br2.image = publicImages().emptyImage
            cell.br3.image = publicImages().emptyImage
            cell.br4.image = publicImages().emptyImage
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
    
    func closePage() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        closePage()
    }
    
    var catState = String()
    
    @IBAction func playGameAction(_ sender: RoundButton) {
        self.playGameOutlet.isUserInteractionEnabled = false
        let isFinished = (Int((self.res?.response?.matchData?.status)!)!)
//        print(isFinished)
        if isFinished < 2 {
            if self.res?.response?.isYourTurn == true {
                if (self.res?.response?.detailData?.count)! == 0 {
                    self.catState = "cat"
                    questionIds()
                } else if self.res?.response?.detailData?[(self.res?.response?.detailData?.count)! - 1].player1_result_sheet != nil &&  self.res?.response?.detailData?[(self.res?.response?.detailData?.count)! - 1].player2_result_sheet != nil {
                    self.catState = "cat"
                    questionIds()
                } else {
                    self.catState = "NoCat"
//                    print("it's not time for selecting category")
                    self.performSegue(withIdentifier: "selectCat", sender: self)
                }
            } else {
//                print("it's not your Turn")
                turnAlert()
            }
        } else {
            closePage()
//            print("the match was finished")
        }
    }
    
    @objc func turnAlert() {
        self.alertTitle = "اخطار"
        self.alertBody = "باید صبر کنی تا حریف بازیشو انجام بده"
        self.performSegue(withIdentifier: "matchFieldAlert", sender: self)
    }
    
    let defaults = UserDefaults.standard
    var realm : Realm!
    var tblMatchTypesArray : Results<tblMatchTypes> {
        get {
            realm = try! Realm()
            return realm.objects(tblMatchTypes.self)
        }
    }
    
    var lastPlayedId = ""

    @objc func questionIds() {

//        defaults.set("", forKey: "lastMatchId")
        
        if (self.res?.response?.detailData?.count)! == 0 {
//            print(lastID)
        } else {
            for i in 0...(self.res?.response?.detailData?.count)! - 1 {
//            print((self.res?.response?.detailData?[i].game_type!)!)
                lastPlayedId.append(",\((self.res?.response?.detailData?[i].game_type!)!)")
//                print("lastPlayedId\((self.res?.response?.detailData?[i].game_type!)!)")
            }
            
        }
        
        if lastID == "" && lastPlayedId == "" {
            
            categoryState = 1


        } else if lastID != "" {
            
            categoryState = 2
            
        } else if lastID == "" && lastPlayedId != "" {
            categoryState = 3

        }
        
        self.performSegue(withIdentifier: "selectCat", sender: self)
        
    }
    
    var categoryTitleArray = [String]()
    var categoryIDArray = [Int]()
    var categoryBase64ImageArray = [String]()
    var categoryState = Int()
    func categoryArraySet() {
        
        let counts = self.tblMatchTypesArray.count
            for i in 0...counts - 1 {
            categoryTitleArray.append(tblMatchTypesArray[i].title)
            categoryIDArray.append(tblMatchTypesArray[i].id)
            categoryBase64ImageArray.append(tblMatchTypesArray[i].img_base64)
            
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let vc = segue.destination as? selectCategoryViewController {
        var titles = [String]()
        var images = [String]()
        var ids = [Int]()
        
        if self.catState != "NoCat" {
        if categoryState == 1 {
            
            for _ in 0..<categoryTitleArray.count
            {
                let rand = Int(arc4random_uniform(UInt32(categoryTitleArray.count)))
                
                titles.append(categoryTitleArray[rand])
                images.append(categoryBase64ImageArray[rand])
                ids.append(categoryIDArray[rand])
                categoryTitleArray.remove(at: rand)
                categoryBase64ImageArray.remove(at: rand)
                categoryIDArray.remove(at: rand)
            }
            
            categoryTitleArray = titles
            categoryBase64ImageArray = images
            categoryIDArray = ids

        } else if categoryState == 2 {
            
            let lastIDArray = lastID.split{$0 == ","}.map(String.init)

            for i in 0...lastIDArray.count - 1  {
                let index = categoryIDArray.index(where: {$0 == Int(lastIDArray[i])})

                categoryTitleArray.remove(at: index!)
                categoryBase64ImageArray.remove(at: index!)
                categoryIDArray.remove(at: index!)
                
                }
                titles = categoryTitleArray
                images = categoryBase64ImageArray
                ids = categoryIDArray
        } else {
            
            let lastPlayedIdArray = lastPlayedId.split{$0 == ","}.map(String.init)
            for i in 0...lastPlayedIdArray.count - 1  {
                let index = categoryIDArray.index(where: {$0 == Int(lastPlayedIdArray[i])})
                let tempcategoryTitleArray = categoryTitleArray
                let tempcategoryBase64ImageArray = categoryBase64ImageArray
                let tempcategoryIDArray = categoryIDArray
                categoryTitleArray.remove(at: index!)
                categoryBase64ImageArray.remove(at: index!)
                categoryIDArray.remove(at: index!)
                images = categoryBase64ImageArray
                ids = categoryIDArray
                titles = categoryTitleArray
                categoryTitleArray = tempcategoryTitleArray
                categoryBase64ImageArray = tempcategoryBase64ImageArray
                categoryIDArray = tempcategoryIDArray
            }
        }
        
        vc.images = images
        vc.titles = titles
        vc.ids = ids
        vc.matchData = self.res
        vc.catState = self.catState
            
        } else {
            
            vc.selectedcategoryId = Int((self.res?.response?.detailData?[(self.res?.response?.detailData?.count)! - 1].game_type)!)!
            vc.matchData = self.res
            vc.catState = self.catState
        }
            vc.isHome = self.isHome
            vc.stadium = (self.res?.response?.matchData?.stadium!)!
    }
        
        if let vc = segue.destination as? menuAlertViewController {
            vc.alertTitle = self.alertTitle
            vc.alertBody = self.alertBody
            vc.alertAcceptLabel = "تأیید"
        }
        
        if let vC = segue.destination as? menuViewController {
            vC.menuState = "profile"
        }
        
        
        if let vc = segue.destination as? menuAlert2ButtonsViewController {
            vc.alertTitle = "فوتبالیکا"
            vc.alertBody = "در صورت تسلیم شدن شما بازنده ی بازی خواهید شد.آیا اطمینان دارید؟"
            vc.state = "surrender"
            vc.matchId = self.matchID
            vc.delegate = self
        }
        
        if let vc = segue.destination as? helpViewController {
            vc.desc = self.helpDescTitle
            vc.acceptTitle = self.helpAcceptTitle
            vc.state = "MATCH_HELP"
        }
        
        
    }
    
    var alertTitle = String()
    var alertBody  = String()
    
    public func surrenderring(match_id : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_UpdateGameResult", JSONStr: "{'mode':'UPDT_GAME_DEFER' , 'match_id' : '\(match_id)' , 'player_id' : '\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                if data != nil {
                    PubProc.cV.hideWarning()
                    PubProc.wb.hideWaiting()
                    NotificationCenter.default.post(name: Notification.Name("reloadGameData"), object: nil)
                        self.dismiss(animated: true, completion: nil)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.surrenderring(match_id: match_id)
                    })
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    @IBAction func matchHelping(_ sender: RoundButton) {
        matchHelp()
    }
    
    
    var helpDescTitle = [String]()
    var helpAcceptTitle = [String]()
    
    @objc func matchHelp() {
        
        getHelp().gettingHelp(mode: "MATCH_HELP", completionHandler: {
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
            self.performSegue(withIdentifier: "matchHelping", sender: self)
        })
    }
    
    @IBAction func surrenderAction(_ sender: RoundButton) {
        self.performSegue(withIdentifier: "surrender", sender: self)
    }
    
}
