//
//  friendList.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/11/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class friendList {
    public struct Response : Decodable {
        let status : String?
        let response : [response]?
    }
    public struct response : Decodable {
        let id : String?
        let user1_id : String?
        let user2_id : String?
        let friend_id : String?
        let username : String?
        let avatar : String?
        let badge_name : String?
        let league_id : String?
        let cups : String?
    }
}
