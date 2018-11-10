//
//  startWar.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class startWar {
    public struct Response : Decodable {
        let status : String?
        let response : response?
    }
    public struct members : Decodable {
       let id : String?
       let clan_id : String?
       let user_id : String?
       let clan_score : String?
       let member_roll : String?
    }
    public struct response : Decodable {
        let id : String?
        let clan_id : String?
        let members : [members]?
        let war_point : String?
        let opp_war_id : String?
        let start_time : String?
        let status : String?
        let next_bot_play : String?
    }
}
