//
//  groupMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/30/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class groupMatchViewController: UIViewController {

    @IBOutlet weak var bombCount: UILabel!
    
    @IBOutlet weak var freezeCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bombCount.text = "2"
        self.freezeCount.text = "2"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
