//
//  clanGroupsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/25/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

protocol clanDetailsViewControllerDelegate {
    func newInformation(minMember : Int , maxMember : Int , minCup : Int , groupType : Int)
}

class clanGroupsViewController: UIViewController , UITextFieldDelegate , clanDetailsViewControllerDelegate , UITableViewDelegate , UITableViewDataSource {
    
    func ChangeclanState(state : String) {
        print(state)
        if state == "group" {
            self.topClanView.isHidden = true
        } else {
            self.topClanView.isHidden = false
        }
    }
    
    var isSelectedClan = true
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSelectedClan {
            return 10
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSelectedClan {
            //other Users
//            let cell = tableView.dequeueReusableCell(withIdentifier: "chatOtherUsersCell", for: indexPath) as! chatOtherUsersCell
//
//            return cell
            
            //current User            
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentUserCell", for: indexPath) as! currentUserCell
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "clanGroupsCell", for: indexPath) as! clanGroupsCell

            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearTextField: RoundButton!
    @IBOutlet weak var openOrCloseDetails: RoundButton!
    @IBOutlet weak var showHideDetailsConstraint: NSLayoutConstraint!
    @IBOutlet weak var clansTV: UITableView!
    @IBOutlet weak var clanDetailsView: UIView!
    @IBOutlet weak var searchButton: RoundButton!
    @IBOutlet weak var searchButtonTitle: UILabel!
    @IBOutlet weak var searchButtonTitleForeGround: UILabel!
    @IBOutlet weak var createGroupButton: RoundButton!
    
    //top Clan View
    @IBOutlet weak var topClanView: UIView!
    @IBOutlet weak var clanImage: UIImageView!
    @IBOutlet weak var clanTitle: UILabel!
    @IBOutlet weak var clanCup: UILabel!
    
    
    var isShowDetails = false
    
    @objc func fieldsUI() {
        
        self.clearTextField.addTarget(self, action: #selector(clearTextFields), for: UIControlEvents.touchUpInside)
        self.searchTextField.addPadding(.right(5))
        self.searchTextField.addPadding(.left(35))
        self.clearTextField.isHidden = true
        self.clanDetailsView.alpha = 0.0
        self.searchButtonTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "جستجو", strokeWidth: -5.0)
        self.searchButtonTitleForeGround.font = fonts().iPhonefonts
        self.searchButtonTitleForeGround.text = "جستجو"
    }
    
    
    override func viewDidLayoutSubviews() {
         self.topClanView.round(corners: [.topLeft , .topRight], radius: 10)
    }
    
    @objc func showDetails() {
        UIView.animate(withDuration: 0.5) {
            self.showHideDetailsConstraint.constant = 190
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.5) {
            self.clanDetailsView.alpha = 1.0
        }
    }
    
    @objc func hideDetails() {
        UIView.animate(withDuration: 0.5) {
            self.showHideDetailsConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.3) {
            self.clanDetailsView.alpha = 0.0
        }
    }
    
    
    @objc func openOrCloseDetailsAction() {
        
        if self.isShowDetails {
            self.openOrCloseDetails.setImage(UIImage(named: "arrow_down"), for: UIControlState.normal)
            self.isShowDetails = false
            self.hideDetails()
        } else {
        self.openOrCloseDetails.setImage(UIImage(named: "arrow_up"), for: UIControlState.normal)
            self.isShowDetails = true
            self.showDetails()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print(self.searchTextField.text!)
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
        
        self.openOrCloseDetails.addTarget(self , action : #selector(openOrCloseDetailsAction) , for : UIControlEvents.touchUpInside)

        self.searchTextField.delegate = self
        
        self.clansTV.register(UINib(nibName: "clanGroupsCell", bundle: nil), forCellReuseIdentifier: "clanGroupsCell")
        
        self.clansTV.register(UINib(nibName: "chatOtherUsersCell", bundle: nil), forCellReuseIdentifier: "chatOtherUsersCell")
        
        self.clansTV.register(UINib(nibName: "currentUserCell", bundle: nil), forCellReuseIdentifier: "currentUserCell")

        clanCup.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)

    }
    
    func newInformation(minMember : Int , maxMember : Int , minCup : Int , groupType : Int) {
        print("minMember : \(minMember) , maxMember : \(maxMember) , minCup : \(minCup) , groupType : \(groupType)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? clanDetailsViewController {
            vc.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
