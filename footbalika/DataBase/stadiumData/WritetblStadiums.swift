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
    
    
    static var stadiumTypeImagesID = [Int]()
    static var stadiumTypeImagesPath = [String]()
    
    public func writeToDBStadiums(id : Int , title : String , imagePath : String , extendedbase64_image : String) {
//        print("stadium ID\(id)")
        do {
            let realms = try! Realm()
            try realms.write({
                if self.tblStadiumsArray.count != 0 {
                    
                    //                    print(self.realm.objects(tblMatchTypes.self).value(forKey: "id").debugDescription)
                    let realmID = self.realm.objects(tblStadiums.self).filter("id == \(id)")
                    //                    let counts = realm.objects(tblChargeTypes.self)
                    //                    print(counts.count)
                    //                    print("self.tblMatchTypesArray.count\(self.tblMatchTypesArray.count)")
                    if realmID.first?.id != nil {
                        if realmID.first?.img_base64 == "" && realmID.first?.img_base64 != extendedbase64_image {
                            DispatchQueue.main.async {
                                try! self.realm.write {
                                    realmID.first?.img_base64 = extendedbase64_image
                                }
                            }
                        }
                    } else {
                        let TblStadiumTypes = tblStadiums()
                        TblStadiumTypes.id = id
                        //                print(TblMatchTypes.id)
                        //                print(gameTypesID)
                        if title != "" {
                            TblStadiumTypes.title = title
                        }
                        TblStadiumTypes.img_logo = imagePath
                        if extendedbase64_image != "" {
                            TblStadiumTypes.img_base64 = extendedbase64_image
                        }
                        realms.add(TblStadiumTypes, update: false)
                        WritetblStadiums.stadiumTypeImagesID.append(TblStadiumTypes.id)
                    WritetblStadiums.stadiumTypeImagesPath.append(TblStadiumTypes.img_logo)
                        //                print("variable stored.")
                        //                print(self.tblMatchTypesArray.count)
                    }
                    
                } else {
                    let TblStadiumTypes = tblStadiums()
                    TblStadiumTypes.id = id
                    //                print(TblMatchTypes.id)
                    //                print(gameTypesID)
                    if title != "" {
                        TblStadiumTypes.title = title
                    }
                    TblStadiumTypes.img_logo = imagePath
                    if extendedbase64_image != "" {
                        TblStadiumTypes.img_base64 = extendedbase64_image
                    }
                    realms.add(TblStadiumTypes, update: false)
                    WritetblStadiums.stadiumTypeImagesID.append(TblStadiumTypes.id)
                    WritetblStadiums.stadiumTypeImagesPath.append(TblStadiumTypes.img_logo)
                    //                print("variable stored.")
                    //                print(self.tblMatchTypesArray.count)
                }
            })
        }catch let error {
            print(error)
        }
    }
    
    
//    public func writeToDBStadiums(id : Int , title : String , imagePath : String , extendedbase64_image : String ) {
//        do {
//            let realms = try! Realm()
//            try realms.write({
//                let TblStadiums = tblStadiums()
//                TblStadiums.id = id
////                print(TblStadiums.id)
////                print(id)
//                if title != "" {
//                TblStadiums.title = title
//                }
//                TblStadiums.img_logo = imagePath
//                if extendedbase64_image != "" {
//                TblStadiums.img_base64 = extendedbase64_image
//                }
//                realms.add(TblStadiums, update: false)
////                print(" variable stored.")
////                print(self.tblStadiumsArray.count)
//            })
//        }catch let error {
//            print(error)
//        }
//    }
}
