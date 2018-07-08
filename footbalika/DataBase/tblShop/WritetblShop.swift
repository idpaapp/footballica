//
//  WritetblShop.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import RealmSwift

public class WritetblShop {
    
        var realm : Realm!
        var tblShopArray : Results<tblShop> {
            get {
                realm = try! Realm()
                return realm.objects(tblShop.self)
            }
        }
    
    static var shopImagesID = [Int]()
    static var shopImagesPath = [String]()
        
        public func writeToDBShop(shopid : Int , shopimage : String , shopbase64 : String ) {
            do {
                let realms = try! Realm()
                try realms.write({
                    let Tblshop = tblShop()
                    Tblshop.id = shopid
//                    print(Tblshop.id)
//                    print(shopid)
                    Tblshop.image_path = shopimage
                    if shopbase64 != "" {
                    Tblshop.img_base64 = shopbase64
                    }
                    realms.add(Tblshop, update: false)
                    WritetblShop.shopImagesID.append(Tblshop.id)
                    WritetblShop.shopImagesPath.append(Tblshop.image_path)
//                    print(" variable stored.")
//                    print(self.tblShopArray.count)
                })
            }catch let error {
                print(error)
            }
        }
}
