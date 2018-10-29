//
//  clanChatRoom.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class clanChatRoom {
    public struct Response : Decodable {
        let status : String?
        let response : [response]?
    }
    public struct response : Decodable {
        let id : String?
        let clan_id : String?
        let user_id : String?
        let chat_text : String?
        let due_date : String?
        let item_type : String?
        let ref_id : String?
        let avatar : String?
        let username : String?
        let pushe_id : String?
        let title : String?
        let p_due_date : String?
    }
}
