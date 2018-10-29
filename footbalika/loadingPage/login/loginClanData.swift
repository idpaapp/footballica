//
//  loginClanData.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/6/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class loginClanData {
    
    public struct gameTypes : Decodable {
            let status : String?
            let response : response?
    }
    
    public struct response : Decodable {
        let clanid : String?
        let clan_title : String?
        let caln_logo : String?
        let require_trophy : String?
        let clan_type : String?
        let clan_status : String?
        let clan_point : String?
        let clan_roll : String?
        let member_roll : String?
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
