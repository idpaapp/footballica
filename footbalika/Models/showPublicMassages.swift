//
//  showPublicMassages.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class showPublicMassages {
    public struct Response : Decodable {
        let status : String?
        let response : [response]?
    }
    public struct response : Decodable {
        let id : String?
        let sender_id : String?
        let reciver_id : String?
        let type : String?
        let subject : String?
        let contents : String?
        let image_path : String?
        let option_field : String?
        let option_field_2 : String?
        let message_date : String?
        let status : String?
        let p_message_date : String?
        let username : String?
        let avatar : String?
    }
}
