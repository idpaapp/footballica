//
//  groupMatchResaultViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/22/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class groupMatchResaultViewController: UIViewController {

    @IBOutlet weak var menuWindow: windows!
    
    var matchResaultres : getActiveWar.Response? = nil 
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.matchResaultres != nil {
        print(self.matchResaultres!)
        }
        self.menuWindow.closePage.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
    }
    

    @objc func dismissing() {
        self.dismiss(animated: true, completion: nil)
    }
}
