//
//  readAndWritetblShop.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import RealmSwift

public class readAndWritetblShop {
    var realm : Realm!
    var tblShopArray : Results<tblShop> {
        get {
            realm = try! Realm()
            return realm.objects(tblShop.self)
        }
    }
    var WblShop = WritetblShop()
    public func writeToDBtblhop(shopID : Int ,shopImage_Path : String ,shopImage_Base64 : String ) {
        
        DispatchQueue.main.async {
            if self.tblShopArray.count != 0 {
                
                let realmID = self.realm.objects(tblShop.self).filter("id == \(shopID)")
                if realmID.first?.id != nil {
                    if realmID.first?.id == shopID && (realmID.first?.image_path)! == shopImage_Path && (realmID.first?.img_base64)! == shopImage_Base64 {
                    } else {
                        self.WblShop.writeToDBShop(shopid: shopID, shopimage: shopImage_Path, shopbase64: shopImage_Base64)
                    }
                } else {
                    self.WblShop.writeToDBShop(shopid: shopID, shopimage: shopImage_Path, shopbase64: shopImage_Base64)
                }
                
            } else {
                self.WblShop.writeToDBShop(shopid: shopID, shopimage: shopImage_Path, shopbase64: shopImage_Base64)
            }
        }
    }
}

