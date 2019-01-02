//
//  clanGroupsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/25/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

protocol clanDetailsViewControllerDelegate {
    func newInformation(minMember : Int , maxMember : Int , minCup : Int , groupType : Int)
}

protocol sendChatViewControllerDelegate : NSObjectProtocol {
    func sendChat(chatString : String)
    func updateChatView(constraint : CGFloat)
}


protocol createClanGroupViewControllerDelegate {
    func enterCreatedGroup()
}

class clanGroupsViewController: UIViewController , UITextFieldDelegate , clanDetailsViewControllerDelegate , UITableViewDelegate , UITableViewDataSource , sendChatViewControllerDelegate , createClanGroupViewControllerDelegate {
    
    var realm : Realm!
    
    @objc func enterCreatedGroup() {
        login().loging(userid : "\(matchViewController.userid)", rest: false, completionHandler: {
            DispatchQueue.main.async {
                self.clanID = "\((login.res?.response?.calnData?.clanid!)!)"
                self.getChatroomData(isChatSend: false, completionHandler: {})
                self.ChangeclanState()
            }
        })
    }
    
    @IBAction func selectGroup(_ sender: RoundButton) {
        if login.res?.response?.calnData?.clanid != nil {
            self.delegate?.showGroupInfo(id : "\(self.clanID)")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var delegate : clanGroupsViewControllerDelegate!
    var isSendingChat = false
    func sendChat(chatString : String) {
        self.isSendingChat = true
        let vc = self.childViewControllers.last as! sendChatViewController
        vc.chatTextView.endEditing(true)
        if chatString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'INSERT_CHATS' , 'user_id' : '\(matchViewController.userid)', 'clan_id' : '\(self.clanID)' , 'chat_text' : '\(chatString.trimmingCharacters(in: .whitespacesAndNewlines))' , 'item_type' : '1' }") { data, error in
                
                self.isSendingChat = false
                if data != nil {
                    
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                print(data ?? "")
                    
                    
                    let res = String(data: data!, encoding: String.Encoding.utf8) ?? ""
                    if res.contains("OK") {
                        DispatchQueue.main.async {
                           
                            self.getChatroomData(isChatSend: true, completionHandler: {})
                        }
                    }
                    
                    DispatchQueue.main.async {
                        PubProc.wb.hideWaiting()
                        
                    }
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                            self.sendChat(chatString: chatString)
                        })
                    }
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
    
    
    @objc func selectedClan(getChats : Bool) {
        self.bottomChatHeight.constant = 10
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
        self.chatViewHeight.constant = 60
        self.chatView.isHidden = false
        self.topClanView.isHidden = false
        if login.res?.response?.calnData?.clanid != nil {
            self.clanID = "\((login.res?.response?.calnData?.clanid!)!)"
            if getChats {
                DispatchQueue.main.async {
                    self.getChatroomData(isChatSend: false, completionHandler: {})
                    self.delegate?.clanJoinded()
                    self.clansTV.reloadData()
                }
            }
            self.clanImage.setImageWithKingFisher(url: "\(urlClass.clan)\((login.res?.response?.calnData?.caln_logo!)!)")
            self.clanTitle.text = "\((login.res?.response?.calnData?.clan_title!)!)"
            self.clanCup.text = "\((login.res?.response?.calnData?.clan_point!)!)"
        }
    }
    
    var urlClass = urls()
    func ChangeclanState() {
        if login.res?.response?.calnData?.clanMembers?.count != 0 {
            self.selectedClan(getChats: true)
        } else {
            self.bottomChatHeight.constant = 0
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
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
        
        if login.res?.response?.calnData?.clanMembers?.count != 0 {
            switch ((self.chatRes?.response?[indexPath.row].item_type!)!) {
            case publicConstants().CHAT :
                if ((self.chatRes?.response?[indexPath.row].user_id!)!) == matchViewController.userid {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "currentUserCell", for: indexPath) as! currentUserCell
                    
                    //                    let url = "\(urlClass.avatar)\((login.res?.response?.mainInfo?.avatar!)!)"
                    let url = "\(urlClass.avatar)\((self.chatRes?.response?[indexPath.row].avatar!)!)"
                    
                    let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
                    if realmID.count != 0 {
                        let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                        cell.currentUserButton.setImage(UIImage(data: dataDecoded as Data), for: .normal)
                    } else {
                        cell.currentUserButton.setImageWithKingFisher(url: url)
                    }
                    
                    let date = "\((self.chatRes?.response?[indexPath.row].p_due_date!)!)"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\((self.chatRes?.response?[indexPath.row].username!)!)\n\((self.chatRes?.response?[indexPath.row].chat_text!)!)\n")
                    attributedString.setColorForText(textForAttribute: "\((self.chatRes?.response?[indexPath.row].username!)!)", withColor: publicColors().currentUserTitleChatColor)
                    attributedString.setColorForText(textForAttribute: "\((self.chatRes?.response?[indexPath.row].chat_text!)!)\n", withColor: UIColor.darkGray)
                    cell.senderTexts.attributedText = attributedString
                    cell.chatDate.text = date
                    cell.currentUserButton.tag = indexPath.row
                    cell.currentUserButton.addTarget(self, action: #selector(openUserProfile), for: UIControlEvents.touchUpInside)
                    return cell
                } else {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "chatOtherUsersCell", for: indexPath) as! chatOtherUsersCell
                    
                    let url = "\(urlClass.avatar)\((self.chatRes?.response?[indexPath.row].avatar!)!)"
                    
                    let realmID = self.realm.objects(tblShop.self).filter("image_path == '\(url)'")
                    if realmID.count != 0 {
                        let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                        cell.otherUserButton.setImage(UIImage(data: dataDecoded as Data), for: .normal)
                    } else {
                        cell.otherUserButton.setImageWithKingFisher(url: url)
                    }
                    let date = "\((self.chatRes?.response?[indexPath.row].p_due_date!)!)"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\((self.chatRes?.response?[indexPath.row].username!)!)\n\((self.chatRes?.response?[indexPath.row].chat_text!)!)\n")
                    attributedString.setColorForText(textForAttribute: "\((self.chatRes?.response?[indexPath.row].username!)!)", withColor: publicColors().otherUserTitleChatColor)
                    attributedString.setColorForText(textForAttribute: "\((self.chatRes?.response?[indexPath.row].chat_text!)!)\n", withColor: UIColor.darkGray)
                    cell.otherChatTexts.attributedText = attributedString
                    cell.chatDate.text = date
                    cell.otherUserButton.tag = indexPath.row
                    cell.otherUserButton.addTarget(self, action: #selector(openUserProfile), for: UIControlEvents.touchUpInside)
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
                cell.topNewsView.backgroundColor = publicColors().startGroupGameColor
                cell.topNewsTitle.text = "شروع بازی گروهی"
                cell.topNewsTime.text = (self.chatRes?.response?[indexPath.row].p_due_date!)!
                cell.topNewsClanCup.text = (self.chatRes?.response?[indexPath.row].chat_text!)!
                print((self.chatRes?.response?[indexPath.row].chat_text!)!)
                cell.topNewsCupImage.isHidden = true
                return cell
                
            case publicConstants().WAR_RESULT :
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "hotNewsCell", for: indexPath) as! hotNewsCell
                cell.hotNewsView.backgroundColor = publicColors().endGroupGameColor
                cell.hotNewsTitle.text = "پایان بازی گروهی"
                cell.hotNewsDate.text = (self.chatRes?.response?[indexPath.row].p_due_date!)!
                cell.hotClanCupImage.isHidden = false
                cell.hotNewsClanCup.text = (self.chatRes?.response?[indexPath.row].chat_text!)!
                return cell
            case publicConstants().WAR_CANCELED :
                let cell = tableView.dequeueReusableCell(withIdentifier: "hotNewsCell", for: indexPath) as! hotNewsCell
                cell.hotNewsView.backgroundColor = publicColors().cancelGroupGameColor
                cell.hotNewsTitle.text = "لغو بازی گروهی"
                cell.hotNewsDate.text = (self.chatRes?.response?[indexPath.row].p_due_date!)!
                cell.hotClanCupImage.isHidden = true
                cell.hotNewsClanCup.text = "ورودیه به شما عودت داده شد"
                
                return cell
            default :
                let cell = tableView.dequeueReusableCell(withIdentifier: "chatNewsCell", for: indexPath) as! chatNewsCell
                cell.newsBackGround.backgroundColor = publicColors().goodNewsColor
                return cell
            }
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "clanGroupsCell", for: indexPath) as! clanGroupsCell
            
            cell.clanImage.setImageWithKingFisher(url: "\(urlClass.clan)\(((self.res?.response?[indexPath.row].caln_logo!)!))")
            cell.clanCup.text = ((self.res?.response?[indexPath.row].clan_score!)!)
            cell.clanName.text = ((self.res?.response?[indexPath.row].title!)!)
            cell.clanMembers.text = "\(((self.res?.response?[indexPath.row].member_count!)!)) / 11"
            
            return cell
            
        }
    }
    
    @objc func openUserProfile(_ sender : UIButton!) {
        self.delegate?.showProfile(id : "\((self.chatRes?.response?[sender.tag].user_id!)!)", isGroupDetailUser: false , completionHandler: {})
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if login.res?.response?.calnData?.clanid != nil {
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
                if  UIScreen.main.bounds.height <= 568 {
                    return 110
                } else {
                    return 126
                }
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
        if login.res?.response?.calnData?.clanMembers?.count != 0 {
            switch ((self.chatRes?.response?[indexPath.row].item_type!)!) {
            case publicConstants().CHAT :
                break
            case publicConstants().JOIN :
                self.delegate?.showProfile(id : "\((self.chatRes?.response?[indexPath.row].user_id!)!)", isGroupDetailUser: false, completionHandler: {})
                break
            case publicConstants().LEFT :
                self.delegate?.showProfile(id : "\((self.chatRes?.response?[indexPath.row].user_id!)!)", isGroupDetailUser: false, completionHandler: {})
                break
            case publicConstants().PROMOTE :
                self.delegate?.showProfile(id : "\((self.chatRes?.response?[indexPath.row].user_id!)!)", isGroupDetailUser: false, completionHandler: {})
                break
            case publicConstants().DEMOTE :
                self.delegate?.showProfile(id : "\((self.chatRes?.response?[indexPath.row].user_id!)!)", isGroupDetailUser: false, completionHandler: {})
                break
            case publicConstants().CLAN_WAR :
                break
            case publicConstants().WAR_RESULT :
                self.delegate?.showFinishedWarResault(id : "\((self.chatRes?.response?[indexPath.row].ref_id!)!)")
            case publicConstants().WAR_CANCELED :
                break
            default:
                break
            }
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
        self.searchButtonTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "جستجو", strokeWidth: 8.0)
        self.searchButtonTitleForeGround.font = fonts().iPhonefonts
        self.searchButtonTitleForeGround.text = "جستجو"
        self.searchButton.addTarget(self, action: #selector(searchingAction), for: UIControlEvents.touchUpInside)
    }
    
    
    override func viewDidLayoutSubviews() {
        self.topClanView.round(corners: [.topLeft , .topRight], radius: 10)
    }
    
    @objc func showDetails() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.showHideDetailsConstraint.constant = 190
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.5) {
                self.clanDetailsView.alpha = 1.0
            }
        }
    }
    
    @objc func hideDetails() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.showHideDetailsConstraint.constant = 10
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.3) {
                self.clanDetailsView.alpha = 0.0
            }
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
        
        //        if self.searchTitle.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        //            self.searchTitle = ""
        //            self.res = nil
        //            self.clansTV.reloadData()
        //        } else {
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'SEARCH_CLAN' , 'clan_ref' : '\(self.searchTitle.replacedArabicDigitsWithEnglish)' , 'require_trophy' : '\(self.minCupCount)' , 'clan_type' : '\(self.groupType)' , 'min_member_count' : '\(self.minMemberCount)' , 'max_member_count' : '\(self.maxMemberCount)' }") { data, error in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                do {
                    
                    self.res = try JSONDecoder().decode(clanGrouops.Response.self , from : data!)
                    
                    if (self.res?.response?.count)! != 0 {
                        self.isShowDetails = false
                        self.hideDetails()
                    }
                    
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
                PubProc.countRetry = 0
            } else {
                PubProc.countRetry = PubProc.countRetry + 1
                if PubProc.countRetry == 10 {
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self.searchingAction()
                    })
                }
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
        //        }
    }
    
    @objc func clearTextFields() {
        self.searchTextField.text = ""
        self.searchTitle = ""
        handleTextFieldClearButton(isHidden: true)
    }
    
    @objc func handleTextFieldClearButton(isHidden : Bool) {
        self.clearTextField.isHidden = isHidden
    }
    
    @objc func refresh(_ sender: Any) {
        if login.res?.response?.calnData?.clanMembers?.count != 0 {
            DispatchQueue.main.async {
                self.getChatroomData(isChatSend: false, completionHandler: {
                    self.refreshControl.endRefreshing()
                })
            }
        } else {
            self.refreshControl.endRefreshing()
        }
    }
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        //        refreshControl.attributedTitle = NSAttributedString(string: "در حال به روز رسانی" , attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.clansTV.addSubview(refreshControl)
        
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
    
    @objc func updatePage() {
        if login.res?.response?.calnData?.clanid != nil {
            DispatchQueue.main.async {
                self.getChatroomData(isChatSend: false, completionHandler: {})
            }
        } else {
            DispatchQueue.main.async {
                self.clansTV.reloadData()
            }
        }
    }
    
    var chatRes : clanChatRoom.Response? = nil
    @objc func getChatroomData(isChatSend : Bool , completionHandler : @escaping () -> Void) {
        if !self.isSendingChat {
        PubProc.isSplash = true
        PubProc.HandleDataBase.readJson(wsName: "ws_handleClan", JSONStr: "{'mode' : 'READ_CLAN_CHATS' , 'clan_id' : '\(self.clanID)'}") { data, error in
            
            if data != nil {
                PubProc.isSplash = false
                DispatchQueue.main.async {
                    PubProc.cV.hideWarning()
                }
                
                //                print(data ?? "")
                
                do {
                    
                    self.chatRes = try JSONDecoder().decode(clanChatRoom.Response.self , from : data!)
                    
                    DispatchQueue.main.async {
                        completionHandler()
                        UIView.performWithoutAnimation {
                            self.clansTV.reloadData()
                        }
                        self.refreshControl.endRefreshing()
                        if self.chatRes?.response?.count != 0 {                           let indexPath = IndexPath(row: (self.chatRes?.response?.count)! - 1, section: 0)
                            if !self.shouldGetChats {
                            self.clansTV.scrollToRow(at: indexPath, at: .bottom, animated: false)
                            }
                            self.selectedClan(getChats: false)
                            if self.shouldGetChats {
                            } else {
                                self.chatTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.chatUpdate), userInfo: nil, repeats: true)
                                self.shouldGetChats = true
                            }
                        }
                        if isChatSend {
                            let vc = self.childViewControllers.last as! sendChatViewController
                            vc.clearChatTexs()
                        }
                        PubProc.wb.hideWaiting()
                    }
                } catch {
                    
                    self.getChatroomData(isChatSend: isChatSend, completionHandler: {})
                    print(error)
                }
                PubProc.countRetry = 0 
            } else {
                PubProc.countRetry = PubProc.countRetry + 1
                if PubProc.countRetry == 10 {
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self.getChatroomData(isChatSend: isChatSend, completionHandler: {})
                    })
                }
                print("Error Connection")
                print(error as Any)
                // handle error
            }
            }.resume()
        } else {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func chatUpdate() {
        if self.shouldGetChats {
            getChatroomData(isChatSend: false, completionHandler: {})
        }
    }
    
    func dontUpdate() {
        self.shouldGetChats = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if login.res?.response?.calnData?.clanMembers?.count != 0 {
            if self.chatRes != nil {
                DispatchQueue.main.async {
                    UIView.performWithoutAnimation {
                        self.clansTV.reloadData()
                        if self.chatRes?.response?.count != 0 {
                            let indexPath = IndexPath(row: (self.chatRes?.response?.count)! - 1, section: 0)
                            self.clansTV.scrollToRow(at: indexPath, at: .bottom, animated: false)
                        }
                    }
                }
            }
        }
    }
    
    
    var chatTimer: Timer!
    var shouldGetChats = false
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
            if self.shouldGetChats {
                chatTimer.invalidate()
                self.shouldGetChats = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
