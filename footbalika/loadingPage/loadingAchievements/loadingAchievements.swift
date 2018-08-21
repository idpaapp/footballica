//
//  loadingAchievements.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class loadingAchievements {
    static var res : loadingAchievementsStructure.Response? = nil;
    public func loadAchievements(userid : String , completionHandler : @escaping () -> Void)  {
        PubProc.HandleDataBase.readJson(wsName: "ws_getAchievements", JSONStr: "{'userid' : '\(userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        loadingAchievements.res = try JSONDecoder().decode(loadingAchievementsStructure.Response.self , from : data!)
//                        print((self.res?.response?[0].img_logo!)!)
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("updateProgress"), object: nil)
                        loadMassages.init().loadingMassage(userid: userid)
                        completionHandler()
                    } catch {
                        self.loadAchievements(userid: userid, completionHandler: {
                        })
                        print(error)
                    }
                } else {
                    self.loadAchievements(userid: userid, completionHandler: {
                    })
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            
            }.resume()
    }
}
