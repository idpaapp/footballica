//
//  gameRewards.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class gameRewards {
    public struct GameRewards : Decodable {
        let status : String?
        let response : response?
    }
public struct response : Decodable {
    let id : String?
    let title : String?
    let key_word : String?
    let descrip : String?
    let coin : String?
    let money : String?
    let xp : String?
    let cup : String?
    let order_pos : String?
}

}
