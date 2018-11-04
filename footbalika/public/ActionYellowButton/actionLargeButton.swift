//
//  actionLargeButton.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class actionLargeButton: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var actionButton: RoundButton!
    
    @IBOutlet weak var actionButtonTitle: UILabel!
    
    @IBOutlet weak var actionButtonTitleForeGround: UILabel!
    
    @IBOutlet weak var action1: RoundButton!
    
    @IBOutlet weak var action2: RoundButton!
    
    @IBOutlet weak var action3: RoundButton!
    
    @IBOutlet weak var action1Title: UILabel!
    
    @IBOutlet weak var action1TitleForeGround: UILabel!
    
    @IBOutlet weak var action2Title: UILabel!
    
    @IBOutlet weak var action2TitleForeGround: UILabel!
    
    @IBOutlet weak var action3Title: UILabel!
    
    @IBOutlet weak var action3TitleForeGround: UILabel!
    
    @IBOutlet weak var actionsStackView: UIStackView!
    
    @objc func setButtons(hideAction : Bool , hideAction1 : Bool , hideAction2 : Bool , hideAction3 : Bool) {
        
        actionButton.isHidden = hideAction
        actionButtonTitle.isHidden = hideAction
        actionButtonTitleForeGround.isHidden = hideAction
        self.action1.isHidden = hideAction1
        self.action2.isHidden = hideAction2
        self.action3.isHidden = hideAction3
        action1Title.isHidden = hideAction1
        action1TitleForeGround.isHidden = hideAction1
        action2Title.isHidden = hideAction2
        action2TitleForeGround.isHidden = hideAction2
        action3Title.isHidden = hideAction3
        action3TitleForeGround.isHidden = hideAction3
        if action1.isHidden && action2.isHidden && action3.isHidden {
            self.actionsStackView.isHidden = true
        } else {
            self.actionsStackView.isHidden = false
        }
    }
    
    @objc func setTitles(actionTitle : String , action1Title : String , action2Title : String , action3Title : String) {
        setButtonTitle(buttonLabel : actionButtonTitle , title : actionTitle, buttonForeGroundLabel : actionButtonTitleForeGround)
        setButtonTitle(buttonLabel : self.action1Title , title : action1Title , buttonForeGroundLabel : action1TitleForeGround)
        setButtonTitle(buttonLabel : self.action2Title , title : action2Title , buttonForeGroundLabel : action2TitleForeGround)
        setButtonTitle(buttonLabel : self.action3Title , title : action3Title , buttonForeGroundLabel : action3TitleForeGround)
    }
    
    @objc func setButtonTitle (buttonLabel : UILabel , title : String , buttonForeGroundLabel : UILabel) {
        buttonLabel.AttributesOutLine(font: fonts().iPhonefonts, title: title, strokeWidth: -5.0)
        buttonForeGroundLabel.font = fonts().iPhonefonts
        buttonForeGroundLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("actionLargeButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }

}
