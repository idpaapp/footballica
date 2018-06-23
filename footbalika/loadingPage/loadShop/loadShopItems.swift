//
//  loadShopItems.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class loadShopItems {
    public struct Items : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        let id : String?
        let title : String?
        let image : String?
        let type : String?
        let price : String?
        let price_type : String?
        let order_pos : String?
        let status : String?
        let package_awards : [loadShopPackage_awards.response]?
    }
}
