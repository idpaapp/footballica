//
//  changePassAndUserNameViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 6/4/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class changePassAndUserNameViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var isPasswordChange = Bool()
    @IBOutlet weak var mainHeight: NSLayoutConstraint!
    @IBOutlet weak var mainWidth: NSLayoutConstraint!
    @IBOutlet weak var totalView: UIView!
    
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

        let placeHolderColor = UIColor.init(red: 202/255, green: 202/255, blue: 202/255, alpha: 1.0)
        
        let font = fonts().iPhonefonts
        
        if isPasswordChange {
            
            self.currentPassTextField.attributedPlaceholder = NSAttributedString(string: "کلمه عبور فعلی",attributes: [NSAttributedStringKey.foregroundColor: placeHolderColor])
            
            self.newPassTextField.attributedPlaceholder = NSAttributedString(string: "کلمه عبور جدید",attributes: [NSAttributedStringKey.foregroundColor: placeHolderColor])
            
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
                mainHeight.constant = 250
                mainWidth.constant = (UIScreen.main.bounds.width - 50)
            } else {
                mainHeight.constant = 250
                mainWidth.constant = 350
            }
            
        } else {
            
            self.changeUserTextField.attributedPlaceholder = NSAttributedString(string: "نام کاربری" ,attributes: [NSAttributedStringKey.foregroundColor: placeHolderColor])
            
            let coin = Int((login.res?.response?.mainInfo?.coins)!)
            if coin! < 100 {
                self.changeUserAction.isEnabled = false
            } else {
                self.changeUserAction.isEnabled = true
            }
            
            self.changeUserAction.addTarget(self, action: #selector(changeUserName), for: UIControlEvents.touchUpInside)
            
            userTitle.AttributesOutLine(font: font, title: "نام کاربری", strokeWidth: -6.0)
            userTitleForeGround.font = font
            userTitleForeGround.text = "نام کاربری"
            
            userRequire.AttributesOutLine(font: font, title: "100", strokeWidth: -7.0)
            userRequireForeGround.font = font
            userRequireForeGround.text = "100"
            
            mainPassView.isHidden = true
            if UIDevice().userInterfaceIdiom == .phone {
                mainHeight.constant = 190
                mainWidth.constant = (UIScreen.main.bounds.width - 50)
            } else {
                
                mainHeight.constant = 180
                mainWidth.constant = 350
                
            }
        }
        
        totalView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 0.3 , animations :{
            self.totalView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        } , completion : { (finish) in
            UIView.animate(withDuration: 0.3 , animations :{
                self.totalView.transform = CGAffineTransform.identity
            })
        })
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
            self.totalView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        } , completion : { (finish) in
            UIView.animate(withDuration: 0.2 , animations :{
                self.totalView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            } , completion : { (finish) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        })
    }
    
    
    
   

}
