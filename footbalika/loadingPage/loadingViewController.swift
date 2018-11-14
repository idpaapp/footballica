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
                if UIScreen.main.bounds.height < 568 {
                    self.ballProgress.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                } else {
                    self.ballProgress.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }
                
            })
            self.ballState = 1
        } else {
            UIView.animate(withDuration: 0.7, animations: {
                if UIScreen.main.bounds.height < 568 {
                    self.ballProgress.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                } else {
                    self.ballProgress.transform = CGAffineTransform.identity
                }
            })
            self.ballState = 0
        }
    }
    
    var fonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadFonts = UIFont(name: "DPA_Game", size: 35)!
    let defaults = UserDefaults.standard
    
    func versionCheck() {
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            print("version : \(version)")
            AppVersion = version
        }
    }
    
    static var loadGameData : gameDataModel.Response? = nil;
    var writetblMatchTypes = readAndWritetblMatchTypes()
    var writeChargeTypes = readAndWritetblChargeTypes()
    var writeStadiums = readAndWritetblStadiums()
    
    @objc func gameData() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_loadGameData", JSONStr: "{'matchID':'0'}") { data, error in
            
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        loadingViewController.loadGameData = try JSONDecoder().decode(gameDataModel.Response.self , from : data!)
                        
                        print("***************************\((loadingViewController.loadGameData?.response?.onLineTime!)!)")
                        
                        loadingViewController.OnlineTime = (loadingViewController.loadGameData?.response?.onLineTime!)!
                        
                        DispatchQueue.main.async {
                            PubProc.cV.hideWarning()
                            for i in 0...(loadingViewController.loadGameData?.response?.gameTypes.count)! - 1 {
                                let gametID = Int((loadingViewController.loadGameData?.response?.gameTypes[i].id!)!)
                                let gameTypesID = gametID!
                                
                                let gameTypesTitle = ((loadingViewController.loadGameData?.response?.gameTypes[i].title!)!.replacedArabicCharactersToPersian)
                                let gameTypesImg_logo = ((loadingViewController.loadGameData?.response?.gameTypes[i].img_logo!)!)
                                self.writetblMatchTypes.writeToDBtblMatchTypes(gameTypesID: gameTypesID, gameTypesTitle: gameTypesTitle, gameTypesImg_logo: gameTypesImg_logo, base64: "")
                                
                            }
                            
                            for i in 0...(loadingViewController.loadGameData?.response?.gameCharge.count)! - 1 {
                                let ID = Int((loadingViewController.loadGameData?.response?.gameCharge[i].id!)!)
                                let chargeTypesID = ID!
                                let chargeTypesTitle = ((loadingViewController.loadGameData?.response?.gameCharge[i].title!)!)
                                let chargeTypesImagePath = ((loadingViewController.loadGameData?.response?.gameCharge[i].image_path!)!)
                                self.writeChargeTypes.writeToDBtblChargeTypes(chargeTypesID: chargeTypesID, chargeTypesTitle: chargeTypesTitle, chargeTypesImagePath: chargeTypesImagePath, base64: "")
                            }
                            
                            for i in 0...(loadingViewController.loadGameData?.response?.stadiumData.count)! - 1 {
                                let ID = Int((loadingViewController.loadGameData?.response?.stadiumData[i].id!)!)
                                let id = ID!
                                let title = ((loadingViewController.loadGameData?.response?.stadiumData[i].title!)!)
                                let imagePath = ((loadingViewController.loadGameData?.response?.stadiumData[i].extended_image!)!)
                                let extendImage = ""
                                self.writeStadiums.writeToDBtblStadiumTypes(id: id, title: title, imagePath: imagePath, extendedBase64Image: extendImage)
                                //                            print(title)
                                //                            print(imagePath)
                            }
                            
                            self.endProgress = 0.1
                            self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.progressing), userInfo: nil, repeats: true)
                            if loadingViewController.userid != "0" {
                                login.init().loging(userid: loadingViewController.userid, rest: true, completionHandler: {
                                })
                                
                            } else {
                                self.performSegue(withIdentifier: "loginUser", sender: self)
                            }
                        }
                    } catch {
                        self.gameData()
                        print(error)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.gameData()
                    })
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    static var userid = "0"
    var realm : Realm!
    
    var launchedBefore = Bool()
    var playMenuMusic = Bool()
    var playgameSounds = Bool()
    var alerts = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionCheck()
        
        print(UIDevice().localizedModel.description)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateProgress), name: Notification.Name("updateProgress"), object: nil)
        
        realm = try! Realm()
        self.gameData()
        
        launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        
        if self.launchedBefore  {
            
            playMenuMusic = UserDefaults.standard.bool(forKey: "menuMusic")
            playgameSounds = UserDefaults.standard.bool(forKey: "gameSounds")
            alerts = UserDefaults.standard.bool(forKey: "alerts")
            loadingViewController.userid = defaults.string(forKey: "userid") ?? String()
            defaults.set(false , forKey: "tutorial")
        } else {
            
            let userid = "\(loadingViewController.userid)"
            defaults.set(userid, forKey: "userid")
            defaults.set(true, forKey: "launchedBefore")
            defaults.set(true, forKey: "menuMusic")
            defaults.set(true, forKey: "gameSounds")
            defaults.set("", forKey: "lastMatchId")
            defaults.set("", forKey: "gameLeft")
            defaults.set(true , forKey: "tutorial")
            
        }
        
        if UIScreen.main.bounds.height < 568 {
            self.ballProgress.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        } else {
            self.ballProgress.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        ballTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(ballProgressing), userInfo: nil, repeats: true)
        
        self.mainProgressBackGround.layer.cornerRadius = 5
        self.ProgressBackGroundView.layer.cornerRadius = 5
        //        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(progressing), userInfo: nil, repeats: true)
        self.loadingProgress.progress = 0
        self.loadingProgressLabel.text = "۰٪"
    }
    
    public var endProgress = Float()
    @objc public func progressing() {
        DispatchQueue.main.async {
            if self.currentProgress < self.endProgress {
                self.currentProgress = (self.currentProgress * 100).rounded() / 100
                if self.currentProgress == 0.99 {
                    self.currentProgress = 1.0
                    self.loadingProgress.progress = self.currentProgress
                    if UIDevice().userInterfaceIdiom == .phone {
                        print("self.currentProgress\(self.currentProgress)")
                        self.loadingProgressLabel.AttributesOutLine(font: self.fonts , title: "\(Int(self.currentProgress * 100))%", strokeWidth: -6.0)
                    } else {
                        self.loadingProgressLabel.AttributesOutLine(font: self.iPadFonts , title: "\(Int(self.currentProgress * 100))%", strokeWidth: -6.0)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.timer.invalidate()
                        self.ballTimer.invalidate()
                        downloadStadiums.init().getIDs()
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
                            self.loadingProgressLabel.AttributesOutLine(font: self.fonts , title: "\(Int(self.currentProgress * 100))%", strokeWidth: -6.0)
                        } else {
                            self.loadingProgressLabel.AttributesOutLine(font: self.iPadFonts , title: "\(Int(self.currentProgress * 100))%", strokeWidth: -6.0)
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
    
    static var OnlineTime = Int64()
//    @objc func getOnlineTime() {
//        PubProc.HandleDataBase.readJson(wsName: "ws_getOnlineTime", JSONStr: "{'matchID':'0'}") { data, error in
//
//            if data != nil {
//                let Response = String(data: data!, encoding: String.Encoding.utf8) as String?
//                loadingViewController.OnlineTime = (Response as NSString?)?.floatValue ?? 0
//                print("Online Time : \(loadingViewController.OnlineTime)")
//                self.gameData()
//            } else {
//                self.getOnlineTime()
//                print(error as Any)
//                print("ErrorConnection")
//            }
//            }.resume()
//    }
}

