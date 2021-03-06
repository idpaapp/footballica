//
//  loadMassages.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class loadMassages {
    static var res : loadMassagesStructure.Response? = nil;

    public func loadingMassage(userid : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_HandleMessages", JSONStr: "{'mode':'READ' , 'userid' : '\(userid)'}") { data, error in
            DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                if data != nil {

                    //                print(data ?? "")

                    do {

                        loadMassages.res = try JSONDecoder().decode(loadMassagesStructure.Response.self , from : data!)
//                        print((loadMassages.res?.response?[0].avatar!)!)
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("updateProgress"), object: nil)
                        loadingSetting.init().loadSetting(userid: userid)
                    } catch {
                        self.loadingMassage(userid: userid)
                        print(error)
                    }
                    PubProc.countRetry = 0 
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.loadingMassage(userid: userid)
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
