//
//  predictOneMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class predictOneMatchViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var mainTitleForeGround: UILabel!
    
    @IBOutlet weak var submitTitle: UILabel!
    
    @IBOutlet weak var submitForeGroundTitle: UILabel!
    
    @IBOutlet weak var homeTeamImage: UIImageView!
    
    @IBOutlet weak var awayTeamImage: UIImageView!
    
    @IBOutlet weak var homeResault: UITextField!
    
    @IBOutlet weak var awayResault: UITextField!
    
    var homeImg = String()
    var awayImg = String()
    var predictionId = Int()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var aScore = (textField.text!)
        aScore = aScore.replacedArabicDigitsWithEnglish
        if Int(aScore) == nil {
            textField.text = ""
        }
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 2
    }
    
    var homeScore = Int()
    var awayScore = Int()
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc func textFieldDidChange(textField: UITextField) {
        if self.homeResault.text! != "" {
            var hScore = (self.homeResault.text!)
            hScore = hScore.replacedArabicDigitsWithEnglish
            if Int(hScore) != nil {
                homeScore = Int(hScore)!
            } else {
                homeScore = 0
            }
        } else {
            homeScore = 0
        }
        
        
        if self.awayResault.text! != "" {
            var aScore = (self.awayResault.text!)
            aScore = aScore.replacedArabicDigitsWithEnglish
            if Int(aScore) != nil {
                awayScore = Int(aScore)!
            } else {
                awayScore = 0
            }
        } else {
            awayScore = 0
        }
    }
    
    @objc func closePredictionOneMatch(notification: Notification){
        PubProc.wb.showWaiting()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.dismiss(animated: true, completion: nil)
                PubProc.wb.hideWaiting()
                PubProc.cV.hideWarning()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.closePredictionOneMatch(notification:)), name: Notification.Name("refreshPrediction"), object: nil)
        
        print(predictionId)
        self.homeResault.delegate = self
        self.awayResault.delegate = self
        
        self.homeResault.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        
        self.awayResault.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)

        self.mainTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "پیش بینی", strokeWidth: 8.0)
        
        self.mainTitleForeGround.text = "پیش بینی"
        self.mainTitleForeGround.font = fonts().iPadfonts25
        self.submitTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "ثبت", strokeWidth: 8.0)
        self.submitForeGroundTitle.font = fonts().iPadfonts25
        self.submitForeGroundTitle.text = "ثبت"
        
        homeTeamImage.setImageWithKingFisher(url: "\(homeImg)")
        awayTeamImage.setImageWithKingFisher(url: "\(awayImg)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        endEditting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissing(_ sender: RoundButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func endEditting() {
        self.homeResault.endEditing(true)
        self.awayResault.endEditing(true)
    }
    
    @IBAction func submitResault(_ sender: RoundButton) {
        endEditting()
        self.performSegue(withIdentifier: "askToPredict", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! menuAlert2ButtonsViewController
        vc.jsonStr = "{'mode':'INS_PREDICtION' , 'userid' : '\(loadingViewController.userid)' , 'prediction_id' : '\(predictionId)' , 'home_prediction' : '\(homeScore)' , 'away_prediction' : '\(awayScore)'}"
        
        vc.state = "prediction"
        vc.alertBody = "پیش بینی شما \(awayScore) : \(homeScore) \n آیا برای ثبت نتیجه اطمینان دارید؟ \n این مقادیر قابل ویرایش نمی باشد."
        vc.alertTitle = "فوتبالیکا"
    }
}
