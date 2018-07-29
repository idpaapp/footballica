//
//  shopDownload.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class shopDownload {
    public struct shopItems : Decodable {
        let id : String?
        let image_base64 : String?
        let image_path : String?
    }
}
