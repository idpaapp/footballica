//
//  showTimerViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/28/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class showTimerViewController: UIViewController {

    @IBOutlet weak var timerTitle: UILabel!
    
    @IBOutlet weak var timerCountDown: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerTitle.text = "زمان باقی مانده"
    }
    
    @objc func updateTimer(time : String) {
        self.timerCountDown.text = time
    }

}
