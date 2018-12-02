//
//  sendClanMatchScores.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/10/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class sendClanMatchScores {
    public func sendClanMatchScores(jsonStr : String , completionHandler : @escaping() -> Void) {
    
        print("sendingClanMatchData : \(jsonStr)")
        completionHandler()
//            PubProc.HandleDataBase.readJson(wsName: "ws_UpdateGameResult", JSONStr: jsonStr) { data, error in
//                if data != nil {
//
//                    DispatchQueue.main.async {
//                        PubProc.cV.hideWarning()
//                    }
//
//                    //                print(data ?? "")
//        UserDefaults.standard.set("" , forKey : "clanGameLeft")
//                    completionHandler()
//                    DispatchQueue.main.async {
//                        PubProc.wb.hideWaiting()
//                    }
//
//                } else {
//                    self.sendClanMatchScores(jsonStr: jsonStr, completionHandler: {})
//                    print("Error Connection")
//                    print(error as Any)
//                    // handle error
//                }
//                }.resume()
    }
        
}
