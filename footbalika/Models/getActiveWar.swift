//
//  getActiveWar.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class getActiveWar {
    public struct Response : Decodable {
        let status : String?
        let response : response?
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
        let opp_clan_id : String?
        let opp_war_point : String?
        let opp_clan_title : String?
        let opp_clan_logo : String?
    }
    public struct members : Decodable {
        let name : String?
    }
}
