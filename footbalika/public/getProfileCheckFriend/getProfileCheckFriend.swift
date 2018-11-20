//
//  getProfileCheckFriend.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/28/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class getProfileCheckFriend {
    static var profileResponse : loginStructure.Response? = nil
    public func getProfile(otherUserid : String , completionHandler : @escaping() -> Void) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getUserInfo", JSONStr: "{'mode':'GetByID' , 'userid' : '\(otherUserid)' , 'load_stadium' : 'false' , 'my_userid' : '\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    PubProc.cV.hideWarning()
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        getProfileCheckFriend.profileResponse = try JSONDecoder().decode(loginStructure.Response.self , from : data!)
                        
                        completionHandler()
                        
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                        }
                    } catch {
                        self.getProfile(otherUserid: otherUserid, completionHandler: {})
                        print(error)
                    }
                } else {
                    self.getProfile(otherUserid: otherUserid, completionHandler: {})
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
}
