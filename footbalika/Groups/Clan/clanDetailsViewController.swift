//
//  clanDetailsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/28/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class clanDetailsViewController: UIViewController {

    @IBOutlet weak var minimumMembersLabel: UILabel!
    @IBOutlet weak var maximumMembersLabel: UILabel!
    @IBOutlet weak var minimumCupLabel: UILabel!
    var delegate : clanDetailsViewControllerDelegate!
    
    var minMember = Int()
    var maxMember = Int()
    var minCup = Int()
    var groupType = Int()
    
    @objc func fieldsUI() {
        
        minimumMembersLabel.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
        maximumMembersLabel.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
        minimumCupLabel.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldsUI()
        
    }
    
    @IBAction func addMinMembers(_ sender: RoundButton) {
        self.minMember = self.minMember + 1
        if self.minMember > 12 {
            self.minMember = 12
        }
        self.minimumMembersLabel.fadeTransition(0.4)
        self.minimumMembersLabel.text = "\(self.minMember)"
        self.sendNewInformation()
    }
    
    @IBAction func removeMinMembers(_ sender: RoundButton) {
        self.minMember = self.minMember - 1
        if self.minMember <= 0 {
            self.minMember = 0
            self.minimumMembersLabel.fadeTransition(0.4)
            self.minimumMembersLabel.text = "مهم نیست"
        } else {
            self.minimumMembersLabel.fadeTransition(0.4)
            self.minimumMembersLabel.text = "\(self.minMember)"
        }
        self.sendNewInformation()
    }
    
    @IBAction func addMaxMembers(_ sender: RoundButton) {
        self.maxMember = self.maxMember + 1
        if self.maxMember > 12 {
            self.maxMember = 12
        }
        self.maximumMembersLabel.fadeTransition(0.4)
        self.maximumMembersLabel.text = "\(self.maxMember)"
        self.sendNewInformation()
    }
    
    @IBAction func removeMaxMembers(_ sender: RoundButton) {
        self.maxMember = self.maxMember - 1
        if self.maxMember <= 0 {
            self.maxMember = 0
            self.maximumMembersLabel.fadeTransition(0.4)
            self.maximumMembersLabel.text = "مهم نیست"
        } else {
            self.maximumMembersLabel.fadeTransition(0.4)
            self.maximumMembersLabel.text = "\(self.maxMember)"
        }
        self.sendNewInformation()
    }
    
    @IBAction func addMaxCup(_ sender: RoundButton) {
        self.minCup = self.minCup + 50
        self.minimumCupLabel.fadeTransition(0.4)
        self.minimumCupLabel.text = "\(self.minCup)"
        self.sendNewInformation()
    }
    
    @IBAction func removeMaxCup(_ sender: RoundButton) {
        self.minCup = self.minCup - 50
        if self.minCup < 50 {
            self.minimumCupLabel.fadeTransition(0.4)
            self.minimumCupLabel.text = "مهم نیست"
            self.minCup = 0
        } else {
            self.minimumCupLabel.fadeTransition(0.4)
            self.minimumCupLabel.text = "\(self.minCup)"
        }
        self.sendNewInformation()
    }
    
    
    @objc func sendNewInformation() {
        self.delegate?.newInformation(minMember : self.minMember , maxMember : self.maxMember , minCup : self.minCup , groupType : self.groupType)
    }

}
