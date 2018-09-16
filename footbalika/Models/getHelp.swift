//
//  getHelp.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 6/25/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class getHelp {
    public func gettingHelp(mode : String, completionHandler : @escaping () -> Void) {
        PubProc.HandleDataBase.readJson(wsName: "ws_getTuterial", JSONStr: "{'mode' : '\(mode)'}") { data, error in
                DispatchQueue.main.async {
                    
                    if data != nil {
                        
                        //                      print(data ?? "")
                        do {
                            
                            helpViewController.helpRes = try JSONDecoder().decode(help.Response.self, from: data!)
                            
                            completionHandler()
                            
                            DispatchQueue.main.async {
                                PubProc.cV.hideWarning()
                                PubProc.wb.hideWaiting()
                            }
                            
                        } catch {
                            print(error)
                        }
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 , execute: {
                            self.gettingHelp(mode: mode, completionHandler: {                                
                            })
                        })
                        print("Error Connection")
                        print(error as Any)
                        // handle error
                    }
            }
            }.resume()
    
    }
}
