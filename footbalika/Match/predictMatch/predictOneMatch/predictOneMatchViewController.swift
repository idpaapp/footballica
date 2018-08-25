//
//  predictOneMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

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
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 2
    }
    
    var homeScore = Int()
    var awayScore = Int()
    
    @objc func textFieldDidChange(textField: UITextField) {
        if self.homeResault.text! != "" {
            var hScore = (self.homeResault.text!)
            hScore = hScore.replacedArabicDigitsWithEnglish
            homeScore = Int(hScore)!
            print(homeScore)
        } else {
            homeScore = 0
            print(homeScore)
        }
        
        
        if self.awayResault.text! != "" {
            var aScore = (self.awayResault.text!)
            aScore = aScore.replacedArabicDigitsWithEnglish
            awayScore = Int(aScore)!
            print(awayScore)
        } else {
            awayScore = 0
            print(awayScore)
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

        self.mainTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "پیش بینی", strokeWidth: -6.0)
        
        self.mainTitleForeGround.text = "پیش بینی"
        self.mainTitleForeGround.font = fonts().iPadfonts25
        self.submitTitle.AttributesOutLine(font: fonts().iPadfonts25, title: "ثبت", strokeWidth: -6.0)
        self.submitForeGroundTitle.font = fonts().iPadfonts25
        self.submitForeGroundTitle.text = "ثبت"
        
        let team1LogoUrl = "\(homeImg)"
        let team1ImgUrl = URL(string: team1LogoUrl)
        homeTeamImage.kf.setImage(with: team1ImgUrl ,options:[.transition(ImageTransition.fade(0.5))])
        let team2LogoUrl = "\(awayImg)"
        let team2ImgUrl = URL(string: team2LogoUrl)
        awayTeamImage.kf.setImage(with: team2ImgUrl ,options:[.transition(ImageTransition.fade(0.5))])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissing(_ sender: RoundButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitResault(_ sender: RoundButton) {
        self.performSegue(withIdentifier: "askToPredict", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! menuAlert2ButtonsViewController
        vc.jsonStr = "{'mode':'INS_PREDICtION' , 'userid' : '\(loadingViewController.userid)' , 'prediction_id' : '\(predictionId)' , 'home_prediction' : '\(homeScore)' , 'away_prediction' : '\(awayScore)'}"
        
        vc.state = "prediction"
        vc.alertBody = "آیا برای ثبت نتیجه اطمینان دارید؟ \nاین مقادیر قابل ویرایش نمی باشد."
        vc.alertTitle = "فوتبالیکا"
    }

}
