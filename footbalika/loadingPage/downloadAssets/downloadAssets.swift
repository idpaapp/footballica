//
//  downloadAssets.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/13/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import RealmSwift

public class downloadAssets {
    
    struct Response : Decodable{
        let matchTypes : [matchTypesDownload.matchTypes]?
        let chargeTypes : [chargeTypesDownload.chargeTypes]?
    }
    
    
    var res : Response? = nil;
    var chargeRead = readAndWritetblChargeTypes()
    var matchTypeRead = readAndWritetblMatchTypes()
    
    var m = [AnyObject]()
    var c = [AnyObject]()

    public func getIDs() {
            self.getMatchTypesIDs()
    }
    
    @objc func getMatchTypesIDs() {
        var matchType = ["id" : Int(),"image_path" : String()] as [String : Any]
        
        if WritetblMatchTypes.matchTypeImagesID.count != 0 {
            for i in 0...WritetblMatchTypes.matchTypeImagesID.count - 1 {
                matchType.updateValue("\(WritetblMatchTypes.matchTypeImagesPath[i])", forKey: "image_path")
                matchType.updateValue("\(WritetblMatchTypes.matchTypeImagesID[i])", forKey: "id")
                
                self.m.append(matchType as AnyObject)
                if i == WritetblMatchTypes.matchTypeImagesID.count - 1 {
                    getChargeTypes()
                }
            }
        } else {
            getChargeTypes()
        }
    }
    
    @objc func getChargeTypes() {
        var chartgeType = ["id" : Int(),"image_path" : String()] as [String : Any]
        
        if WritetblChargeTypes.chargeTypeImagesID.count != 0 {
            for i in 0...WritetblChargeTypes.chargeTypeImagesID.count - 1 {
                chartgeType.updateValue("\(WritetblChargeTypes.chargeTypeImagesPath[i])", forKey: "image_path")
                chartgeType.updateValue("\(WritetblChargeTypes.chargeTypeImagesID[i])", forKey: "id")
                self.c.append(chartgeType as AnyObject)
                if i == WritetblChargeTypes.chargeTypeImagesID.count - 1 {
                    fetchingData()
                }
            }
        } else {
            fetchingData()
        }
    }
    
    @objc func fetchingData() {
        if self.m.count == 0 && self.c.count == 0 {
            downloadShop.init().getIDs()
        } else {
            let jsonPost = [["MatchTypes" : self.m , "ChargeTypes" : self.c]] as [[String : Any]]
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonPost, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            self.downloadingAssets(postString : jsonString)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("updateProgress"), object: nil)
        }
    }
    
    
    public func downloadingAssets(postString : String) {
        
        PubProc.HandleDataBase.readJson(wsName: "reSyncGameData", JSONStr: "{'mode': 'SYNC_DATA' , 'GamehData' : \(postString)}") { data, error in
            DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                if data != nil {
                    
//                    print(data ?? "")
                    
                    do {
                        
                        self.res = try JSONDecoder().decode(Response.self , from : data!)
                                                    
                            
                        if ((self.res?.chargeTypes?.count)!) != 0 {
                            self.chargeTypesDl()
                        }
                        
                        if ((self.res?.matchTypes?.count)!) != 0 {
                            self.matchTypeDl()
                        }
                        
//                        print((self.res?.stadiumData))
                        
//                        if ((self.res?.stadiumData?.count)!) != 0 {
//                            self.stadiumDl()
//                        }
                            
                        downloadShop.init().getIDs()
                            
                    } catch {
                        self.downloadingAssets(postString : postString)
                        print(error)
                    }
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
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
                    self.downloadingAssets(postString : postString)
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    func matchTypeDl() {
        for i in 0...((self.res?.matchTypes?.count)!) - 1 {
            matchTypeRead.writeToDBtblMatchTypes(gameTypesID: Int((self.res?.matchTypes?[i].id!)!)!, gameTypesTitle:"", gameTypesImg_logo: (self.res?.matchTypes?[i].image_path!)! , base64: (self.res?.matchTypes?[i].image_base64!)!)
        }
    }
    
    
    func chargeTypesDl() {
        for i in 0...((self.res?.chargeTypes?.count)!) - 1 {
            chargeRead.writeToDBtblChargeTypes(chargeTypesID: Int((self.res?.chargeTypes?[i].id!)!)!, chargeTypesTitle: "", chargeTypesImagePath: (self.res?.chargeTypes?[i].image_path!)!, base64: (self.res?.chargeTypes?[i].image_base64!)!)
        }
    }
}
