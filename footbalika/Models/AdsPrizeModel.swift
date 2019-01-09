//
//  AdsPrizeModel.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 10/18/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class AdsPrizeModel {
    public struct reward_data : Decodable {
       let id : String?
       let gold : String?
       let money : String?
    }
}
