//
//  sendClanMatchScores.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/10/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class sendClanMatchScores {
    public func sendClanMatchScores(time : String , score :String , userid : String , war_id : String , completionHandler : @escaping() -> Void) {
    
            PubProc.HandleDataBase.readJson(wsName: "ws_UpdateGameResult", JSONStr: "{'mode' : 'UPDT_WAR_RESULT' , 'score' : '\(score)' , 'time' : '\(time)' , 'userid' : '\(userid)' , 'war_id' : '\(war_id)' }") { data, error in
                if data != nil {
                                        
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    completionHandler()
                    DispatchQueue.main.async {
                        PubProc.wb.hideWaiting()
                    }
                    
                } else {
                    self.sendClanMatchScores(time: time, score: score, userid: userid, war_id: war_id, completionHandler: {})
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
                }.resume()
    }
        
}
