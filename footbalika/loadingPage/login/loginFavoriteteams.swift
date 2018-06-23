//
//  loginFavoriteteams.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

import Foundation
public class loginFavoriteteams {
    public struct favoriteteams : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        let id : String?
        let userid : String?
        let teamid : String?
        let team_name : String?
        let logo : String?
    }
}

