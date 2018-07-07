//
//  WritetblChargeTypes.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import RealmSwift

public class WritetblChargeTypes {
    
    var realm : Realm!
    var tblChargeTypesArray : Results<tblChargeTypes> {
        get {
            realm = try! Realm()
            return realm.objects(tblChargeTypes.self)
        }
    }
    static var chargeTypeImagesID = [Int]()
    static var chargeTypeImagesPath = [String]()
    public func writeToDBChargeTypes(id : Int , title : String , imagePath : String , base64 : String ) {
        do {
            let realms = try! Realm()
            try realms.write({
                let TblChargeTypes = tblChargeTypes()
                TblChargeTypes.id = id
//                print(TblChargeTypes.id)
//                print(id)
                 if title != "" {
                TblChargeTypes.title = title
                }
                TblChargeTypes.img_logo = imagePath
                if base64 != "" {
                    TblChargeTypes.img_base64 = base64
                }
//                print(TblChargeTypes.img_base64)
                realms.add(TblChargeTypes, update: false)
                WritetblChargeTypes.chargeTypeImagesID.append(TblChargeTypes.id)
                WritetblChargeTypes.chargeTypeImagesPath.append(TblChargeTypes.img_logo)
//                print(" variable stored.")
//                print(self.tblChargeTypesArray.count)
            })
        }catch let error {
            print(error)
        }
    }
}
