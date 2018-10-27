//
//  createClanGroupView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/5/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class createClanGroupView: UIView {


    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var closePage: RoundButton!
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var groupImage: UIImageView!
    
    @IBOutlet weak var groupImageSelectButton: actionLargeButton!
    
    @IBOutlet weak var groupTextView: UITextView!
    
    @IBOutlet weak var publicGroup: radioButtonView!
    
    @IBOutlet weak var privateGroup: radioButtonView!
    
    @IBOutlet weak var setMinMaxCup: minMaxView!
    
    @IBOutlet weak var buyButton: buyButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.groupImageSelectButton.setButtons(hideAction: true, hideAction1: false, hideAction2: true, hideAction3: true)
        self.groupImageSelectButton.setTitles(actionTitle: "", action1Title: "انتخاب", action2Title: "", action3Title: "")
        self.buyButton.setPriceTitle(title: "50", font: fonts().iPhonefonts)
        self.buyButton.priceImage.image = UIImage(named: "ic_coin")
        self.publicGroup.radioButtonTitle.text = "عمومی"
        self.privateGroup.radioButtonTitle.text = "خصوصی"
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
    Bundle.main.loadNibNamed("createClanGroupView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }

}
