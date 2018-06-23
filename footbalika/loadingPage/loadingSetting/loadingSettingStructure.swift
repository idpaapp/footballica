//
//  loadingSettingStructure.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class loadingSettingStructure {
    public struct Response : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        let id : String?
        let back_image : String?
        let main_sound : String?
        let splash_back : String?
        let force_version : String?
        let last_refresh_token : String?
        let freeze_price_type : String?
        let freeze_price : String?
        let bomb_price_type : String?
        let bomb_price : String?
    }
}
