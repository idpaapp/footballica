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
        let onLineTime : Float?
        let androidForceUpdateVersion : Int?
        let androidForceUpdateVersionBazaar : Int?
        let androidForceUpdateVersionMyket : Int?
        let androidForceUpdateVersionIranApps : Int?
        let androidForceUpdateVersionSibApp : Int?
        let androidLastVersionVersionAndroid : Int?
        let androidForceUpdateVersionIOS : Int?
        let server_update : Int?
        let hasPrediction : Int?
        let giftRewards : giftRewards.response?
        let showTaplighVideo : Int?
        let showTaplighOnGiftList : Int?
        let showTaplighOnExtraGame : Int?
        let warQuestionTime : Int?
        let warBombCount : Int?
        let warFreezeCount : Int?
        let showSupportReward : Int?
        let clan_create_price : Int?
        let clan_create_price_type : Int?
        let join_war_price : Int?
        let join_war_price_type : Int?
    }
    public var res : Response? = nil;
}
