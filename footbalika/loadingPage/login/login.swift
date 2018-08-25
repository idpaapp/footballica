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
    public func loging(userid : String , rest : Bool , completionHandler : @escaping () -> Void) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(userid)' , 'load_stadium' : 'false'}") { data, error in
            DispatchQueue.main.async {

            if data != nil {
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                //                print(data ?? "")

                do {
                    
                    login.res = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                    completionHandler()
//                    print((self.res?.response?.mainInfo?.badge_name!)!)
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
                self.loging(userid: userid, rest: rest, completionHandler: {
                })
                print("Error Connection")
                print(error as Any)
                // handle error
                }
            }
            }.resume()
    }
}
