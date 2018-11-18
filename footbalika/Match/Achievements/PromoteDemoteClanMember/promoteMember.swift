//
//  promoteMember.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class promoteMember {
        public func promote(dest_user_id : String , completionHandler : @escaping(String) -> Void ){
            PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'PROMOTE' , 'user_id' : '\(loadingViewController.userid)' , 'clan_id' : '\((login.res?.response?.calnData?.clanid!)!)' , 'dest_user_id' : '\(dest_user_id)'}") { data, error in
                
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
                    
                } else {
                    self.promote(dest_user_id: dest_user_id, completionHandler: {String in
                        print(String)
                    })
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
                }.resume()
    }
}
