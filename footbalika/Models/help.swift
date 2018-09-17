//
//  help.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 6/25/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class help {
    public struct Response : Decodable {
        let status : String?
        let response : [response]?
    }
    
    public struct response : Decodable {
        let id : String?
        let desc_text : String?
        let key_title : String?
        let mode : String?
    }
    
}
