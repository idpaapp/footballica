//
//  readAndWritetblMatchTypes.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/28/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import RealmSwift

public class readAndWritetblMatchTypes {
    var realm : Realm!
    var tblMatchTypesArray : Results<tblMatchTypes> {
        get {
            realm = try! Realm()
            return realm.objects(tblMatchTypes.self)
        }
    }
    var WblMatchTypes = WritetblMatchTypes()
    public func writeToDBtblMatchTypes(gameTypesID : Int ,gameTypesTitle : String ,gameTypesImg_logo : String ) {
        
        DispatchQueue.main.async {
            if self.tblMatchTypesArray.count != 0 {

                let realmID = self.realm.objects(tblMatchTypes.self).filter("id == \(gameTypesID)")
                
                if realmID.first?.id != nil {
                if realmID.first?.id == gameTypesID && (realmID.first?.title)! == gameTypesTitle && (realmID.first?.img_logo)! == gameTypesImg_logo {
                    
                } else {
                    self.WblMatchTypes.writeToDB(gameTypesID: gameTypesID, gameTypesTitle: gameTypesTitle, gameTypesImg_logo: gameTypesImg_logo)
                    }
                } else {
                    self.WblMatchTypes.writeToDB(gameTypesID: gameTypesID, gameTypesTitle: gameTypesTitle, gameTypesImg_logo: gameTypesImg_logo)
                }
                
            } else {
                self.WblMatchTypes.writeToDB(gameTypesID: gameTypesID, gameTypesTitle: gameTypesTitle, gameTypesImg_logo: gameTypesImg_logo)
            }
        }
    }
}
