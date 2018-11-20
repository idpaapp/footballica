//
//  clanResultsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/28/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class clanResultsViewController: UIViewController {

    @IBOutlet weak var rightClan: clanRightResaultView!
    
    @IBOutlet weak var leftClan: clanLeftResaultView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc func groupsUpdate(clanImage : String , oppClanImage : String , clanName : String  , oppClanName : String, clanScore : String , oppClanScore : String) {
        leftClan.clanImage.setImageWithKingFisher(url: "\(urls().clan)\(clanImage)")
        rightClan.clanImage.setImageWithKingFisher(url: "\(urls().clan)\(oppClanImage)")
        leftClan.clanName.text = clanName
        rightClan.clanName.text = oppClanName
        leftClan.clanResault.text = clanScore
        rightClan.clanResault.text = oppClanScore
    }
}
