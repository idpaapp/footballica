//
//  downloadShop.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class downloadShop {
    
    struct Response : Decodable{
        let shopTypes : shopDownload.shopItems?
    }
    
    var res : [shopDownload.shopItems]? = nil;
    var shopRead = readAndWritetblShop()
    
    public func getIDs() {
        
        var shopType = ["id" : Int(),"image_path" : String()] as [String : Any]
        
        var m = [AnyObject]()
        if WritetblShop.shopImagesID.count != 0 {
            for i in 0...WritetblShop.shopImagesID.count - 1 {
                shopType.updateValue("\(WritetblShop.shopImagesPath[i])", forKey: "image_path")
                shopType.updateValue("\(WritetblShop.shopImagesID[i])", forKey: "id")
                m.append(shopType as AnyObject)
            }
        }
        
        if m.count == 0  {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("updateProgress"), object: nil)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("updateProgress"), object: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("updateProgress"), object: nil)
            }
        } else {
            let jsonPost = m as Any
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonPost, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            downloadingAssets(postString : jsonString)
        }
                
        
        
    }
    
    public func downloadingAssets(postString : String) {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_reSyncShop", JSONStr: "{'mode': 'SYNC_DATA' , 'shopData' : \(postString)}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
//                    print(data ?? "")
//                    print(String(data: data!, encoding: String.Encoding.utf8)!)
                    
                    do {
                        
                        self.res = try JSONDecoder().decode([shopDownload.shopItems].self , from : data!)
                        
                        if ((self.res?.count)!) != 0 {
                            self.shopDl()
                        }
                        
                    } catch {
//                        self.downloadingAssets(postString : postString)
                        print(error)
                    }
                } else {
                    self.downloadingAssets(postString : postString)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    func shopDl() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("updateProgress"), object: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("updateProgress"), object: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("updateProgress"), object: nil)
        }
        
        for i in 0...((self.res?.count)!) - 1 {
            shopRead.writeToDBtblhop(shopID: Int((self.res?[i].id!)!)!, shopImage_Path: (self.res?[i].image_path!)!, shopImage_Base64: (self.res?[i].image_base64!)!)
        }
    }
    
}
