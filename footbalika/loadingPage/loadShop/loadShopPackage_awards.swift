//
//  loadShopPackage_awards.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class loadShopPackage_awards {
    public struct Package_awards : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        let id : String?
        let main_id : String?
        let type : String?
        let main_type : String?
        let singel_buy : String?
        let title : String?
        let image_path : String?
        let extended_image : String?
        let extended_image_2 : String?
        let price : String?
        let price_type : String?
        let qty : String?
        let priority : String?
    }
}
