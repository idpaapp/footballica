//
//  clanGroupsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/25/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class clanGroupsViewController: UIViewController , UITextFieldDelegate {

    
    @IBOutlet weak var minimumMembersLabel: UILabel!
    @IBOutlet weak var maximumMembersLabel: UILabel!
    @IBOutlet weak var minimumCupLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearTextField: RoundButton!
    
    var minMember = Int()
    var maxMember = Int()
    var minCup = 0
    
    
    @objc func fieldsUI() {
        minimumMembersLabel.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
        maximumMembersLabel.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
        minimumCupLabel.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
        self.clearTextField.addTarget(self, action: #selector(clearTextFields), for: UIControlEvents.touchUpInside)
        self.searchTextField.addPadding(.right(5))
        self.searchTextField.addPadding(.left(35))
        self.clearTextField.isHidden = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
//        print(self.searchTextField.text!)
        if self.searchTextField.text! == "" {
            self.clearTextField.isHidden = true
        } else {
            self.clearTextField.isHidden = false
        }
    }
    
    @objc func clearTextFields() {
        self.searchTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldsUI()
        
        self.searchTextField.addTarget(self, action: #selector(clanGroupsViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)

        self.searchTextField.delegate = self

    }
    
    @IBAction func addMinMembers(_ sender: RoundButton) {
        self.minMember = self.minMember + 1
        if self.minMember > 12 {
            self.minMember = 12
        }
        self.minimumMembersLabel.fadeTransition(0.4)
        self.minimumMembersLabel.text = "\(self.minMember)"
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
    }
    
    @IBAction func addMaxMembers(_ sender: RoundButton) {
        self.maxMember = self.maxMember + 1
        if self.maxMember > 12 {
            self.maxMember = 12
        }
        self.maximumMembersLabel.fadeTransition(0.4)
        self.maximumMembersLabel.text = "\(self.maxMember)"
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
    }
    
    @IBAction func addMaxCup(_ sender: RoundButton) {
        self.minCup = self.minCup + 50
        self.minimumCupLabel.fadeTransition(0.4)
        self.minimumCupLabel.text = "\(self.minCup)"
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
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
