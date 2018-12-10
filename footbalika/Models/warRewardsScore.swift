//
//  warRewardsScore.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/13/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class warRewardsScore {
    public struct Response : Decodable {
        let status : String?
        let response : getActiveWar.response?
    }
}
