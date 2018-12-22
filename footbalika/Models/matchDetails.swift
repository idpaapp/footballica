//
//  matchDetails.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class matchDetails {
    
    public struct Response : Decodable {
        let status : String?
        let response : response?
    }
    
    public struct  response : Decodable {
        let matchData : matchData?
        let detailData : [detailData]?
        let isYourTurn : Bool?
    }
    
    public struct matchData : Decodable {
        let id : String?
        let player1_id : String?
        let player2_id : String?
        let player1_result : String?
        let player2_result : String?
        let next_play_time : String?
        let game_start : String?
        let status : String?
        let game_type : String?
        let player1_username : String?
        let player1_level : String?
        let player1_avatar : String?
        let player2_username : String?
        let player2_level : String?
        let player2_avatar : String?
        let stadium : String?
    }
    
    public struct detailData : Decodable {
        let id : String?
        let game_type : String?
        let game_type_name : String?
        let player1_result : String?
        let player2_result : String?
        let player1_result_sheet : player1_result_sheet?
        let player2_result_sheet : player2_result_sheet?
        let last_questions : String?
    }
    
    public struct  player1_result_sheet : Decodable {
        let ans_1 : QuantumValue?
        let ans_2 : QuantumValue?
        let ans_3 : QuantumValue?
        let ans_4 : QuantumValue?
    }
    
    public struct  player2_result_sheet : Decodable {
        let ans_2 : QuantumValue?
        let ans_1 : QuantumValue?
        let ans_4 : QuantumValue?
        let ans_3 : QuantumValue?
    }
    
    enum QuantumValue: Decodable {
        
        case int(Int), string(String)
        
        init(from decoder: Decoder) throws {
            if let int = try? decoder.singleValueContainer().decode(Int.self) {
                self = .int(int)
                return
            }
            if let string = try? decoder.singleValueContainer().decode(String.self) {
                self = .string(string)
                return
            }
            throw QuantumError.missingValue
        }
        enum QuantumError:Error {
            case missingValue
        }
    }
}


