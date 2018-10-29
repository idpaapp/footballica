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
    
    
    //Radio Buttons Outlets
    @IBOutlet weak var radioButtonsMainTitle: radioButtonView!
    @IBOutlet weak var radioButton1: radioButtonView!
    @IBOutlet weak var radioButton2: radioButtonView!
    @IBOutlet weak var radioButton3: radioButtonView!
    
    var minMember = Int()
    var maxMember = Int()
    var minCup = Int()
    var groupType = 3
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc func fieldsUI() {
        
        minimumMembersLabel.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
        maximumMembersLabel.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
        minimumCupLabel.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
    }
 
    @objc func setupRadioButtons() {
        self.radioButtonsMainTitle.radioButtonTitle.text = "نوع گروه :"
        self.radioButton1.radioButtonTitle.text = "عمومی"
        self.radioButton2.radioButtonTitle.text = "خصوصی"
        self.radioButton3.radioButtonTitle.text = "همه"
        self.radioButton1.radioButton.tag = 1
        self.radioButton2.radioButton.tag = 2
        self.radioButton3.radioButton.tag = 3
        self.radioButton1.radioButton.addTarget(self, action: #selector(updateradioButton), for: UIControlEvents.touchUpInside)
        self.radioButton2.radioButton.addTarget(self, action: #selector(updateradioButton), for: UIControlEvents.touchUpInside)
        self.radioButton3.radioButton.addTarget(self, action: #selector(updateradioButton), for: UIControlEvents.touchUpInside)
        self.radioButtonsMainTitle.radioButton.isHidden = true
        self.radioButton3.radioButton.setBackgroundImage(publicImages().radioButtonFill, for: .normal)
    }
    
    @objc func updateradioButton(_ sender : UIButton!) {
        emptyAllRadioButtons()
        switch sender.tag {
        case 1:
            self.radioButton1.radioButton.setBackgroundImage(publicImages().radioButtonFill, for: .normal)
            self.groupType = 1
            
        case 2:
            self.radioButton2.radioButton.setBackgroundImage(publicImages().radioButtonFill, for: .normal)
            self.groupType = 2
        case 3:
            self.radioButton3.radioButton.setBackgroundImage(publicImages().radioButtonFill, for: .normal)
            self.groupType = 3
        default:
            print("No Action")
        }
        
    }
    
    @objc func emptyAllRadioButtons() {
        self.radioButton1.radioButton.setBackgroundImage(publicImages().radioButtonEmpty, for: .normal)
        self.radioButton2.radioButton.setBackgroundImage(publicImages().radioButtonEmpty , for: .normal)
        self.radioButton3.radioButton.setBackgroundImage(publicImages().radioButtonEmpty, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldsUI()
        emptyAllRadioButtons()
        setupRadioButtons()
        
        
//        public var radioButtonFill = UIImage(named : "radioButtonFill")
//        public var radioButtonEmpty = UIImage(named : "radioButtonEmpty")
        
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
    
    @objc func setRadioButtons(FillButtonNumber : Int) {
        
    }

}
