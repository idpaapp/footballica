//
//  shopDetailViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class shopDetailViewController: UIViewController {

    @IBOutlet weak var shopDetailHeight: NSLayoutConstraint!
    
    @IBOutlet weak var shopDetailWidth: NSLayoutConstraint!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissShopDetail(_ sender: RoundButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
