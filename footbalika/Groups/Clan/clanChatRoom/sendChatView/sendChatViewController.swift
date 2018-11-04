//
//  sendChatViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 7/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class sendChatViewController: UIViewController , UITextViewDelegate {

    @IBOutlet weak var sendButton: RoundButton!
    
    @IBOutlet weak var chatTextView: UITextView!
    
    @IBOutlet weak var sendButtonTitle: UILabel!
    
    @IBOutlet weak var sendButtonTitleForeGround: UILabel!
    
    @IBOutlet weak var clearChatTextView: RoundButton!
    
    var delegate : sendChatViewControllerDelegate!
    
    var textForSend = String()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sendButtonTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "ارسال", strokeWidth: -5.0)
        self.sendButtonTitleForeGround.font = fonts().iPhonefonts
        self.sendButtonTitleForeGround.text = "ارسال"
        self.chatTextView.layer.cornerRadius = 10
        self.chatTextView.layer.borderColor = UIColor.init(red: 190/255, green: 200/255, blue: 209/255, alpha: 1.0).cgColor
        self.chatTextView.layer.borderWidth = 1.0
        self.chatTextView.delegate = self
        self.sendButton.addTarget(self, action: #selector(sendingAction), for: UIControlEvents.touchUpInside)
        self.chatTextView.contentInset = UIEdgeInsets(top: 0, left: 29, bottom: 0, right: 10)
        self.clearChatTextView.addTarget(self, action: #selector(clearChatTexs), for: UIControlEvents.touchUpInside)
        self.clearChatTextView.isHidden = true
        self.chatTextView.delegate = self
    }
    
    
    @objc func clearChatTexs() {
        self.textForSend = ""
        self.chatTextView.text = ""
        self.clearChatTextView.isHidden = true
        checkNumberOfLines()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 701    // 701 Limit Value
    }
    
    @objc func textViewDidChange(_ textField: UITextView) {

        self.textForSend = self.chatTextView.text!
        if self.chatTextView.text! == "" {
            self.clearChatTextView.isHidden = true
        } else {
            self.clearChatTextView.isHidden = false
        }
        
        checkNumberOfLines()
    }
    
    
    @objc func checkNumberOfLines() {
        
        let layoutManager:NSLayoutManager = self.chatTextView!.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        
        var numberOfLines = 0
        var index = 0
        var lineRange:NSRange = NSRange()
        
        while (index < numberOfGlyphs) {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            numberOfLines = numberOfLines + 1
        }
        
        //        let bottom = NSMakeRange(self.chatTextView!.text.count - 1, 1)
        //        self.chatTextView!.scrollRangeToVisible(bottom)
        //        print(numberOfLines)
        
        var heightConstant = Int()
        
        if  UIScreen.main.bounds.height <= 568 {
            if numberOfLines > 3 {
                numberOfLines = 3
            }
        } else {
            if  UIScreen.main.bounds.height <= 667  {
                if numberOfLines > 5 {
                    numberOfLines = 5
                }
            } else {
                if numberOfLines > 7 {
                    numberOfLines = 7
                }
            }
        }
        
        switch numberOfLines {
        case 1:
            heightConstant = 60 * numberOfLines
            self.chatTextView.isScrollEnabled = false
        case 2:
            heightConstant = 100
            self.chatTextView.isScrollEnabled = false
        case 3:
            heightConstant = 110
            self.chatTextView.isScrollEnabled = true
        case 4:
            heightConstant = 130
            self.chatTextView.isScrollEnabled = true
        case 5:
            heightConstant = 150
            self.chatTextView.isScrollEnabled = true
        case 6:
            heightConstant = 180
            self.chatTextView.isScrollEnabled = true
        case 7:
            heightConstant = 210
            self.chatTextView.isScrollEnabled = true
        default:
            heightConstant = 60
            self.chatTextView.isScrollEnabled = true
        }
        
        self.delegate?.updateChatView(constraint: CGFloat(heightConstant))
    }
    
    @objc func sendingAction() {
        self.delegate?.sendChat(chatString: self.textForSend)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
