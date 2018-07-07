//
//  WritetblStadiums.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import RealmSwift

public class WritetblStadiums {
    
    var realm : Realm!
    var tblStadiumsArray : Results<tblStadiums> {
        get {
            realm = try! Realm()
            return realm.objects(tblStadiums.self)
        }
    }
    
    public func writeToDBStadiums(id : Int , title : String , imagePath : String , extendedbase64_image : String ) {
        do {
            let realms = try! Realm()
            try realms.write({
                let TblStadiums = tblStadiums()
                TblStadiums.id = id
//                print(TblStadiums.id)
//                print(id)
                if title != "" {
                TblStadiums.title = title
                }
                TblStadiums.img_logo = imagePath
                if extendedbase64_image != "" {
                TblStadiums.img_base64 = extendedbase64_image
                }
                realms.add(TblStadiums, update: false)
//                print(" variable stored.")
//                print(self.tblStadiumsArray.count)
            })
        }catch let error {
            print(error)
        }
    }
}
