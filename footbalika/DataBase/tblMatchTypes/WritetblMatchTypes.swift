//
//  WritetblMatchTypes.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import RealmSwift

public class WritetblMatchTypes {
    
    var realm : Realm!
    var tblMatchTypesArray : Results<tblMatchTypes> {
        get {
            realm = try! Realm()
            return realm.objects(tblMatchTypes.self)
        }
    }
    static var matchTypeImagesID = [Int]()
    static var matchTypeImagesPath = [String]()
    public func writeToDB(gameTypesID : Int , gameTypesTitle : String , gameTypesImg_logo : String , base64 : String) {
        do {
            let realms = try! Realm()
            try realms.write({
                if self.tblMatchTypesArray.count != 0 {
                    
//                    print(self.realm.objects(tblMatchTypes.self).value(forKey: "id").debugDescription)
                    let realmID = self.realm.objects(tblMatchTypes.self).filter("id == \(gameTypesID)")
//                    let counts = realm.objects(tblChargeTypes.self)
//                    print(counts.count)
//                    print("self.tblMatchTypesArray.count\(self.tblMatchTypesArray.count)")
                    if realmID.first?.id != nil {
                        DispatchQueue.main.async {
                            try! self.realm.write {
                            realmID.first?.img_base64 = base64
                            }
                        }
                    } else {
                        let TblMatchTypes = tblMatchTypes()
                        TblMatchTypes.id = gameTypesID
                        //                print(TblMatchTypes.id)
                        //                print(gameTypesID)
                        if gameTypesTitle != "" {
                            TblMatchTypes.title = gameTypesTitle
                        }
                        TblMatchTypes.img_logo = gameTypesImg_logo
                        if base64 != "" {
                            TblMatchTypes.img_base64 = base64
                        }
                        realms.add(TblMatchTypes, update: false)
                        WritetblMatchTypes.matchTypeImagesID.append(TblMatchTypes.id)
                        WritetblMatchTypes.matchTypeImagesPath.append(TblMatchTypes.img_logo)
                        //                print("variable stored.")
                        //                print(self.tblMatchTypesArray.count)
                    }
                    
                } else {
                let TblMatchTypes = tblMatchTypes()
                TblMatchTypes.id = gameTypesID
//                print(TblMatchTypes.id)
//                print(gameTypesID)
                if gameTypesTitle != "" {
                TblMatchTypes.title = gameTypesTitle
                }
                TblMatchTypes.img_logo = gameTypesImg_logo
                if base64 != "" {
                    TblMatchTypes.img_base64 = base64
                }
                realms.add(TblMatchTypes, update: false)
                WritetblMatchTypes.matchTypeImagesID.append(TblMatchTypes.id)
                WritetblMatchTypes.matchTypeImagesPath.append(TblMatchTypes.img_logo)
//                print("variable stored.")
//                print(self.tblMatchTypesArray.count)
                }
            })
        }catch let error {
            print(error)
        }
    }
}
