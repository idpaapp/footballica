//
//  userXps.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class  userXps {
    public struct UserXps : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        let id : String?
        let xp : String?
        let from_xp : String?
        let to_xp : String?
        let level : String?
    }
}
