//
//  loginnots_achv.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
public class loginnots_achv {
    public struct nots_achv : Decodable {
        let status : String?
        let response : response?
    }
    public struct response : Decodable {
        let all_nots : String?
        let ach_count : String?
        let not_count : String?
    }
}
