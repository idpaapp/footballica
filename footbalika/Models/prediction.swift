//
//  prediction.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class prediction {
    public struct Response : Decodable {
        let status : String?
        let response : [response]?
    }
    public struct response : Decodable {
        let id : String?
        let home_id : String?
        let home_name : String?
        let home_image : String?
        let home_result : String?
        let home_prediction : String?
        let away_id : String?
        let away_name : String?
        let away_image : String?
        let away_result : String?
        let away_prediction : String?
        let status : String?
        let game_time : String?
        let p_game_time : String?
    }
}
