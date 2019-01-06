//
//  loadingViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class loadingViewController: UIViewController {
    
    @IBOutlet weak var loadingProgress: UIProgressView!
    @IBOutlet weak var loadingProgressLabel: UILabel!
    @IBOutlet weak var ProgressBackGroundView: UIView!
    @IBOutlet weak var mainProgressBackGround: UIView!
    
    var timer : Timer!
    var currentProgress = Float()
    var AppVersion = Int()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let defaults = UserDefaults.standard
    
    func versionCheck() {
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            print("version : \(version)")
            self.AppVersion = Int(version)!
        }
    }
    
    
    var writetblMatchTypes = readAndWritetblMatchTypes()
    var writeChargeTypes = readAndWritetblChargeTypes()
    var writeStadiums = readAndWritetblStadiums()
    
    @objc func gameData() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_loadGameData", JSONStr: "{'matchID':'0'}") { data, error in
            
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        gameDataModel.loadGameData = try JSONDecoder().decode(gameDataModel.Response.self , from : data!)
                        
                        
                        matchViewController.OnlineTime = (gameDataModel.loadGameData?.response?.onLineTime!)!
                        
                         print("***************************\(matchViewController.OnlineTime)")
                        onlineTime().OnlineTimer()
                        
                        if self.AppVersion < (gameDataModel.loadGameData?.response?.androidForceUpdateVersionSibApp)! {

                            self.performSegue(withIdentifier: "forceUpdate", sender: self)
                            
                        } else {
                        DispatchQueue.main.async {
                            PubProc.cV.hideWarning()
                            for i in 0...(gameDataModel.loadGameData?.response?.gameTypes.count)! - 1 {
                                let gametID = Int((gameDataModel.loadGameData?.response?.gameTypes[i].id!)!)
                                let gameTypesID = gametID!
                                
                                let gameTypesTitle = ((gameDataModel.loadGameData?.response?.gameTypes[i].title!)!.replacedArabicCharactersToPersian)
                                let gameTypesImg_logo = ((gameDataModel.loadGameData?.response?.gameTypes[i].img_logo!)!)
                                self.writetblMatchTypes.writeToDBtblMatchTypes(gameTypesID: gameTypesID, gameTypesTitle: gameTypesTitle, gameTypesImg_logo: gameTypesImg_logo, base64: "")
                                
                            }
                            
                            for i in 0...(gameDataModel.loadGameData?.response?.gameCharge.count)! - 1 {
                                let ID = Int((gameDataModel.loadGameData?.response?.gameCharge[i].id!)!)
                                let chargeTypesID = ID!
                                let chargeTypesTitle = ((gameDataModel.loadGameData?.response?.gameCharge[i].title!)!)
                                let chargeTypesImagePath = ((gameDataModel.loadGameData?.response?.gameCharge[i].image_path!)!)
                                self.writeChargeTypes.writeToDBtblChargeTypes(chargeTypesID: chargeTypesID, chargeTypesTitle: chargeTypesTitle, chargeTypesImagePath: chargeTypesImagePath, base64: "")
                            }
                            
                            for i in 0...(gameDataModel.loadGameData?.response?.stadiumData.count)! - 1 {
                                let ID = Int((gameDataModel.loadGameData?.response?.stadiumData[i].id!)!)
                                let id = ID!
                                let title = ((gameDataModel.loadGameData?.response?.stadiumData[i].title!)!)
                                let imagePath = ((gameDataModel.loadGameData?.response?.stadiumData[i].extended_image!)!)
                                let extendImage = ""
                                self.writeStadiums.writeToDBtblStadiumTypes(id: id, title: title, imagePath: imagePath, extendedBase64Image: extendImage)
                                //                            print(title)
                                //                            print(imagePath)
                            }
                            
                            self.endProgress = 0.1
                            self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.progressing), userInfo: nil, repeats: true)
                            if matchViewController.userid != "0" {
                                login.init().loging(userid: matchViewController.userid, rest: true, completionHandler: {
                                })
                                
                            } else {
                                self.performSegue(withIdentifier: "loginUser", sender: self)
                            }
                        }
                        }
                        
                    } catch {
                        self.gameData()
                        print(error)
                    }
                    PubProc.countRetry = 0 
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry >= 10 {

                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                            PubProc.cV.hideWarning()
                        }
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "noInternetViewController")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = viewController
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self.gameData()
                    })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    var realm : Realm!
    
    var launchedBefore = Bool()
    var playMenuMusic = Bool()
    var playgameSounds = Bool()
    var alerts = Bool()
    var gameLeft = String()
    var clanGameLeft = String()
    let nc = NotificationCenter.default

    func checkLaunchBefore() {
        
        launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        
        if self.launchedBefore  {
            
            playMenuMusic = UserDefaults.standard.bool(forKey: "menuMusic")
            playgameSounds = UserDefaults.standard.bool(forKey: "gameSounds")
            alerts = UserDefaults.standard.bool(forKey: "alerts")
            matchViewController.userid = defaults.string(forKey: "userid") ?? String()
            defaults.set(false , forKey: "tutorial")
            //             self.gameLeft = String()
            self.gameData()
        } else {
            let userid = "0"
            defaults.set(userid, forKey: "userid")
            defaults.set(true, forKey: "launchedBefore")
            defaults.set(true, forKey: "menuMusic")
            defaults.set(true, forKey: "gameSounds")
            defaults.set("", forKey: "lastMatchId")
            defaults.set("", forKey: "gameLeft")
            defaults.set(true , forKey: "tutorial")
            defaults.set(["0"], forKey: "publicMassagesIDS")
            matchViewController.userid = defaults.string(forKey: "userid") ?? String()
            self.gameData()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionCheck()
        
        print(UIDevice().localizedModel.description)
        nc.addObserver(self, selector: #selector(updateProgress), name: Notification.Name("updateProgress"), object: nil)
        
        realm = try! Realm()
        
        
        checkLaunchBefore()
        
       
        
        
        
        
        //        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(progressing), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.mainProgressBackGround.layer.cornerRadius = 5
        self.ProgressBackGroundView.layer.cornerRadius = 5
        self.loadingProgress.progress = 0
        self.loadingProgressLabel.text = "۰٪"
    }
    
    var endProgress = Float()
    @objc func progressing() {
        DispatchQueue.main.async {
            if self.currentProgress < self.endProgress {
                self.currentProgress = (self.currentProgress * 100).rounded() / 100
                if self.currentProgress == 0.99 {
                    self.currentProgress = 1.0
                    self.loadingProgress.progress = self.currentProgress
                    if UIDevice().userInterfaceIdiom == .phone {
                        print("self.currentProgress\(self.currentProgress)")
                        self.loadingProgressLabel.AttributesOutLine(font: fonts().iPhonefonts , title: "\(Int(self.currentProgress * 100))%", strokeWidth: -5.0)
                    } else {
                        self.loadingProgressLabel.AttributesOutLine(font: fonts().large35 , title: "\(Int(self.currentProgress * 100))%", strokeWidth: -5.0)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.timer.invalidate()
                        self.performSegue(withIdentifier: "showMainMenu", sender: self)
                        PubProc.isSplash = false
                    })
                } else {
                    if self.currentProgress >= self.endProgress {
                        self.timer.invalidate()
                    } else {
                        self.currentProgress = self.currentProgress + 0.01
                        self.loadingProgress.progress = self.currentProgress
                        if UIDevice().userInterfaceIdiom == .phone {
                            self.loadingProgressLabel.AttributesOutLine(font: fonts().iPhonefonts , title: "\(Int(self.currentProgress * 100))%", strokeWidth: -5.0)
                        } else {
                            self.loadingProgressLabel.AttributesOutLine(font: fonts().large35 , title: "\(Int(self.currentProgress * 100))%", strokeWidth: -5.0)
                        }
                    }
                }
            }
        }
    }
    
    @objc func updateProgress() {
        self.endProgress = self.endProgress + 0.1
        if self.endProgress > 1.0 {
            self.endProgress = 1.0
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.progressing), userInfo: nil, repeats: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? menuAlertViewController {
            vc.alertState = "forceUpdate"
            vc.alertBody = "فوتبالیکا برای اجرا نیاز به به روز رسانی دارد"
            vc.alertTitle = "فوتبالیکا"
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
//        nc.removeObserver(self)
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "testTapsellViewController") as! testTapsellViewController
//        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
//    deinit {
//        print("*************deinit*************")
//    }
}

