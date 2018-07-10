//
//  mainMatchFieldViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class mainMatchFieldViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var question1: UIImageView!
    @IBOutlet weak var question2: UIImageView!
    @IBOutlet weak var question3: UIImageView!
    @IBOutlet weak var question4: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var questionTitleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer1Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer2Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer3Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer4Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var questionsTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var beforeStartView: UIView!
    
    @IBOutlet weak var beforeStartCountDown: UILabel!
    
    @IBOutlet weak var beforeStartTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        question1.image = UIImage()
        question2.image = UIImage()
        question3.image = UIImage()
        question4.image = UIImage()

        scoreLabel.text = ""
        beforeStartCountDown.text = ""
        beforeStartTitle.text = ""
        beforeStartTitle.adjustsFontSizeToFitWidth = true
        beforeStartTitle.minimumScaleFactor = 0.5
        questionsTopConstraint.constant = (UIScreen.main.bounds.height / 11) + (UIScreen.main.bounds.height / 3) + 50
        questionTitleConstraint.constant = -((UIScreen.main.bounds.height / 3) + 50)
        self.answer1Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5) + 30)
        self.answer3Constraint.constant = -((2 * UIScreen.main.bounds.width / 5) + 30)
        self.answer2Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5 ) + 30)
        self.answer4Constraint.constant = -((2 * UIScreen.main.bounds.width / 5 ) + 30)
        
        readMatchData()
    }
    
    
    func readMatchData() {
        //match Data Json
        musicPlay().playMenuMusic()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.beforeMatchTimer()
        }
        
    }
    
    
    func beforeMatchTimer() {

        beforeStartCountDown.text = "3"
        beforeStartTitle.text = "واسه شروع اماده ای؟"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.beforeStartCountDown.text = "2"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.beforeStartCountDown.text = "1"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            soundPlay().playWhistleSound()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.startMatch()
        }
    }
    
    
    func startMatch() {
        beforeStartView.isHidden = true
        beforeStartCountDown.isHidden = true
        beforeStartTitle.isHidden = true
        scoreLabel.text = "امتیاز شما : ۰ از ۴"
            DispatchQueue.main.async {
                musicPlay().playQuizeMusic()
            }
        UIView.animate(withDuration: 0.8) {
            self.questionTitleConstraint.constant = UIScreen.main.bounds.height / 11 + 30
            self.answer1Constraint.constant = UIScreen.main.bounds.width / 10 - 5
            self.answer3Constraint.constant = UIScreen.main.bounds.width / 10 - 5
            self.answer2Constraint.constant = UIScreen.main.bounds.width / 10 - 5
            self.answer4Constraint.constant = UIScreen.main.bounds.width / 10 - 5
            self.view.layoutIfNeeded()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
