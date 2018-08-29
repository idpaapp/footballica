//
//  passChangeRes.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 6/5/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class passChangeRes {
    
    public struct Response : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        let mainInfo : loginMainInfo.response?
        let favoriteteams : [favoriteteams]?
        let nots_achv : nots_achv?
    }
    
    public struct favoriteteams : Decodable {
        let id : String?
        let userid : String?
        let teamid : String?
        let team_name : String?
        let logo : String?
    }
    
    public struct nots_achv : Decodable {
        let all_nots : String?
        let ach_count : String?
        let not_count : String?
    }
}
