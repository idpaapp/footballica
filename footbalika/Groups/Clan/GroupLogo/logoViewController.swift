//
//  logoViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/6/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class logoViewController: UIViewController {

    @IBOutlet weak var groupLogoView: groupLogoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.groupLogoView.closeButton.addTarget(self, action: #selector(closing), for: UIControlEvents.touchUpInside)
    }
    
    @objc func closing() {
        self.groupLogoView.closeOrOpenViewWithAnimation(State: "close", time: 0.1, max: 1.1 , min : 0.7)
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.groupLogoView.closeOrOpenViewWithAnimation(State: "open", time: 0.1, max: 1.1 , min : 0.7)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
