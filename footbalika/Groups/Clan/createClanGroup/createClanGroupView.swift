//
//  createClanGroupView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/5/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class createClanGroupView: UIView , UITextFieldDelegate , UITextViewDelegate{

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
        
    @IBOutlet weak var selectLogo: RoundButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.groupImageSelectButton.setButtons(hideAction: true, hideAction1: false, hideAction2: true, hideAction3: true)
        self.groupImageSelectButton.setTitles(actionTitle: "", action1Title: "انتخاب", action2Title: "", action3Title: "")
        self.buyButton.setPriceTitle(title: "50", font: fonts().iPhonefonts)
        self.buyButton.priceImage.image = UIImage(named: "ic_coin")
        self.publicGroup.radioButtonTitle.text = "عمومی"
        self.privateGroup.radioButtonTitle.text = "خصوصی"
        self.groupTextView.layer.borderColor = UIColor.gray.cgColor
        self.groupTextView.layer.borderWidth = 1.0
        self.groupTextView.layer.cornerRadius = 10
        self.groupNameTextField.adjustsFontSizeToFitWidth = true
        self.groupNameTextField.minimumFontSize = 0.1
        self.groupNameTextField.delegate = self
        self.groupTextView.delegate = self
        self.publicGroup.radioButton.setBackgroundImage(publicImages().radioButtonFill, for: UIControlState.normal)
        self.privateGroup.radioButton.setBackgroundImage(publicImages().radioButtonEmpty, for: UIControlState.normal)
        self.privateGroup.radioButton.isExclusiveTouch = true
        self.publicGroup.radioButton.isExclusiveTouch = true
        
//        if UIDevice().userInterfaceIdiom == .pad {
//            self.buyButton.buyAction.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 1.1)
//        } else {
//            self.buyButton.buyAction.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1.2)
//        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 20
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 701    // 701 Limit Value
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
