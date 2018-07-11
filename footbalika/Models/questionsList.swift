//
//  questionsList.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/20/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class questionsList {
    public struct Response : Decodable {
        var status : String?
        var response : [response]?
    }
    
    public struct response : Decodable {
        let id : String?
        let title : String?
        let ans_json : ans_json?
        let ans_correct_id : Int?
        let category : String?
        let level : String?
        let q_image : String?
    }
    
    public struct ans_json : Decodable {
        let ans_1 : String?
        let ans_2 : String?
        let ans_3 : String?
        let ans_4 : String?
    }
}
