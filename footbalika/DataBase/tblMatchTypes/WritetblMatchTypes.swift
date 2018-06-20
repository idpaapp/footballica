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
    
    public func writeToDB(gameTypesID : Int , gameTypesTitle : String , gameTypesImg_logo : String ) {
        do {
            let realms = try! Realm()
            try realms.write({
                let TblMatchTypes = tblMatchTypes()
                TblMatchTypes.id = gameTypesID
                print(TblMatchTypes.id)
                print(gameTypesID)
                TblMatchTypes.title = gameTypesTitle
                TblMatchTypes.img_logo = gameTypesImg_logo
                realms.add(TblMatchTypes, update: false)
                print(" variable stored.")
                print(self.tblMatchTypesArray.count)
            })
        }catch let error {
            print(error)
        }
    }
}
