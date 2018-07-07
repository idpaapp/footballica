//
//  matchTypesDownload.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/16/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class matchTypesDownload {
    public struct matchTypes : Decodable {
        let id : String?
        let image_base64 : String?
        let image_path : String?
    }
}
