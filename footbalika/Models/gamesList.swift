//
//  gamesList.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/31/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class gamesList {
    
    public struct Response : Decodable {
        let status : String?
        var response : [response]
    }
    
    struct response : Decodable {
        let id : String?
        let player1_id : String?
        let player2_id : String?
        let player1_result : String?
        let player2_result : String?
        let next_play_time : String?
        let game_start : String?
        let status : String?
        let game_type : String?
        let p_game_start : String?
        let player1_username : String?
        let player1_cup : String?
        let player1_level : String?
        let player1_avatar : String?
        let player2_username : String?
        let player2_cup : String?
        let player2_level : String?
        let player2_avatar : String?
        let turn : String?
        let is_home : String?
        let status_result : String?
    }
}

