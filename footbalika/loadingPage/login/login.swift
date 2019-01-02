//
//  login.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class login {
    static var res : loginStructure.Response? = nil;
    static var res2 :  loginStructure.Response? = nil;
    public func loging(userid : String , rest : Bool , completionHandler : @escaping () -> Void) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(userid)' , 'load_stadium' : 'false'}") { data, error in
            DispatchQueue.main.async {

            if data != nil {
                    PubProc.cV.hideWarning()
                //                print(data ?? "")
                
            
                
                if matchViewController.userid == userid {
                    do {
                        
                        login.res = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        
//                        print(String(data: data!, encoding: String.Encoding.utf8) as? String)
//                        print((login.res?.response?.calnData))
                        
                        completionHandler()
                        if rest {
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("updateProgress"), object: nil)
                            loadShop.init().loadingShop(userid: userid, rest: true, completionHandler: {
                            })
                        }
                    } catch {
                        self.loging(userid: userid, rest: rest, completionHandler: {
                        })
                        print(error)
                    }
                } else {
                    do {
                        
                        login.res2 = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        
//                        print(String(data: data!, encoding: String.Encoding.utf8) as? String)
//                        print((login.res2?.response?.calnData))
                        
                        completionHandler()
                        if rest {
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("updateProgress"), object: nil)
                            loadShop.init().loadingShop(userid: userid, rest: true, completionHandler: {
                            })
                        }
                    } catch {
                        self.loging(userid: userid, rest: rest, completionHandler: {
                        })
                        print(error)
                    }
                }

                PubProc.countRetry = 0 
            } else {
                PubProc.countRetry = PubProc.countRetry + 1
                if PubProc.countRetry == 10 {
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.loging(userid: userid, rest: rest, completionHandler: {
                })
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
