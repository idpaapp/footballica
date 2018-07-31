//
//  loadShop.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class loadShop {
    static var res : loadShopStructure.Response? = nil;
    var writeShops = readAndWritetblShop()
    public func loadingShop(userid : String) {
        PubProc.HandleDataBase.readJson(wsName: "ws_loadShop", JSONStr: "{'mode':'mainPage' , 'userid' : '\(userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
//                                    print(data ?? "")
                    
//                    print(String(data: data!, encoding: String.Encoding.utf8)!)
                    
                    do {
                        
                        loadShop.res = try JSONDecoder().decode(loadShopStructure.Response.self , from : data!)
                        
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("updateProgress"), object: nil)
                        
                        for i in 0...(loadShop.res?.response?[1].items?.count)! - 1 {
                            for j in 0...(loadShop.res?.response?[1].items?[i].package_awards?.count)! - 1 {
                            let ID = Int((loadShop.res?.response?[1].items?[i].package_awards?[j].id!)!)
                            let id = ID!
//                            let title = ((self.res?.response?[1].items?[i].title!)!)
                            let imagePath = ((loadShop.res?.response?[1].items?[i].package_awards?[j].image_path!)!)
                            let base64 = ""
                            self.writeShops.writeToDBtblhop(shopID: id, shopImage_Path: imagePath, shopImage_Base64: base64)
                            }
                        }
//                        print(self.res?.response?[1].items?[0].package_awards?[0].image_path!)
                        loadingAchievements.init().loadAchievements(userid: userid)
                    } catch {
                        self.loadingShop(userid: userid)
                        print(error)
                    }
                } else {
                    self.loadingShop(userid: userid)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            
            }.resume()
    }
}
