//
//  tblChargeTypes.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//


import Foundation
import RealmSwift

class tblChargeTypes: Object {
    @objc dynamic var  id  = 0
    @objc dynamic var title = ""
    @objc dynamic var img_logo = ""
    @objc dynamic var img_base64 = ""
}
