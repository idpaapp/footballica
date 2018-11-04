//
//  clanGroupsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/25/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

protocol clanDetailsViewControllerDelegate {
    func newInformation(minMember : Int , maxMember : Int , minCup : Int , groupType : Int)
}

protocol sendChatViewControllerDelegate {
    func sendChat(chatString : String)
    func updateChatView(constraint : CGFloat)
}


protocol createClanGroupViewControllerDelegate {
    func enterCreatedGroup()
}
class clanGroupsViewController: UIViewController , UITextFieldDelegate , clanDetailsViewControllerDelegate , UITableViewDelegate , UITableViewDataSource , sendChatViewControllerDelegate , createClanGroupViewControllerDelegate {
    
    
    @objc func enterCreatedGroup() {
        login().loging(userid : "\(loadingViewController.userid)", rest: false, completionHandler: {
            self.clanID = "\((login.res?.response?.calnData?.clanid!)!)"
            self.getChatroomData(isChatSend: false)
            self.ChangeclanState()

        })
    }
    
    @IBAction func selectGroup(_ sender: RoundButton) {
        self.delegate?.showGroupInfo(id : "\(self.clanID)")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var delegate : clanGroupsViewControllerDelegate!
    func sendChat(chatString : String) {
        let vc = self.childViewControllers.last as! sendChatViewController
        vc.chatTextView.endEditing(true)
        if chatString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'INSERT_CHATS' , 'user_id' : '\(loadingViewController.userid)', 'clan_id' : '\(self.clanID)' , 'chat_text' : '\(chatString.trimmingCharacters(in: .whitespacesAndNewlines))' , 'item_type' : '1' }") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                
                    let res = String(data: data!, encoding: String.Encoding.utf8) ?? ""
                    if res.contains("OK") {
                        DispatchQueue.main.async {
                            self.getChatroomData(isChatSend: true)
                        }
                    }
                
                    DispatchQueue.main.async {
                        PubProc.wb.hideWaiting()
                        
                    }
                
            } else {
                self.sendChat(chatString: chatString)
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
        }
    }
    
    func updateChatView(constraint : CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.chatViewHeight.constant = constraint
        }
    }
    
    
    @objc func selectedClan() {
        self.bottomChatHeight.constant = 10
        self.chatViewHeight.constant = 60
        self.chatView.isHidden = false
        self.topClanView.isHidden = false
        self.clanID = "\((login.res?.response?.calnData?.clanid!)!)"
        getChatroomData(isChatSend: false)
        let url = "\(urlClass.clan)\((login.res?.response?.calnData?.caln_logo!)!)"
        let urls = URL(string : url)
        let resource = ImageResource(downloadURL: urls!, cacheKey: url)
        self.clanImage.kf.setImage(with: resource ,options:[.transition(ImageTransition.fade(0.5))])
        self.clanTitle.text = "\((login.res?.response?.calnData?.clan_title!)!)"
        self.clanCup.text = "\((login.res?.response?.calnData?.clan_point!)!)"
        self.delegate?.clanJoinded()
        self.clansTV.reloadData()
    }
    
    
    var urlClass = urls()
    func ChangeclanState() {
        if login.res?.response?.calnData?.clanMembers?.count != 0 {
            self.selectedClan()
            } else {
                self.bottomChatHeight.constant = 0
                self.chatViewHeight.constant = 0
                self.chatView.isHidden = true
                self.topClanView.isHidden = true
                self.clansTV.reloadData()
            }
    }
    
    @IBOutlet weak var chatViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomChatHeight: NSLayoutConstraint!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if login.res?.response?.calnData?.clanMembers?.count != 0 {
            if self.chatRes != nil {
                return (self.chatRes?.response?.count)!
            } else {
                return 0
            }
        } else {
            if self.res != nil {
                return ((self.res?.response?.count)!)
            } else {
                return 0
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if login.res?.response?.calnData != nil {
            switch ((self.chatRes?.response?[indexPath.row].item_type!)!) {
            case publicConstants().CHAT :
                if ((self.chatRes?.response?[indexPath.row].user_id!)!) == loadingViewController.userid {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "currentUserCell", for: indexPath) as! currentUserCell
                    
                    let date = "\((self.chatRes?.response?[indexPath.row].p_due_date!)!)"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\((self.chatRes?.response?[indexPath.row].username!)!)\n\((self.chatRes?.response?[indexPath.row].chat_text!)!)\n")
                    attributedString.setColorForText(textForAttribute: "\((self.chatRes?.response?[indexPath.row].username!)!)", withColor: publicColors().currentUserTitleChatColor)
                    attributedString.setColorForText(textForAttribute: "\((self.chatRes?.response?[indexPath.row].chat_text!)!)\n", withColor: UIColor.darkGray)
                    cell.senderTexts.attributedText = attributedString
                    cell.chatDate.text = date
                    return cell
                } else {

                    let cell = tableView.dequeueReusableCell(withIdentifier: "chatOtherUsersCell", for: indexPath) as! chatOtherUsersCell

                    let date = "\((self.chatRes?.response?[indexPath.row].p_due_date!)!)"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\((self.chatRes?.response?[indexPath.row].username!)!)\n\((self.chatRes?.response?[indexPath.row].chat_text!)!)\n")
                    attributedString.setColorForText(textForAttribute: "\((self.chatRes?.response?[indexPath.row].username!)!)", withColor: publicColors().otherUserTitleChatColor)
                    attributedString.setColorForText(textForAttribute: "\((self.chatRes?.response?[indexPath.row].chat_text!)!)\n", withColor: UIColor.darkGray)
                    cell.otherChatTexts.attributedText = attributedString
                    cell.chatDate.text = date
                    return cell
                }
            case publicConstants().JOIN :
                let cell = tableView.dequeueReusableCell(withIdentifier: "chatNewsCell", for: indexPath) as! chatNewsCell
                
                cell.newsBackGround.backgroundColor = publicColors().goodNewsColor
                cell.newsLabel.text = (self.chatRes?.response?[indexPath.row].chat_text!)!
                return cell
            case publicConstants().LEFT :
                let cell = tableView.dequeueReusableCell(withIdentifier: "chatNewsCell", for: indexPath) as! chatNewsCell
                
                cell.newsBackGround.backgroundColor = publicColors().badNewsColor
                cell.newsLabel.text = (self.chatRes?.response?[indexPath.row].chat_text!)!
                return cell
            case publicConstants().PROMOTE :
                let cell = tableView.dequeueReusableCell(withIdentifier: "chatNewsCell", for: indexPath) as! chatNewsCell
                cell.newsBackGround.backgroundColor = publicColors().goodNewsColor
                cell.newsLabel.text = (self.chatRes?.response?[indexPath.row].chat_text!)!
                return cell
            case publicConstants().DEMOTE :
                let cell = tableView.dequeueReusableCell(withIdentifier: "chatNewsCell", for: indexPath) as! chatNewsCell
                cell.newsBackGround.backgroundColor = publicColors().badNewsColor
                cell.newsLabel.text = (self.chatRes?.response?[indexPath.row].chat_text!)!
                return cell
            case publicConstants().CLAN_WAR :
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "topNewsCell", for: indexPath) as! topNewsCell

                return cell

            case publicConstants().WAR_RESULT :
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "topNewsCell", for: indexPath) as! topNewsCell
                
                return cell
                
            case publicConstants().WAR_CANCELED :
                let cell = tableView.dequeueReusableCell(withIdentifier: "hotNewsCell", for: indexPath) as! hotNewsCell
                
                
                return cell
            default :
                let cell = tableView.dequeueReusableCell(withIdentifier: "chatNewsCell", for: indexPath) as! chatNewsCell
                
                return cell
            }
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "clanGroupsCell", for: indexPath) as! clanGroupsCell
            
            let url = "\(urlClass.clan)\(((self.res?.response?[indexPath.row].caln_logo!)!))"
            let urls = URL(string : url)
            let resource = ImageResource(downloadURL: urls!, cacheKey: url)
            cell.clanImage.kf.setImage(with: resource ,options:[.transition(ImageTransition.fade(0.5))])
            cell.clanCup.text = ((self.res?.response?[indexPath.row].clan_score!)!)
            cell.clanName.text = ((self.res?.response?[indexPath.row].title!)!)
            cell.clanMembers.text = "\(((self.res?.response?[indexPath.row].member_count!)!)) / 11"

            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if login.res?.response?.calnData != nil {
            switch ((self.chatRes?.response?[indexPath.row].item_type!)!) {
            case publicConstants().CHAT :
                return UITableViewAutomaticDimension
            case publicConstants().JOIN :
                return 45
            case publicConstants().LEFT :
                return 45
            case publicConstants().PROMOTE :
                return 45
            case publicConstants().DEMOTE :
                return 45
            case publicConstants().CLAN_WAR :
                return 126
            case publicConstants().WAR_RESULT :
                return 126
            case publicConstants().WAR_CANCELED :
                return 126
            default :
                return 45
            }
        } else {
            return 80
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if login.res?.response?.calnData != nil {
            
        } else {
        self.delegate?.showGroupInfo(id : (self.res?.response?[indexPath.row].id!)!)
        }
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
    @IBOutlet weak var createGroup: actionLargeButton!
    
    //top Clan View
    @IBOutlet weak var topClanView: UIView!
    @IBOutlet weak var clanImage: UIImageView!
    @IBOutlet weak var clanTitle: UILabel!
    @IBOutlet weak var clanCup: UILabel!
    @IBOutlet weak var chatView: UIView!
    
    var isShowDetails = false
    
    @objc func fieldsUI() {
        
        self.clearTextField.addTarget(self, action: #selector(clearTextFields), for: UIControlEvents.touchUpInside)
        self.searchTextField.addPadding(.right(5))
        self.searchTextField.addPadding(.left(35))
        handleTextFieldClearButton(isHidden: true)
        self.clanDetailsView.alpha = 0.0
        self.searchButtonTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "جستجو", strokeWidth: -5.0)
        self.searchButtonTitleForeGround.font = fonts().iPhonefonts
        self.searchButtonTitleForeGround.text = "جستجو"
        self.searchButton.addTarget(self, action: #selector(searchingAction), for: UIControlEvents.touchUpInside)
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
    
    
    var searchTitle = String()
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.searchTitle = self.searchTextField.text!
        if self.searchTextField.text! == "" {
            handleTextFieldClearButton(isHidden: true)
        } else {
            handleTextFieldClearButton(isHidden: false)
        }
    }
    
    
    
    var res : clanGrouops.Response? = nil
    @objc func searchingAction() {

        if self.searchTitle.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.searchTitle = ""
            self.res = nil
            self.clansTV.reloadData()
        } else {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'SEARCH_CLAN' , 'clan_ref' : '\(self.searchTitle)' , 'require_trophy' : '\(self.minCupCount)' , 'clan_type' : '\(self.groupType)' , 'min_member_count' : '\(self.minMemberCount)' , 'max_member_count' : '\(self.maxMemberCount)' }") { data, error in
        
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                do {
                    
                    self.res = try JSONDecoder().decode(clanGrouops.Response.self , from : data!)
                    
                    //                        print((self.resUser?.response?.count)!)
                    DispatchQueue.main.async {
                         self.clansTV.reloadData()
                        self.searchTextField.endEditing(true)
                        PubProc.wb.hideWaiting()
                    }
                    
                    
                } catch {
                    self.searchingAction()
                    print(error)
                }
            } else {
                self.searchingAction()
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
        }
    }
    
    @objc func clearTextFields() {
        self.searchTextField.text = ""
        self.searchTitle = ""
        handleTextFieldClearButton(isHidden: true)
    }
    
    @objc func handleTextFieldClearButton(isHidden : Bool) {
        self.clearTextField.isHidden = isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldsUI()
        ChangeclanState()
        self.clansTV.keyboardDismissMode = .onDrag
        self.searchTextField.addTarget(self, action: #selector(clanGroupsViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        self.openOrCloseDetails.addTarget(self , action : #selector(openOrCloseDetailsAction) , for : UIControlEvents.touchUpInside)

        self.searchTextField.delegate = self
        
        self.clansTV.register(UINib(nibName: "clanGroupsCell", bundle: nil), forCellReuseIdentifier: "clanGroupsCell")
        
        self.clansTV.register(UINib(nibName: "chatOtherUsersCell", bundle: nil), forCellReuseIdentifier: "chatOtherUsersCell")
        
        self.clansTV.register(UINib(nibName: "currentUserCell", bundle: nil), forCellReuseIdentifier: "currentUserCell")

        self.clansTV.register(UINib(nibName: "hotNewsCell", bundle: nil), forCellReuseIdentifier: "hotNewsCell")
        
        self.clansTV.register(UINib(nibName: "topNewsCell", bundle: nil), forCellReuseIdentifier: "topNewsCell")
        
        self.clansTV.register(UINib(nibName: "chatNewsCell", bundle: nil), forCellReuseIdentifier: "chatNewsCell")
        
        self.clanCup.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
        
        self.createGroup.setButtons(hideAction: false, hideAction1: true, hideAction2: true, hideAction3: true)
        self.createGroup.setTitles(actionTitle: "ایجاد گروه", action1Title: "", action2Title: "", action3Title: "")
        self.createGroup.actionButton.addTarget(self, action: #selector(creatingGroup), for: UIControlEvents.touchUpInside)
        
        
    }
    
    
    @objc func creatingGroup() {
        self.performSegue(withIdentifier: "createGroup", sender: self)
    }
    
    
    var minMemberCount = Int()
    var maxMemberCount = Int()
    var minCupCount = Int()
    var groupType = 3
    var clanID = String()
    func newInformation(minMember : Int , maxMember : Int , minCup : Int , groupType : Int) {
        
        self.minMemberCount = minMember
        self.maxMemberCount = maxMember
        self.minCupCount = minCup
        self.groupType = groupType
        
        print("minMember : \(minMember) , maxMember : \(maxMember) , minCup : \(minCup) , groupType : \(groupType)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? clanDetailsViewController {
            vc.delegate = self
        }
        if let vc = segue.destination as? sendChatViewController {
            vc.delegate = self
        }
        
        if let vc = segue.destination as? createClanGroupViewController {
            vc.state = "createGroup"
            vc.delegate = self
        }
    }
    
    
    var chatRes : clanChatRoom.Response? = nil
    @objc func getChatroomData(isChatSend : Bool) {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'READ_CLAN_CHATS' , 'clan_id' : '\(self.clanID)'}") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                do {
                    
                    self.chatRes = try JSONDecoder().decode(clanChatRoom.Response.self , from : data!)
                    DispatchQueue.main.async {
                        self.clansTV.reloadData()
                        if self.chatRes?.response?.count != 0 {                           let indexPath = IndexPath(row: (self.chatRes?.response?.count)! - 1, section: 0)
                            self.clansTV.scrollToRow(at: indexPath, at: .bottom, animated: false)
                        }
                        if isChatSend {
                            let vc = self.childViewControllers.last as! sendChatViewController
                            vc.clearChatTexs()
                        }
                        PubProc.wb.hideWaiting()
                    }
                } catch {
                    self.getChatroomData(isChatSend: isChatSend)
                    print(error)
                }
            } else {
                self.getChatroomData(isChatSend: isChatSend)
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
