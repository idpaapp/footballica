//
//  giftRewards.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class  giftRewards {
    public struct GiftRewards : Decodable {
        let status : String?
        let response : response?
    }
    
    public struct response : Decodable {
       let instagram : Int?
       let video : Int?
       let video_install : Int?
       let invite_friend : Int?
       let sign_up : Int?
       let google_sign_in : Int?
       let report_bug : Int?
       let comment : Int?
       let invited_user : Int?
       let change_name : Int?
    }
}
