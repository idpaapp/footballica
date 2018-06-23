//
//  loadingAchievementsStructure.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class loadingAchievementsStructure {
    public struct Response : Decodable {
        let status : String?
        let response : [response]?
    }
    public struct response : Decodable {
        let id : String?
        let title : String?
        let img_logo : String?
        let describtion : String?
        let type_id : String?
        let coin_reward : String?
        let cash_reward : String?
        let level_gain_reward : String?
        let max_point : String?
        let pre_id : String?
        let detail_id : String?
        let progress : String?
        let is_claimed : String?
    }
}
