//
//  createClanGroupViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/5/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

protocol logoViewControllerDelegate {
    func updateLogoImage(url : String)
}

class createClanGroupViewController: UIViewController , logoViewControllerDelegate {
    
    var groupName = String()
    var groupImageUrl = String()
    var desc = String()
    @objc func updateLogoImage(url : String) {
        self.groupImageUrl = url
        self.createView.groupImage.setImageWithKingFisher(url: url)
    }
    
    @IBOutlet weak var createView: createClanGroupView!
    @IBOutlet weak var createViewHeight: NSLayoutConstraint!
    @IBOutlet weak var createViewWidth: NSLayoutConstraint!    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var state = String()
    var minCup = Int()
    var requireCup = "مهم نیست"
    var urlClass = urls()
    var clanType = 1
    var delegate : createClanGroupViewControllerDelegate!
    var delegate2 : createClanGroupViewControllerDelegate2!
    var clanData : clanGroup.Response? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        createView.closePage.addTarget(self, action: #selector(closingPage), for: UIControlEvents.touchUpInside)
        setGroupPage()
        self.createView.groupImageSelectButton.action1.addTarget(self, action: #selector(showLogo), for: UIControlEvents.touchUpInside)
        self.createView.setMinMaxCup.setMax.addTarget(self, action: #selector(addMinCup), for: UIControlEvents.touchUpInside)
        self.createView.setMinMaxCup.setMin.addTarget(self, action: #selector(removeMinCup), for: UIControlEvents.touchUpInside)
        
        if state == "createGroup" {
        self.createView.setMinMaxCup.minMaxLabel.text = self.requireCup
        self.createView.groupImage.setImageWithKingFisher(url: "\(urlClass.clan)logo_01.png")
        self.createView.buyButton.buyAction.addTarget(self, action: #selector(CreatingGroup), for: UIControlEvents.touchUpInside)
            
        } else {
            self.createView.buyButton.buyAction.addTarget(self, action: #selector(editClan), for: UIControlEvents.touchUpInside)
            self.createView.groupNameTextField.text = "\((clanData?.response?.title!)!)"
            if (clanData?.response?.require_trophy!)! != "0" {
                self.createView.setMinMaxCup.minMaxLabel.text = "\((clanData?.response?.require_trophy!)!)"
            } else {
                self.createView.setMinMaxCup.minMaxLabel.text = "مهم نیست"
            }
            
            self.createView.groupImage.setImageWithKingFisher(url: "\(urlClass.clan)\((clanData?.response?.caln_logo!)!)")
            self.createView.groupTextView.text = "\((clanData?.response?.clan_status!)!)"
            self.desc = "\((clanData?.response?.clan_status!)!)"
            self.minCup = Int((clanData?.response?.require_trophy!)!)!
            if (clanData?.response?.clan_type!)! == "1" {
           
                self.clanType = 1
                self.createView.privateGroup.radioButton.setBackgroundImage(publicImages().radioButtonEmpty, for: UIControlState.normal)
                self.createView.publicGroup.radioButton.setBackgroundImage(publicImages().radioButtonFill, for: UIControlState.normal)
                
            } else {
                
               self.clanType = 2
                self.createView.privateGroup.radioButton.setBackgroundImage(publicImages().radioButtonFill, for: UIControlState.normal)
                self.createView.publicGroup.radioButton.setBackgroundImage(publicImages().radioButtonEmpty, for: UIControlState.normal)
            }
        }
        
        self.createView.privateGroup.radioButton.addTarget(self, action: #selector(selectPrivateGroup), for: UIControlEvents.touchUpInside)
        self.createView.publicGroup.radioButton.addTarget(self, action: #selector(selectPublicGroup), for: UIControlEvents.touchUpInside)

    }
    
    
    @objc func selectPublicGroup() {
        changeGroupType(state: "public")
        self.clanType = 1
    }
    
    
    @objc func selectPrivateGroup() {
        changeGroupType(state: "private")
        self.clanType = 2
    }
    
    @objc func changeGroupType(state : String) {
        if state == "public" {
            
            self.createView.privateGroup.radioButton.setBackgroundImage(publicImages().radioButtonEmpty, for: UIControlState.normal)
            self.createView.publicGroup.radioButton.setBackgroundImage(publicImages().radioButtonFill, for: UIControlState.normal)
        } else {
            
            self.createView.publicGroup.radioButton.setBackgroundImage(publicImages().radioButtonEmpty, for: UIControlState.normal)

            self.createView.privateGroup.radioButton.setBackgroundImage(publicImages().radioButtonFill, for: UIControlState.normal)

            
        }
    }
    
    @objc func editClan() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'EDIT_CLAN' , 'clan_logo' : '\(self.groupImageUrl.dropFirst(urls().clan.count))' , 'status' : '\(self.createView.groupTextView.text!)' , 'clan_type' : '\(self.clanType)' , 'require_trophy' : '\(self.minCup)' , 'user_id' : '\(loadingViewController.userid)' }") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                    
                    //                print(data ?? "")
                    
                    let Res = String(data: data!, encoding: String.Encoding.utf8) as String?
                    
                    print(Res ?? "")
                    
                    if ((Res)!).contains("NOT_ENOUGH_RESOURCE") {
                        self.alertBody = "شما امکان انجام این کار را ندارید!"
                        self.performSegue(withIdentifier: "createGroupAlert", sender: self)
                    } else if ((Res)!).contains("DATA_CHENGED") {
                        login().loging(userid : "\(loadingViewController.userid)", rest: false, completionHandler: {
                        self.delegate2?.updateClanData()
                        self.closingPage()
                        })
                    }
                    
                    PubProc.wb.hideWaiting()
                }
            } else {
                self.creatingGroup()
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
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
        self.desc = self.createView.groupTextView.text!
        self.groupName = groupName
        if groupName.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            print(groupName.trimmingCharacters(in: .whitespacesAndNewlines).count)
            if groupName.trimmingCharacters(in: .whitespacesAndNewlines).count > 20 {
                self.alertBody = "نام گروه باید کمتر از 20 کاراکتر باشد!"
                self.performSegue(withIdentifier: "createGroupAlert", sender: self)
            } else {
                print("createGroup")
                creatingGroup()
            }
        } else {
            self.alertBody = "لطفاً نام گروه را وارد کنید!"
            self.performSegue(withIdentifier: "createGroupAlert", sender: self)
        }
    }
    
    @objc func creatingGroup() {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'CREATE_CLAN' , 'title' : '\(self.groupName)', 'clan_logo' : '\(self.groupImageUrl.dropFirst(urls().clan.count))' , 'status' : '\(self.desc)' , 'clan_type' : '\(self.clanType)' , 'require_trophy' : '\(self.minCup)' , 'user_id' : '\(loadingViewController.userid)' }") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                    
                    //                print(data ?? "")
                    
                    let Res = String(data: data!, encoding: String.Encoding.utf8) as String?
                    
                    print(Res ?? "")
                    
                    if ((Res)!).contains("NOT_ENOUGH_RESOURCE") {
                        self.alertBody = "شما امکان انجام این کار را ندارید!"
                        self.performSegue(withIdentifier: "createGroupAlert", sender: self)
                    } else if ((Res)!).contains("CLAN_CREATED") {
                        self.delegate?.enterCreatedGroup()
                        self.closingPage()
                    }
                    
                    PubProc.wb.hideWaiting()
                }
            } else {
                self.creatingGroup()
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
        
    }
    
    var alertBody = String()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? menuAlertViewController {
            vc.alertTitle = "فوتبالیکا"
            vc.alertBody = self.alertBody
            vc.alertAcceptLabel = "تأیید"
        }
        if let vc = segue.destination as? logoViewController {
            vc.delegate = self
        }
    }
    
    @objc func showLogo() {
        self.performSegue(withIdentifier: "showLogoPage", sender: self)
    }
    
    func setGroupPage() {
        if state == "createGroup" {
            self.createView.buyButton.setPriceTitle(title: "\((loadingViewController.loadGameData?.response?.clan_create_price!)!)", font: fonts().iPhonefonts)
            switch String((loadingViewController.loadGameData?.response?.clan_create_price_type!)!) {
            case publicConstants().coinCase :
                self.createView.buyButton.handleTitle(isFree: false)
                self.createView.buyButton.setPriceImage(priceImage: publicImages().coin!)
            case publicConstants().moneyCase :
                self.createView.buyButton.handleTitle(isFree: false)
                self.createView.buyButton.setPriceImage(priceImage: publicImages().money!)
            default :
                self.createView.buyButton.handleTitle(isFree: true)
                self.createView.buyButton.setPriceTitle(title: "رایگان", font: fonts().iPhonefonts)
            }
            
        } else {
            self.createView.groupNameTextField.isUserInteractionEnabled = false
            self.createView.groupNameTextField.backgroundColor = .clear
            self.createView.groupNameTextField.borderStyle = .none
            self.createView.buyButton.handleTitle(isFree: true)
            self.createView.buyButton.setPriceTitle(title: "تأیید", font: fonts().iPhonefonts)
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
