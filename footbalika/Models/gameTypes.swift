//
//  gameTypes.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class gameTypes {
    public struct gameTypes : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        let id : String?
        let title : String?
        let img_logo : String?
    }
}
