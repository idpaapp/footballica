//
//  warRewards.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class warRewards {
    public struct Response : Decodable {
        let status : String?
        let clan_data : clanGroup.response?
        let unclaimed_reward : unclaimed_reward?
    }
    
    public struct unclaimed_reward : Decodable {
        let id : String?
        let war_id : String?
        let user_id : String?
        let user_point : String?
        let user_time : String?
        let status : String?
        let questions : String?
        let reward : reward?
        let is_claimed : String?
    }
    public struct reward : Decodable {
       let gold : Int?
       let money : Int?
       let freeze : Int?
       let bomb : Int?
    }
}
