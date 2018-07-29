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
    public func writeToDBShop(shopid : Int , shopimage : String , shopbase64 : String) {
        
        do {
            
            let realms = try! Realm()
            try realms.write({
                if self.tblShopArray.count != 0 {

                    let realmID = self.realm.objects(tblShop.self).filter("id == \(shopid)")

                    if realmID.first?.id != nil {
                        DispatchQueue.main.async {
                            if realmID.first?.img_base64 == "" {
                            try! self.realm.write {
                                realmID.first?.img_base64 = shopbase64
                            }
                            }
                        }
                    } else {
                        let TblShop = tblShop()
                        TblShop.id = shopid
                        //                print(TblMatchTypes.id)
                        //                print(gameTypesID)
                        if shopimage != "" {
                            TblShop.image_path = shopimage
                        }
                        if shopbase64 != "" {
                            TblShop.img_base64 = shopbase64
                        }
                        realms.add(TblShop, update: false)
                        WritetblShop.shopImagesID.append(TblShop.id)
                        WritetblShop.shopImagesPath.append(TblShop.image_path)
                                        print("variable stored.")
                        //                print(self.tblMatchTypesArray.count)
                    }

                } else {
                    let TblShop = tblShop()
                    TblShop.id = shopid
                    //                print(TblMatchTypes.id)
                    //                print(gameTypesID)
                    if shopimage != "" {
                        TblShop.image_path = shopimage
                    }
                    if shopbase64 != "" {
                        TblShop.img_base64 = shopbase64
                    }
                    realms.add(TblShop, update: false)
                    WritetblShop.shopImagesID.append(TblShop.id)
                    WritetblShop.shopImagesPath.append(TblShop.image_path)
                                    print("variable stored.")
                    //                print(self.tblMatchTypesArray.count)
                }
            })
        }catch let error {
            print(error)
        }
    }

    
}
