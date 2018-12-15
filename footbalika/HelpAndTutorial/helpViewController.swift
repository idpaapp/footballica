//
//  helpViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 6/25/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class helpViewController: UIViewController {

    @IBOutlet weak var helpBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var helpBoxWidth: NSLayoutConstraint!
    @IBOutlet weak var adelHeight: NSLayoutConstraint!
    @IBOutlet weak var adelWidth: NSLayoutConstraint!
    @IBOutlet weak var acceptHelpAction: RoundButton!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var acceptLabelForeGround: UILabel!
    @IBOutlet weak var helpDescription: UILabel!
    var desc = [String]()
    var acceptTitle = [String]()
    var currentSlide : Int = 0
    var state = String()
    var id = String()
    var delegate : TutorialDelegate?
    var tDelegate : TutorialsDelegate?
    var shopDelegate : ShopTutorialDelegate?
    var groupsDelegate : helpViewControllerDelegate2?
    var matchDelegate : helpViewControllerDelegate!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    static var helpRes : help.Response? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

       slideShowing()
       UIDesigning()
        acceptHelpAction.addTarget(self, action: #selector(nextOrDismiss), for: UIControlEvents.touchUpInside)
    }

    @objc func UIDesigning() {
        if UIDevice().userInterfaceIdiom == .phone {
        helpBoxWidth.constant = UIScreen.main.bounds.width - 20
        helpBoxHeight.constant = 3/4 * (UIScreen.main.bounds.width - 20)
        } else {
        helpBoxWidth.constant = 500
        helpBoxHeight.constant = 375
        }
    }
    
    func normalTutorialHelp() {
        let hID = ((helpViewController.helpRes?.response?.filter {$0.id == self.id})!)
        helpDescription.text = (hID.first?.desc_text!)!
        acceptLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\((hID.first?.key_title!)!)", strokeWidth: 8.0)
        acceptLabelForeGround.font = fonts().iPhonefonts
        acceptLabelForeGround.text = "\((hID.first?.key_title!)!)"
    }
    
    @objc func slideShowing() {
        if self.state == "START_GAME" {
            switch self.id {
            case "4" :
                normalTutorialHelp()
            case "7" :
                normalTutorialHelp()
            case "8" :
                normalTutorialHelp()
            case "9" :
                normalTutorialHelp()
            case "10" :
                normalTutorialHelp()
            default :
                let hID = ((helpViewController.helpRes?.response?.filter {$0.id == "5"})!)
                self.desc.append((hID.first?.desc_text!)!)
                self.acceptTitle.append((hID.first?.key_title!)!)
                let hID2 = ((helpViewController.helpRes?.response?.filter {$0.id == "6"})!)
                self.desc.append((hID2.first?.desc_text!)!)
                self.acceptTitle.append((hID2.first?.key_title!)!)
                self.showingHelp()
            }
            
        } else if self.state == "shopTutorial" {
            let hID = ((helpViewController.helpRes?.response?.filter {$0.id == "11"})!)
            self.desc.append((hID.first?.desc_text!)!)
            self.acceptTitle.append((hID.first?.key_title!)!)
            let hID2 = ((helpViewController.helpRes?.response?.filter {$0.id == "12"})!)
            self.desc.append((hID2.first?.desc_text!)!)
            self.acceptTitle.append((hID2.first?.key_title!)!)
            self.showingHelp()
            
        }  else if self.state == "goToGroups" {
            let hID = ((helpViewController.helpRes?.response?.filter {$0.id == "13"})!)
            self.desc.append((hID.first?.desc_text!)!)
            self.acceptTitle.append((hID.first?.key_title!)!)
            self.showingHelp()
            
        } else if self.state == "lastTutorialPage" {
            let hID = ((helpViewController.helpRes?.response?.filter {$0.id == "14"})!)
            self.desc.append((hID.first?.desc_text!)!)
            self.acceptTitle.append((hID.first?.key_title!)!)
            self.showingHelp()
        } else {
            self.showingHelp()
        }
    }
    
    @objc func showingHelp() {
        helpDescription.text = self.desc[self.currentSlide]
        acceptLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(self.acceptTitle[self.currentSlide])", strokeWidth: 8.0)
        acceptLabelForeGround.font = fonts().iPhonefonts
        acceptLabelForeGround.text = "\(self.acceptTitle[self.currentSlide])"
    }
    
    @objc func nextOrDismiss() {
        DispatchQueue.main.async {
            self.currentSlide = self.currentSlide + 1
            switch self.state {
            case "WELCOME" :
                if self.currentSlide == self.desc.count {
                    self.dismissing()
                    self.delegate?.tutorialPage()
                } else {
                    self.slideShowing()
                }
            case "START_GAME" :
                switch self.id {
                case "4" :
                    self.dismissing()
                    self.tDelegate?.showRest()
                case "7" :
                    self.dismissing()
                    self.tDelegate?.showUsingBomb()
                case "8" :
                    self.dismissing()
                    self.tDelegate?.enableAllButtons()
                case "9" :
                    self.dismissing()
                    self.tDelegate?.finishGameTutorial()
                    musicPlay().playQuizeMusic()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        musicPlay().playMenuMusic()
                    }
                    scrollToPage().scrollPageViewController(index: 4)
                    scrollToPage().menuButtonChanged(index: 4)
                    NotificationCenter.default.post(name: Notification.Name("showShopTutorial"), object: nil, userInfo: nil)
                case "10" :
                    self.dismissing()
                    self.tDelegate?.enableAllButtons()
                default :
                    if self.currentSlide == self.desc.count {
                        self.dismissing()
                        self.tDelegate?.showUsingFreeze()
                    } else {
                        self.showingHelp()
                    }
                }
                
            case "shopTutorial" :
                if self.currentSlide == self.desc.count {
                    self.dismissing()
                    self.shopDelegate?.shopTutorialSelect()
                } else {
                    self.showingHelp()
                }
            case "goToGroups" :
                self.dismissing()
                self.shopDelegate?.goToGroupsPage()
                NotificationCenter.default.post(name: Notification.Name("showShopTutorial"), object: nil, userInfo: nil)
            case "lastTutorialPage" :
                self.dismissing()
                self.groupsDelegate?.finishTutorial()
            case "MATCH_HELP" :
                self.dismissing()
                self.matchDelegate?.showMatchResult()
            default :
                if self.currentSlide == self.desc.count {
                    self.dismissing()
                } else {
                    self.slideShowing()
                }
            }
        }
    }
    
    @objc func dismissing() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
