//
//  noInternetViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/20/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class noInternetViewController: UIViewController {

    @IBOutlet weak var restartApplication: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        restartApplication.addTarget(self, action: #selector(restartingApp), for: UIControlEvents.touchDown)
    }
    
    @objc func restartingApp() {
        
    }

}
