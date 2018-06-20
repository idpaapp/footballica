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
    
    public func writeToDBChargeTypes(id : Int , title : String , imagePath : String ) {
        do {
            let realms = try! Realm()
            try realms.write({
                let TblChargeTypes = tblChargeTypes()
                TblChargeTypes.id = id
                print(TblChargeTypes.id)
                print(id)
                TblChargeTypes.title = title
                TblChargeTypes.image_path = imagePath
                realms.add(TblChargeTypes, update: false)
                print(" variable stored.")
                print(self.tblChargeTypesArray.count)
            })
        }catch let error {
            print(error)
        }
    }
}
