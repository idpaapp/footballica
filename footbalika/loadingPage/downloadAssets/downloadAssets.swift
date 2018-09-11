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
        let stadiumData : [stadiumDataDownload.stadiumData]?
    }
    
    
    var res : Response? = nil;
    var chargeRead = readAndWritetblChargeTypes()
    var matchTypeRead = readAndWritetblMatchTypes()
    var stadiumData = readAndWritetblStadiums()
    
    
    public func getIDs() {
        
        var stadiumType = ["id" : Int(),"image_path" : String()] as [String : Any]
        
        var s = [AnyObject]()
        if WritetblStadiums.stadiumTypeImagesID.count != 0 {
            for i in 0...WritetblStadiums.stadiumTypeImagesID.count - 1 {
                stadiumType.updateValue("\(WritetblStadiums.stadiumTypeImagesPath[i])", forKey: "image_path")
                stadiumType.updateValue("\(WritetblStadiums.stadiumTypeImagesID[i])", forKey: "id")
                
                s.append(stadiumType as AnyObject)
                
            }
        }
        
        var matchType = ["id" : Int(),"image_path" : String()] as [String : Any]

        var m = [AnyObject]()
        if WritetblMatchTypes.matchTypeImagesID.count != 0 {
        for i in 0...WritetblMatchTypes.matchTypeImagesID.count - 1 {
            matchType.updateValue("\(WritetblMatchTypes.matchTypeImagesPath[i])", forKey: "image_path")
            matchType.updateValue("\(WritetblMatchTypes.matchTypeImagesID[i])", forKey: "id")
        
            m.append(matchType as AnyObject)
            
            }
        }
        
        var c = [AnyObject]()
        var chartgeType = ["id" : Int(),"image_path" : String()] as [String : Any]

        if WritetblChargeTypes.chargeTypeImagesID.count != 0 {
        for i in 0...WritetblChargeTypes.chargeTypeImagesID.count - 1 {
            chartgeType.updateValue("\(WritetblChargeTypes.chargeTypeImagesPath[i])", forKey: "image_path")
            chartgeType.updateValue("\(WritetblChargeTypes.chargeTypeImagesID[i])", forKey: "id")
            c.append(chartgeType as AnyObject)
            }
        }
        
        if m.count == 0 && c.count == 0 && s.count == 0 {
        downloadShop.init().getIDs()
        } else {
            let jsonPost = [["MatchTypes" : m , "ChargeTypes" : c , "StadiumData" : s]] as [[String : Any]]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonPost, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        downloadingAssets(postString : jsonString)
        downloadShop.init().getIDs()
        }
        
//        StadiumData
        
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
                        
                        if ((self.res?.stadiumData?.count)!) != 0 {
                            self.stadiumDl()
                        }
                        
                    } catch {
                        self.downloadingAssets(postString : postString)
                        print(error)
                    }
                } else {
                    self.downloadingAssets(postString : postString)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    func stadiumDl() {
        for i in 0...((self.res?.stadiumData?.count)!) - 1 {
            stadiumData.writeToDBtblStadiumTypes(id: Int((self.res?.stadiumData?[i].id!)!)!, title: "", imagePath: (self.res?.stadiumData?[i].image_path!)!, extendedBase64Image: (self.res?.stadiumData?[i].image_base64!)!)
        }
    }
    
    
    func matchTypeDl() {
        for i in 0...((self.res?.matchTypes?.count)!) - 1 {
            matchTypeRead.writeToDBtblMatchTypes(gameTypesID: Int((self.res?.matchTypes?[i].id!)!)!, gameTypesTitle:"", gameTypesImg_logo: (self.res?.matchTypes?[i].image_path!)! , base64: (self.res?.matchTypes?[i].image_base64!)! )
        }
    }
    
    
    func chargeTypesDl() {
        for i in 0...((self.res?.chargeTypes?.count)!) - 1 {
            chargeRead.writeToDBtblChargeTypes(chargeTypesID: Int((self.res?.chargeTypes?[i].id!)!)!, chargeTypesTitle: "", chargeTypesImagePath: (self.res?.chargeTypes?[i].image_path!)!, base64: (self.res?.chargeTypes?[i].image_base64!)!)
        }
    }
}
