//
//  gameCharge.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class  gameCharge {
    public struct GameCharge : Decodable {
        let status : String?
        let response : response?
    }
    
    public struct response : Decodable {
        let id : String?
        let title : String?
        let image_path : String?
        let charge_type : String?
        let price_type : String?
        let price : String?
        let order_pos : String?
    }
    
}
