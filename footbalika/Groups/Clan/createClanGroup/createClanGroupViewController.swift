//
//  createClanGroupViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/5/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class createClanGroupViewController: UIViewController {

    @IBOutlet weak var createView: createClanGroupView!
    @IBOutlet weak var createViewHeight: NSLayoutConstraint!
    @IBOutlet weak var createViewWidth: NSLayoutConstraint!    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var state = String()
    var minCup = Int()
    var requireCup = "مهم نیست"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createView.closePage.addTarget(self, action: #selector(closingPage), for: UIControlEvents.touchUpInside)
        setGroupPage()
        self.createView.groupImageSelectButton.action1.addTarget(self, action: #selector(showLogo), for: UIControlEvents.touchUpInside)
        self.createView.buyButton.buyAction.addTarget(self, action: #selector(CreatingGroup), for: UIControlEvents.touchUpInside)
        self.createView.setMinMaxCup.setMax.addTarget(self, action: #selector(addMinCup), for: UIControlEvents.touchUpInside)
        self.createView.setMinMaxCup.setMin.addTarget(self, action: #selector(removeMinCup), for: UIControlEvents.touchUpInside)
        self.createView.setMinMaxCup.minMaxLabel.text = self.requireCup

    }
    
    @objc func removeMinCup() {
        self.minCup = self.minCup - 50
        if self.minCup < 50 {
            self.createView.setMinMaxCup.minMaxLabel.fadeTransition(0.4)
            self.createView.setMinMaxCup.minMaxLabel.text = "مهم نیست"
            self.minCup = 0
        } else {
            self.createView.setMinMaxCup.minMaxLabel.fadeTransition(0.4)
            self.createView.setMinMaxCup.minMaxLabel.text = "\(self.minCup)"
        }
    }
    
    @objc func addMinCup() {
        self.minCup = self.minCup + 50
        self.createView.setMinMaxCup.minMaxLabel.fadeTransition(0.4)
        self.createView.setMinMaxCup.minMaxLabel.text = "\(self.minCup)"
    }
    
    @objc func CreatingGroup() {
        let groupName = self.createView.groupNameTextField.text!
        if groupName.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            print(groupName.trimmingCharacters(in: .whitespacesAndNewlines).count)
            if groupName.trimmingCharacters(in: .whitespacesAndNewlines).count > 20 {
                self.alertBody = "نام گروه باید کمتر از 20 کاراکتر باشد!"
                self.performSegue(withIdentifier: "createGroupAlert", sender: self)
            } else {
                print("createGroup")
            }
        } else {
            self.alertBody = "لطفاً نام گروه را وارد کنید!"
            self.performSegue(withIdentifier: "createGroupAlert", sender: self)
        }
    }
    
    var alertBody = String()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? menuAlertViewController {
            vc.alertTitle = "فوتبالیکا"
            vc.alertBody = self.alertBody
            vc.alertAcceptLabel = "تأیید"
        }
    }
    
    @objc func showLogo() {
        self.performSegue(withIdentifier: "showLogoPage", sender: self)
    }
    
    func setGroupPage() {
        if state == "createGroup" {
        } else {
            self.createView.groupNameTextField.isUserInteractionEnabled = false
            self.createView.groupNameTextField.backgroundColor = .clear
            self.createView.groupNameTextField.borderStyle = .none
        }
    }
    
    @objc func closingPage() {
        openOrClose(state: "close")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        openOrClose(state: "open")
    }
    
    func openOrClose(state : String) {
        self.createView.closeOrOpenViewWithAnimation(State : state , time : 0.1, max: 1.1 , min : 0.7)
        if state != "open" {
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
