//
//  loadingSetting.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class loadingSetting {
    static var res : loadingSettingStructure.Response? = nil;
    public func loadSetting(userid : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getSettings", JSONStr: "{'mode':'READ'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        loadingSetting.res = try JSONDecoder().decode(loadingSettingStructure.Response.self , from : data!)
//                        print((loadingSetting.res?.response?.splash_back!)!)
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("updateProgress"), object: nil)
                        downloadAssets.init().getIDs()
//                        self.updateLastProgress()
                        //                        loadShop.init().loadingShop(userid: userid)
                    } catch {
                        self.loadSetting(userid: userid)
                        print(error)
                    }
                } else {
                    self.loadSetting(userid: userid)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            
            }.resume()
    }
    

}
