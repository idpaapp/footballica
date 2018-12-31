//
//  demoteMember.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class demoteMember {
    public func demoteMember(dest_user_id : String , completionHandler : @escaping(String) -> Void ) {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'DEMOTE' , 'user_id' : '\(loadingViewController.userid)' , 'clan_id' : '\((login.res?.response?.calnData?.clanid!)!)' , 'dest_user_id' : '\(dest_user_id)'}") { data, error in
                
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    let res = String(data: data!, encoding: String.Encoding.utf8) as Any as! String
                    
                    completionHandler(res)

                    DispatchQueue.main.async {
                        PubProc.wb.hideWaiting()
                    }
                    PubProc.countRetry = 0 
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.demoteMember(dest_user_id: dest_user_id, completionHandler: {String in
                    })
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
                }.resume()
    }
    
    public func kickMember(dest_user_id : String , completionHandler : @escaping(String) -> Void ) {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'KICK' , 'user_id' : '\(loadingViewController.userid)' , 'clan_id' : '\((login.res?.response?.calnData?.clanid!)!)' , 'dest_user_id' : '\(dest_user_id)'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                let res = String(data: data!, encoding: String.Encoding.utf8) as Any as! String
                
                completionHandler(res)
                
                DispatchQueue.main.async {
                    PubProc.wb.hideWaiting()
                }
                PubProc.countRetry = 0
            } else {
                PubProc.countRetry = PubProc.countRetry + 1
                if PubProc.countRetry == 10 {
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self.kickMember(dest_user_id: dest_user_id, completionHandler: {String in
                        })
                    })
                }
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
    }
    
    public func forceKickMember(dest_user_id : String , completionHandler : @escaping(String) -> Void ) {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'FORCED_KICK' , 'user_id' : '\(loadingViewController.userid)' , 'clan_id' : '\((login.res?.response?.calnData?.clanid!)!)' , 'dest_user_id' : '\(dest_user_id)'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                let res = String(data: data!, encoding: String.Encoding.utf8) as Any as! String
                
                completionHandler(res)
                
                DispatchQueue.main.async {
                    PubProc.wb.hideWaiting()
                }
                PubProc.countRetry = 0
            } else {
                PubProc.countRetry = PubProc.countRetry + 1
                if PubProc.countRetry == 10 {
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self.kickMember(dest_user_id: dest_user_id, completionHandler: {String in
                        })
                    })
                }
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
    }
        
}
