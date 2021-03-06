//
//  loginStructure.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class loginStructure {
    public struct Response : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        var mainInfo : loginMainInfo.response?
        let favoriteteams : [loginFavoriteteams.response]?
        let reward_data : AdsPrizeModel.reward_data?
        let calnData : loginClanData.response?
        let nots_achv : loginnots_achv.response?
    }
    public var res : Response? = nil;
}
