//
//  loadingViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import RealmSwift

class loadingViewController: UIViewController {
    
    @IBOutlet weak var loadingProgress: UIProgressView!
    @IBOutlet weak var loadingProgressLabel: UILabel!
    @IBOutlet weak var ProgressBackGroundView: UIView!
    @IBOutlet weak var mainProgressBackGround: UIView!
    @IBOutlet weak var ballProgress: UIImageView!
    
    var timer : Timer!
    var ballTimer : Timer!
    var currentProgress = Float()
    var AppVersion = String()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var ballState = 0
    @objc func ballProgressing() {
        if ballState == 0 {
            UIView.animate(withDuration: 0.7, animations: {
                self.ballProgress.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            })
            self.ballState = 1
        } else {
            UIView.animate(withDuration: 0.7, animations: {
                self.ballProgress.transform = CGAffineTransform.identity
            })
            self.ballState = 0
        }
    }
    
    var fonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadFonts = UIFont(name: "DPA_Game", size: 35)!
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    let playMenuMusic = UserDefaults.standard.bool(forKey: "menuMusic")
    let playgameSounds = UserDefaults.standard.bool(forKey: "gameSounds")
    let alerts = UserDefaults.standard.bool(forKey: "alerts")
    
    func versionCheck() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("version : \(version)")
            AppVersion = version
        }
    }
    
    
    var loadGameData : gameDataModel.Response? = nil;
    
    var gameTypesID = [Int]()
    var gameTypesTitle = [String]()
    var gameTypesImg_logo = [String]()
    var existingIDs = [Int]()
    var existingTitles = [String]()
    var writetblMatchTypes = readAndWritetblMatchTypes()
    @objc func gameData() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_loadGameData", JSONStr: "{'matchID':'0'}") { data, error in
            
            if data != nil {
                
                print(data ?? "")
                
                do {
                    self.loadGameData = try JSONDecoder().decode(gameDataModel.Response.self , from : data!)
                    print((self.loadGameData?.response?.userXps[0].level!)!)
                    print((self.loadGameData?.status!)!)
                    print((self.loadGameData?.response?.gameTypes[0].id!)!)
                    print((self.loadGameData?.response?.giftRewards?.change_name!)!)
                    DispatchQueue.main.async {
                    for i in 0...(self.loadGameData?.response?.gameTypes.count)! - 1 {
                        let gametID = Int((self.loadGameData?.response?.gameTypes[i].id!)!)
                        self.gameTypesID.append(gametID!)
                        self.gameTypesTitle.append((self.loadGameData?.response?.gameTypes[i].title!)!)
                    self.gameTypesImg_logo.append((self.loadGameData?.response?.gameTypes[i].img_logo!)!)
                        self.writetblMatchTypes.writeToDBtblMatchTypes(gameTypesID: self.gameTypesID[i], gameTypesTitle: self.gameTypesTitle[i], gameTypesImg_logo: self.gameTypesImg_logo[i])

                    }
                        
//                    self.writeToDBtblMatchTypes()
                    }
                } catch {
                    print(error)
                }
            } else {
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            
            }.resume()
    }
    
    func writeToDBtblMatchTypes() {
        DispatchQueue.main.async {
            if self.tblMatchTypesArray.count != 0 {
                print(self.tblMatchTypesArray.count)
                    for i in 0...self.tblMatchTypesArray.count - 1 {
                        let item = self.tblMatchTypesArray[i]
                        self.existingIDs.append(item.id)
                        self.existingTitles.append(item.title)
                        print(item.img_logo)
                    }
//                    print(self.existingIDs)
//                    print(self.existingTitles)
//                    print(self.gameTypesID)

                let a = self.existingIDs
                let b = self.gameTypesID
                let result = zip(a, b).enumerated().filter() {
                    $1.0 == $1.1
                    }.map{$0.0}
                print(result)
            
            } else {
                do {
                    for i in 0...self.gameTypesID.count - 1 {
                    let realms = try! Realm()
                    try realms.write({
                            let TblMatchTypes = tblMatchTypes()
                            TblMatchTypes.id = self.gameTypesID[i]
                            print(TblMatchTypes.id)
                            print(self.gameTypesID[i])
                            TblMatchTypes.title = self.gameTypesTitle[i]
                            TblMatchTypes.img_logo = self.gameTypesImg_logo[i]
                        realms.add(TblMatchTypes, update: false)
                        print(" variable stored.")
                        print(self.tblMatchTypesArray.count)
                    })
                    }
                }catch let error {
                    print(error)
                }
        }
        }
    }
    
    var realm : Realm!
    var tblMatchTypesArray : Results<tblMatchTypes> {
        get {
            return realm.objects(tblMatchTypes.self)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try! Realm()
        gameData()
        versionCheck()
        
        if self.launchedBefore  {

        } else {

            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(true, forKey: "menuMusic")
            UserDefaults.standard.set(true, forKey: "gameSounds")
            
            
        }
        
        ballTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(ballProgressing), userInfo: nil, repeats: true)
        
        self.mainProgressBackGround.layer.cornerRadius = 5
        self.ProgressBackGroundView.layer.cornerRadius = 3
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(progressing), userInfo: nil, repeats: true)
        self.loadingProgress.progress = 0
        self.loadingProgressLabel.text = "۰٪"
        if launchedBefore  {
//            print("Not first launch.")
            
        } else {
            
//            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(true, forKey: "menuMusic")
            UserDefaults.standard.set(true, forKey: "gameSounds")
        }
    }
  
    @objc func progressing() {
        if currentProgress > 1.0 {
            timer.invalidate()
            ballTimer.invalidate()
//            self.performSegue(withIdentifier: "showMainMenu", sender: self)
        } else {
            currentProgress = currentProgress + 0.01
            self.loadingProgress.progress = currentProgress
            if UIDevice().userInterfaceIdiom == .phone {
                self.loadingProgressLabel.AttributesOutLine(font: fonts , title: "\(Int(currentProgress * 100))%", strokeWidth: -6.0)
            } else {
                self.loadingProgressLabel.AttributesOutLine(font: iPadFonts , title: "\(Int(currentProgress * 100))%", strokeWidth: -6.0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   
}

