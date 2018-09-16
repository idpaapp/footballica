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
    var currentSlide = 0
    
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
    
    @objc func slideShowing() {
        helpDescription.text = self.desc[self.currentSlide]
        acceptLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(self.acceptTitle[self.currentSlide])", strokeWidth: -6.0)
        acceptLabelForeGround.font = fonts().iPhonefonts
        acceptLabelForeGround.text = "\(self.acceptTitle[self.currentSlide])"
    }
    
    @objc func nextOrDismiss() {
        self.currentSlide = self.currentSlide + 1
        if self.currentSlide == self.desc.count {
            self.dismiss(animated: true, completion: nil)
        } else {
            slideShowing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
