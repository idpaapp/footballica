//
//  changePassAndUserNameViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 6/4/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class changePassAndUserNameViewController: UIViewController , UITextFieldDelegate {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var isSignUp = Bool()
    var isPasswordChange = Bool()
    
    //changeUser And Password Outlets
    @IBOutlet weak var passMainHeight: NSLayoutConstraint!
    @IBOutlet weak var passMainWidth: NSLayoutConstraint!
    @IBOutlet weak var totalPassView: UIView!
    
    //changeUser Outlets
    @IBOutlet weak var userTitle: UILabel!
    @IBOutlet weak var userTitleForeGround: UILabel!
    @IBOutlet weak var changeUserTextField: UITextField!
    @IBOutlet weak var userRequire: UILabel!
    @IBOutlet weak var userRequireForeGround: UILabel!
    @IBOutlet weak var changeUserAction: RoundButton!
    
    //Change Password Outlets
    @IBOutlet weak var mainPassView: DesignableView!
    @IBOutlet weak var currentPassTitle: UILabel!
    @IBOutlet weak var currentPassTitleForeGround: UILabel!
    @IBOutlet weak var currentPassTextField: UITextField!
    @IBOutlet weak var newPassTitle: UILabel!
    @IBOutlet weak var newPassTitleForeGround: UILabel!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var changePassOutlet: RoundButton!
    @IBOutlet weak var changePassTitle: UILabel!
    @IBOutlet weak var changePassTitleForeGround: UILabel!
    
    //SignUp Outlets
    @IBOutlet weak var signUpTotalView: UIView!
    @IBOutlet weak var dismissSignUp: RoundButton!
    @IBOutlet weak var singUpMainHeight: NSLayoutConstraint!
    @IBOutlet weak var signUpMainWidth: NSLayoutConstraint!
    @IBOutlet weak var signUpUserNameTitle: UILabel!
    @IBOutlet weak var signUpUserNameTitleForeGround: UILabel!
    @IBOutlet weak var signUpUserNameTextField: UITextField!
    @IBOutlet weak var passSignUpTitle: UILabel!
    @IBOutlet weak var passSignUpTitleForeGround: UILabel!
    @IBOutlet weak var passSignUpTextField: UITextField!
    @IBOutlet weak var ReagentCodeTitle: UILabel!
    @IBOutlet weak var ReagentCodeTitleForeGround: UILabel!
    @IBOutlet weak var ReagentCodeTextField: UITextField!
    @IBOutlet weak var signUpAction: RoundButton!
    @IBOutlet weak var signUpTitle: UILabel!
    @IBOutlet weak var signUpTitleForeGround: UILabel!
    
    
    @objc func changingUserPassNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            PubProc.wb.hideWaiting()
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(changingUserPassNotification), name: Notification.Name("changingUserPassNotification"), object: nil)
        
      
        self.signUpUserNameTextField.delegate = self
        self.passSignUpTextField.delegate = self
        
        let font = fonts().iPhonefonts
        
        if isSignUp {
            
            self.signUpTotalView.isHidden = false
            self.totalPassView.isHidden = true
            self.dismissSignUp.addTarget(self, action: #selector(dismissingSignUP), for: UIControlEvents.touchUpInside)
            signUpTotalView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            self.signUpUserNameTextField.attributedPlaceholder = NSAttributedString(string: "نام کاربری" ,attributes: [NSAttributedStringKey.foregroundColor: publicColors().placeHolderColor])
            self.passSignUpTextField.attributedPlaceholder = NSAttributedString(string: "کلمه عبور",attributes: [NSAttributedStringKey.foregroundColor: publicColors().placeHolderColor])
            self.ReagentCodeTextField.attributedPlaceholder = NSAttributedString(string: "کد معرف" ,attributes: [NSAttributedStringKey.foregroundColor: publicColors().placeHolderColor])
            signUpUserNameTitle.AttributesOutLine(font: font, title: "نام کاربری", strokeWidth: -6.0)
            signUpUserNameTitleForeGround.font = font
            signUpUserNameTitleForeGround.text = "نام کاربری"
            
            passSignUpTitle.AttributesOutLine(font: font, title: "کلمه عبور", strokeWidth: -6.0)
            passSignUpTitleForeGround.font = font
            passSignUpTitleForeGround.text = "کلمه عبور"
            
            ReagentCodeTitle.AttributesOutLine(font: font, title: "کد معرف", strokeWidth: -6.0)
            ReagentCodeTitleForeGround.font = font
            ReagentCodeTitleForeGround.text = "کد معرف"
            
            signUpTitle.AttributesOutLine(font: font, title: "ثبت نام" , strokeWidth: -6.0)
            signUpTitleForeGround.font = font
            signUpTitleForeGround.text = "ثبت نام"

            self.signUpAction.addTarget(self, action: #selector(signUP), for: UIControlEvents.touchUpInside)
        } else {
            
            self.signUpTotalView.isHidden = true
        if isPasswordChange {
            self.totalPassView.isHidden = false
            self.currentPassTextField.attributedPlaceholder = NSAttributedString(string: "کلمه عبور فعلی",attributes: [NSAttributedStringKey.foregroundColor: publicColors().placeHolderColor])
            
            self.newPassTextField.attributedPlaceholder = NSAttributedString(string: "کلمه عبور جدید",attributes: [NSAttributedStringKey.foregroundColor: publicColors().placeHolderColor])
            
            currentPassTitle.AttributesOutLine(font: font, title: "کلمه عبور فعلی", strokeWidth: -6.0)
            currentPassTitleForeGround.font = font
            currentPassTitleForeGround.text = "کلمه عبور فعلی"
            
            newPassTitle.AttributesOutLine(font: font, title: "کلمه عبور جدید", strokeWidth: -6.0)
            newPassTitleForeGround.font = font
            newPassTitleForeGround.text = "کلمه عبور جدید"
            
            changePassTitle.AttributesOutLine(font: font, title: "تأیید", strokeWidth: -6.0)
            changePassTitleForeGround.font = font
            changePassTitleForeGround.text = "تأیید"
            
            mainPassView.isHidden = false
       
            self.changePassOutlet.addTarget(self, action: #selector(changePass), for: UIControlEvents.touchUpInside)

            
            if UIDevice().userInterfaceIdiom == .phone {
                passMainHeight.constant = 250
                passMainWidth.constant = (UIScreen.main.bounds.width - 50)
            } else {
                passMainHeight.constant = 250
                passMainWidth.constant = 350
            }
            
        } else {
            
            self.changeUserTextField.attributedPlaceholder = NSAttributedString(string: "نام کاربری" ,attributes: [NSAttributedStringKey.foregroundColor: publicColors().placeHolderColor])
            
            let coin = Int((login.res?.response?.mainInfo?.coins)!)
            let requireCoin = Int((loadingViewController.loadGameData?.response?.giftRewards?.change_name!)!)
            if coin! < requireCoin {
                self.changeUserAction.isEnabled = false
            } else {
                self.changeUserAction.isEnabled = true
            }
            
            self.changeUserAction.addTarget(self, action: #selector(changeUserName), for: UIControlEvents.touchUpInside)
            
            userTitle.AttributesOutLine(font: font, title: "نام کاربری", strokeWidth: -6.0)
            userTitleForeGround.font = font
            userTitleForeGround.text = "نام کاربری"
            
            userRequire.AttributesOutLine(font: font, title: "\((loadingViewController.loadGameData?.response?.giftRewards?.change_name!)!)", strokeWidth: -7.0)
            userRequireForeGround.font = font
            userRequireForeGround.text = "\((loadingViewController.loadGameData?.response?.giftRewards?.change_name!)!)"
            
            mainPassView.isHidden = true
            if UIDevice().userInterfaceIdiom == .phone {
                passMainHeight.constant = 190
                passMainWidth.constant = (UIScreen.main.bounds.width - 50)
            } else {
                
                passMainHeight.constant = 180
                passMainWidth.constant = 350
                
            }
        }
        
        totalPassView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isSignUp {
            UIView.animate(withDuration: 0.3 , animations :{
                self.signUpTotalView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            } , completion : { (finish) in
                UIView.animate(withDuration: 0.3 , animations :{
                    self.signUpTotalView.transform = CGAffineTransform.identity
                })
            })
        } else {
        UIView.animate(withDuration: 0.3 , animations :{
            self.totalPassView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        } , completion : { (finish) in
            UIView.animate(withDuration: 0.3 , animations :{
                self.totalPassView.transform = CGAffineTransform.identity
            })
        })
        }
    }
    
    var alertBody = String()
    var alertTitle = String()
    var alertState = String()
    var jsonStr = String()
    
    @objc func changeUserName() {
        let texts = self.changeUserTextField.text
        if texts?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {

            self.alertBody = "آیا برای تغییر نام کاربری اطمینان دارید؟"
            self.alertState = "changeUserName"
            self.jsonStr = "{'mode':'ChangeUserName' , 'UserName':'\(texts!)', 'userid':'\(loadingViewController.userid)'}"
            self.performSeguePage(identifier: "passAccept")
            
        } else {
            
            self.alertBody = "لطفاً نام کاربری را وارد نمایید"
            self.alertTitle = "خطا"
            self.alertState = "changeUserName"
            self.performSeguePage(identifier: "passAlert")
        }
    }
    
    @objc func changePass() {
        let texts = self.currentPassTextField.text
        let texts2 = self.newPassTextField.text
        if texts?.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&  texts2?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {

            if ((texts?.count)!) < 8  {
                
                self.alertBody = "کلمه ی عبور فعلی باید حداقل 8 کاراکتر باشد!"
                self.alertTitle = "خطا"
                self.alertState = "changePassword"
                self.performSeguePage(identifier: "passAlert")
                
            } else if ((texts2?.count)!) < 8 {
                
                self.alertBody = "کلمه ی عبور جدید باید حداقل 8 کاراکتر باشد!"
                self.alertTitle = "خطا"
                self.alertState = "changePassword"
                self.performSeguePage(identifier: "passAlert")
                
            } else {
                
            self.alertBody = "آیا برای تغییر کلمه عبور اطمینان دارید؟"
            self.alertState = "changePassword"
            self.jsonStr = "{'mode':'ChangePassword' , 'Password':'\(texts2!)' , 'OldPass':'\(texts!)', 'userid':'\(loadingViewController.userid)'}"
            self.performSeguePage(identifier: "passAccept")
            }
            
        } else {
            
            self.alertBody = "لطفاً کلمه ی عبور و تکرار آن را وارد کنید"
            self.alertTitle = "خطا"
            self.alertState = "changePassword"
            self.performSeguePage(identifier: "passAlert")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
            return count <= 20
    }
    
    @objc func signUP() {
        let texts = self.signUpUserNameTextField.text
        let texts2 = self.passSignUpTextField.text
        let texts3 = self.ReagentCodeTextField.text
        if texts!.trimmingCharacters(in: .whitespacesAndNewlines) != "" ||  texts2!.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            
            if ((texts2?.count)!) < 8  {
                
                self.alertBody = "کلمه ی عبور باید حداقل 8 کاراکتر باشد!"
                self.alertTitle = "خطا"
                self.alertState = "changePassword"
                self.performSeguePage(identifier: "passAlert")
                
            } else {
            
                self.alertBody = "آیا برای ثبت نام اطمینان دارید؟"
                self.alertState = "signUp"
            self.jsonStr = "{'mode':'SignUp' , 'UserName' : '\(texts!)' , 'Password':'\(texts2!)' , 'RefCode':'\(texts3!)', 'userid':'\(loadingViewController.userid)'}"
                self.performSeguePage(identifier: "passAccept")
            }
            
        } else {
            
            self.alertBody = "لطفاً کلمه ی عبور و نام کاربری را وارد کنید"
            self.alertTitle = "خطا"
            self.alertState = "changePassword"
            self.performSeguePage(identifier: "passAlert")
        }
    }
    
    
    @objc func performSeguePage(identifier : String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? menuAlertViewController {
            vc.alertAcceptLabel = "تأیید"
            vc.alertBody = self.alertBody
            vc.alertTitle = self.alertTitle
            vc.alertState = self.alertState
        }
        
        if let vc = segue.destination as? menuAlert2ButtonsViewController {
            vc.alertAcceptLabel = "تأیید"
            vc.alertTitle = "فوتبالیکا"
            vc.alertBody = self.alertBody
            vc.state = self.alertState
            vc.jsonStr = self.jsonStr
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissing(_ sender: RoundButton) {
       dismissPage()
    }
    
    @objc func dismissPage() {
        UIView.animate(withDuration: 0.2 , animations :{
            self.totalPassView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        } , completion : { (finish) in
            UIView.animate(withDuration: 0.2 , animations :{
                self.totalPassView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            } , completion : { (finish) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        })
    }
    
    @objc func dismissingSignUP() {
        UIView.animate(withDuration: 0.2 , animations :{
            self.signUpTotalView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        } , completion : { (finish) in
            UIView.animate(withDuration: 0.2 , animations :{
                self.signUpTotalView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            } , completion : { (finish) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        })
    }
}
