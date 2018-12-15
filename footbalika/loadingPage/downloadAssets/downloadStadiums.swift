//
//  downloadStadiums.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/1/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import RealmSwift

public class downloadStadiums {
    
    struct Response : Decodable {
        let stadiumData : [stadiumDataDownload.stadiumData]?
    }
    
    var res : Response? = nil;
    
    var stadiumData = readAndWritetblStadiums()
    var s = [AnyObject]()

    public func getIDs() {
        
        var stadiumType = ["id" : Int(),"image_path" : String()] as [String : Any]
        
        if WritetblStadiums.stadiumTypeImagesID.count != 0 {
            for i in 0...WritetblStadiums.stadiumTypeImagesID.count - 1 {
                stadiumType.updateValue("\(WritetblStadiums.stadiumTypeImagesPath[i])", forKey: "image_path")
                stadiumType.updateValue("\(WritetblStadiums.stadiumTypeImagesID[i])", forKey: "id")
                
                s.append(stadiumType as AnyObject)
                if i == WritetblStadiums.stadiumTypeImagesID.count - 1 {
                    fetchingData()
                }
            }
        } else {
            fetchingData()
        }
        
       
    }
    
    @objc func fetchingData() {
        if s.count == 0 {
            downloadShop.init().getIDs()
        } else {
            let jsonPost = [["StadiumData" : s]] as [[String : Any]]
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonPost, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            self.downloadingAssets(postString : jsonString)
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
                        
                            //                        print((self.res?.stadiumData))
                            
                            if ((self.res?.stadiumData?.count)!) != 0 {
                                self.stadiumDl()
                            }
                            
                    } catch {
                        self.downloadingAssets(postString : postString)
                        print(error)
                    }
                    PubProc.countRetry = 0 
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
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
    
    func stadiumDl() {
        for i in 0...((self.res?.stadiumData?.count)!) - 1 {
            stadiumData.writeToDBtblStadiumTypes(id: Int((self.res?.stadiumData?[i].id!)!)!, title: "", imagePath: (self.res?.stadiumData?[i].image_path!)!, extendedBase64Image: (self.res?.stadiumData?[i].image_base64!)!)
        }
    }
}

