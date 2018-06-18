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
    
    public func writeToDBtblMatchTypes(gameTypesID : Int ,gameTypesTitle : String ,gameTypesImg_logo : String ) {
        var lastIDArray = [Int]()
        
        DispatchQueue.main.async {
            if self.tblMatchTypesArray.count != 0 {
                
                
                ////shouldDelete/////////////////////////////
                for i in 0...self.tblMatchTypesArray.count - 1 {
                    let item = self.tblMatchTypesArray[i]
                    lastIDArray.append(item.id)
                }
                ///////////////////////////////////////////////
                
                
                
                
                /////////////////////where close/////////////////////////
                
                
                let realm = try! Realm()
                let item = self.tblMatchTypesArray
//                let l = realm.objects(tblMatchTypes.self).filter{ $0.id > 2 }
//                let l = realm.objects(tblMatchTypes.self).filter("id > 1")
                let l = realm.objects(tblMatchTypes.self).filter("id > 5")
                
                let bob = realm.objects(tblMatchTypes.self).filter("id > 0").first!
                
                print("bob\(bob)")
                print("l\(l)")
                print("puppies\(lastIDArray)")
                
//                let dogOwners = realm.objects(tblMatchTypes.self)
//                let ownersByDogAge = dogOwners.sorted(byKeyPath: "tblMatchTypes.id")
//
//                print("id\(ownersByDogAge)")
                //////////////////////////////////
                
                
                if lastIDArray.contains(gameTypesID) {
                    print(lastIDArray)
                } else {
                    writeToDB()
                }
                //                    print(self.existingIDs)
                //                    print(self.existingTitles)
                //                    print(self.gameTypesID)
                
            } else {
                writeToDB()
            }
        }
        
        func writeToDB() {
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
}
