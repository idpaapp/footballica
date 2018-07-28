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
    public func loging(userid : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(userid)' , 'load_stadium' : 'false'}") { data, error in
            DispatchQueue.main.async {

            if data != nil {
                
                //                print(data ?? "")

                do {
                    
                    login.res = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
//                    print((self.res?.response?.mainInfo?.badge_name!)!)
                    
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name("updateProgress"), object: nil)
                    loadShop.init().loadingShop(userid: userid)
                } catch {
                    self.loging(userid: userid)
                    print(error)
                }
            } else {
                self.loging(userid: userid)
                print("Error Connection")
                print(error as Any)
                // handle error
                }
            }
            }.resume()
    }
}
