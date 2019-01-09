//
//  getAdsPrize.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 10/18/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class getAdsPrize {
    public func getReward(userid : String , type : String, completionHandler : @escaping () -> Void) {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_handleDailyReward", JSONStr: "{'mode' : 'GetReward' , 'type' : '\(type)', 'userid' : '\(userid)'}") { data, error in
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self, from: data!)
                        
                        completionHandler()
                        
                    } catch {
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        PubProc.wb.hideWaiting()
                    }
                    
                } else {
                    self.getReward(userid: userid, type: type, completionHandler: {})
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
                }.resume()

    }
    
    
    public func getMenuReward(userid : String , mode : String, completionHandler : @escaping () -> Void) {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_updtUser", JSONStr: "{'mode' : '\(mode)', 'userid' : '\(userid)'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                do {
                    
                    login.res = try JSONDecoder().decode(loginStructure.Response.self, from: data!)
                    
                    completionHandler()
                    
                } catch {
                    print(error)
                }
                
                DispatchQueue.main.async {
                    PubProc.wb.hideWaiting()
                }
                
            } else {
                self.getMenuReward(userid: userid, mode: mode, completionHandler: {})
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
        
    }
    
//    ws_updtUser.php
//    mode|userid
//    VIDEO_CLICKED|VIDEO_VIEW
    
}
