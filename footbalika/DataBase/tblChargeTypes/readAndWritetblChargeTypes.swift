//
//  readAndWritetblChargeTypes.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import RealmSwift

public class readAndWritetblChargeTypes {
    var realm : Realm!
    var tblChargeTypesArray : Results<tblChargeTypes> {
        get {
            realm = try! Realm()
            return realm.objects(tblChargeTypes.self)
        }
    }
    var WtblChargeTypes = WritetblChargeTypes()
    public func writeToDBtblChargeTypes(chargeTypesID : Int ,chargeTypesTitle : String ,chargeTypesImagePath : String , base64 : String) {
        DispatchQueue.main.async {
            if self.tblChargeTypesArray.count != 0 {
                
                let realmID = self.realm.objects(tblChargeTypes.self).filter("id == \(chargeTypesID)")
                
                if realmID.first?.id != nil {
                    if realmID.first?.id == chargeTypesID && (realmID.first?.title)! == chargeTypesTitle && (realmID.first?.img_logo)! == chargeTypesImagePath {

                    } else {
                        self.WtblChargeTypes.writeToDBChargeTypes(id: chargeTypesID, title: chargeTypesTitle, imagePath: chargeTypesImagePath, base64: base64)
                    }
                } else {
                    self.WtblChargeTypes.writeToDBChargeTypes(id: chargeTypesID, title: chargeTypesTitle, imagePath: chargeTypesImagePath, base64: base64)
                }
                
            } else {
                self.WtblChargeTypes.writeToDBChargeTypes(id: chargeTypesID, title: chargeTypesTitle, imagePath: chargeTypesImagePath, base64: base64)
            }
        }
    }
}
