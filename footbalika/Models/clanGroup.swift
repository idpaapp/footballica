//
//  clanGroup.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class clanGroup {
    public struct Response : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        let id : String?
        let title : String?
        let clan_status : String?
        let caln_logo : String?
        let clan_point : String?
        let clan_score : String?
        let require_trophy : String?
        let clan_tag : String?
        let member_count : String?
        let clan_type : String?
        let is_clan_bot : String?
        let last_clan_war : String?
        let clan_type_title : String?
        let clanMembers : [clanMembers]?
    }
    public struct clanMembers : Decodable {
        let id : String?
        let clan_id : String?
        let user_id : String?
        let clan_score : String?
        let member_roll : String?
        let pushe_id : String?
        let username : String?
        let badge_name : String?
        let cups : String?
        let avatar : String?
        let roll_title : String?
    }
}
