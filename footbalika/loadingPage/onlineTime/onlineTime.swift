//
//  onlineTime.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/26/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class onlineTime {
    var timer : Timer!
    public func OnlineTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(loopTime), userInfo: nil, repeats: true)
    }
    @objc func loopTime() {
        matchViewController.OnlineTime = matchViewController.OnlineTime + 1000
    }
}
