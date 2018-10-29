//
//  clanGroups.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class clanGrouops {
    public struct Response : Decodable {
        let status : String?
        let response : [response]?
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
        let clan_type_title : String?
    }
}
