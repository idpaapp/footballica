//
//  showItemViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/8/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class showItemViewController: UIViewController {

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemTitleForeGround: UILabel!
    @IBOutlet weak var itemHeight: NSLayoutConstraint!
    @IBOutlet weak var itemWidth: NSLayoutConstraint!
    
    @IBOutlet weak var itemImage: UIImageView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemImage.image = UIImage(named: "avatar")
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissAcrion(_ sender: RoundButton) {
        dismissing()
    }
    
    @objc func dismissing() {
        dismiss(animated: true, completion: nil)
    }
}
