//
//  loadGameData.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class gameDataModel {
    public struct Response : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        let gameTypes : [gameTypes.response]
        let gameRewards : [gameRewards.response]
        let gameLeagues : [gameLeagues.response]
        let gameCharge : [gameCharge.response]
        let stadiumData : [stadiumData.response]
        let userXps : [userXps.response]
        let onLineTime : Int?
        let androidForceUpdateVersion : Int?
        let server_update : Int?
        let hasPrediction : Int?
        let giftRewards : giftRewards.response?
    }
    public var res : Response? = nil;
}
