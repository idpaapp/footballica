//
//  readAndWritetblStadiums.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import RealmSwift

public class readAndWritetblStadiums {
    var realm : Realm!
    var tblStadiumsArray : Results<tblStadiums> {
        get {
            realm = try! Realm()
            return realm.objects(tblStadiums.self)
        }
    }
    var WtblStadiums = WritetblStadiums()
    public func writeToDBtblStadiumTypes(id : Int ,title : String ,imagePath : String , extendedBase64Image : String ) {
        
        DispatchQueue.main.async {
            if self.tblStadiumsArray.count != 0 {
                
                let realmID = self.realm.objects(tblStadiums.self).filter("id == \(id)")
                
                if realmID.first?.id != nil {
                    if realmID.first?.id == id && (realmID.first?.title)! == title && (realmID.first?.img_logo)! == imagePath &&  (realmID.first?.img_base64)! == extendedBase64Image{
                        
                    } else {
                        self.WtblStadiums.writeToDBStadiums(id: id, title: title, imagePath: imagePath, extendedbase64_image : extendedBase64Image)
                    }
                } else {
                    self.WtblStadiums.writeToDBStadiums(id: id, title: title, imagePath: imagePath, extendedbase64_image: extendedBase64Image)
                }
            } else {
                self.WtblStadiums.writeToDBStadiums(id: id, title: title, imagePath: imagePath, extendedbase64_image: extendedBase64Image)
            }
        }
    }
}
