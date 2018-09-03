//
//  massageViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 6/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class massageViewController: UIViewController , UITextViewDelegate , UITextFieldDelegate {

    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalViewWidth: NSLayoutConstraint!
    @IBOutlet weak var dismissButton: RoundButton!
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var topForeGroundTitle: UILabel!
    @IBOutlet weak var massageTitle: UITextField!
    @IBOutlet weak var massageDesc: UITextView!
    @IBOutlet weak var sendMassage: RoundButton!
    @IBOutlet weak var sendMassageTitle: UILabel!
    @IBOutlet weak var sendMassageTitleForeGround: UILabel!
    
    var massagePageTitle = String()
    var titleForSend = String()
    var massageForSend = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.massageDesc.delegate = self
        self.massageTitle.delegate = self
        
        self.massageDesc.text = "توضیحات"
        self.massageDesc.textColor = publicColors().placeHolderColor
        
        self.topTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(self.massagePageTitle)", strokeWidth: -6.0)
        self.topForeGroundTitle.font = fonts().iPhonefonts
        self.topForeGroundTitle.text = "\(self.massagePageTitle)"
        
        self.massageTitle.attributedPlaceholder = NSAttributedString(string: "نام کاربری" ,attributes: [NSAttributedStringKey.foregroundColor: publicColors().placeHolderColor])
        self.massageTitle.textColor = publicColors().textFieldTintTextColor
        
        self.totalView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        self.dismissButton.addTarget(self, action: #selector(dismissPage), for: UIControlEvents.touchUpInside)
        
        self.massageTitle.addTarget(self, action: #selector(textFieldDidChange) , for: UIControlEvents.editingChanged)
        
        self.sendMassage.addTarget(self, action: #selector(sendingMassage), for: UIControlEvents.touchUpInside)
        
        self.sendMassageTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "ارسال", strokeWidth: -6.0)
        self.sendMassageTitleForeGround.text = "ارسال"
        self.sendMassageTitleForeGround.font = fonts().iPhonefonts

    }
    
    var alertTitle = String()
    var alertBody = String()
    
    var res : String? = nil
    
    @objc func sendingMassage() {
        
        if self.titleForSend.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if self.massageForSend.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                var additionalTitle = String()
                if self.massagePageTitle == "گزارش مشکل" {
                    additionalTitle = "report Problem - iOS"
                } else {
                    additionalTitle = "comment - iOS"
                }
                
                PubProc.HandleDataBase.readJson(wsName: "ws_handleInbox", JSONStr: "{'title' : '\(self.titleForSend)\(additionalTitle)' , 'message' : '\(self.massageForSend)' , 'userid':'\(loadingViewController.userid)'}") { data, error in
                    DispatchQueue.main.async {
                        
                        if data != nil {
                            
                            //                print(data ?? "")
                            
                            
                            self.res = String(data: data!, encoding: String.Encoding.utf8) as String?
                            
//                            print(self.res!)
                                                if ((self.res)!).contains("OK") {
                                                    
                                                    if self.massagePageTitle == "گزارش مشکل" {
                                                        self.alertTitle = "فوتبالیکا"
                                                        self.alertBody = "گزارش شما ثبت گردید. پس از تایید جایزه به شما تعلق می گیرد."
                                                        self.performSegue(withIdentifier: "massageSendAlert", sender: self)
                                                    } else {
                                                        self.alertTitle = "فوتبالیکا"
                                                        self.alertBody = "انتقاد یا پیشنهاد شما ثبت گردید. پس از تایید جایزه به شما تعلق می گیرد."
                                                        self.performSegue(withIdentifier: "massageSendAlert", sender: self)
                                                    }
                                                    
                                                } else {
                                                    self.alertTitle = "اخطار"
                                                    self.alertBody = "پاسخی از سرور دریافت نشد لطفاً مجدداً تلاش فرمایید"
                                                    self.performSegue(withIdentifier: "massageSendAlert", sender: self)
                                                }
                            
                            
                            DispatchQueue.main.async {
                                PubProc.wb.hideWaiting()
                                PubProc.cV.hideWarning()
                            }
                            
                            
                        } else {
                            print("Error Connection")
                            print(error as Any)
                            // handle error
                        }
                    }
                    }.resume()
                
            } else {
                self.alertTitle = "اخطار"
                self.alertBody = "لطفاً توضیحات را تکمیل بفرمایید!"
                self.performSegue(withIdentifier: "massageSendAlert", sender: self)
            }
        } else {
            self.alertTitle = "اخطار"
            self.alertBody = "لطفاً عنوان را تکمیل بفرمایید!"
            self.performSegue(withIdentifier: "massageSendAlert", sender: self)
        }
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        self.titleForSend = (self.massageTitle.text)!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 40
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 500
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.massageDesc.textColor == publicColors().placeHolderColor {
            self.massageDesc.text = ""
            self.massageDesc.textColor = publicColors().textFieldTintTextColor
            self.massageForSend = (self.massageDesc.text)!
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        self.massageForSend = (self.massageDesc.text)!
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.massageDesc.text == "" {
            self.massageDesc.text = "توضیحات"
            self.massageDesc.textColor = publicColors().placeHolderColor
        }
    }
    
    @objc func dismissPage() {
        UIView.animate(withDuration: 0.3, animations: {
            self.totalView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: {(finish) in
            UIView.animate(withDuration: 0.3, animations: {
                self.totalView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            }, completion: {(finish) in
                self.dismiss(animated: true, completion: nil)
            })
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.2, animations: {
            self.totalView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: {(finish) in
            UIView.animate(withDuration: 0.2, animations: {
                self.totalView.transform = CGAffineTransform.identity
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? menuAlertViewController {
            vc.alertTitle = self.alertTitle
            vc.alertBody = self.alertBody
            vc.alertAcceptLabel = "تأیید"
            vc.alertState = "report"
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
