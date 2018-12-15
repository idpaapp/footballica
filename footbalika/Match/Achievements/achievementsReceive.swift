//
//  achievementsReceive.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/26/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class achievementsReceive {
    var collectingItemAchievement : String? = nil;
    
    public func achievementReceive(id : Int , completionHandler : @escaping() -> Void) {
        PubProc.HandleDataBase.readJson(wsName: "ws_updateAchievements", JSONStr: "{'achievement_id' : '\(id)' ,'userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    self.collectingItemAchievement = String(data: data!, encoding: String.Encoding.utf8) as String?
                    
                    print(((self.collectingItemAchievement)!))
                    if ((self.collectingItemAchievement)!).contains("OK") {
                        loadingAchievements.init().loadAchievements(userid: loadingViewController.userid, rest: false, completionHandler: {
                            DispatchQueue.main.async {
                                completionHandler()
                                PubProc.wb.hideWaiting()
                                thirdSoundPlay().playCollectItemSound()
                            }
                        })
                    } else {
                        DispatchQueue.main.async {
                            completionHandler()
                            PubProc.wb.hideWaiting()
                        }
                    }
                    PubProc.countRetry = 0 
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.achievementReceive(id : id, completionHandler: {})
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
}
