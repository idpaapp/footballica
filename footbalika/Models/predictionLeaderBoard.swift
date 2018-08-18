//
//  predictionLeaderBoard.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class predictionLeaderBoard {
    public struct Response : Decodable {
        let status : String?
        let user_pts : String?
        let response : [response]?
    }
    public struct response : Decodable {
        let id : String?
        let username : String?
        let avatar : String?
        let cups : String?
        let friend_id : String?
    }
}
