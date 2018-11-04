//
//  createGroupLogo.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class createGroupLogo {
    public struct Response : Decodable {
        let status : String?
        let response : [response]?
    }
    public struct response : Decodable {
        let id : String?
        let img_group : String?
    }
}
