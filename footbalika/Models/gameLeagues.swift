//
//  gameLeagues.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
public class  gameLeagues {
    public struct GameLeagues : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        let id : String?
        let title : String?
        let img_logo : String?
        let min_cup : String?
        let max_cup : String?
    }
    
}
