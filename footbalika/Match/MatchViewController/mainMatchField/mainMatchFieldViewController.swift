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
    
    @IBOutlet weak var handWatchImage: UIImageView!
    
    @IBOutlet weak var question1Ball: UIImageView!
    @IBOutlet weak var question2Ball: UIImageView!
    @IBOutlet weak var question3Ball: UIImageView!
    @IBOutlet weak var question4Ball: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var questionTitleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer1Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer2Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer3Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer4Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var questionsTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer1Outlet: UIButton!
    
    @IBOutlet weak var answer2Outlet: UIButton!
    
    @IBOutlet weak var answer3Outlet: UIButton!
    
    @IBOutlet weak var answer4Outlet: UIButton!
    
    @IBOutlet weak var beforeStartView: UIView!
    
    @IBOutlet weak var beforeStartCountDown: UILabel!
    
    @IBOutlet weak var beforeStartTitle: UILabel!
    
    var level = String()
    var category = String()
    var last_questions = String()
    var userid = String()
    var answers = [[String]]()
    
    var lastVC: selectCategoryViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        lastVC.dismiss(animated: true, completion: nil)
        question1Ball.image = publicImages().emptyImage
        question2Ball.image = publicImages().emptyImage
        question3Ball.image = publicImages().emptyImage
        question4Ball.image = publicImages().emptyImage

        scoreLabel.text = ""
        beforeStartCountDown.text = ""
        beforeStartTitle.text = ""
        beforeStartTitle.adjustsFontSizeToFitWidth = true
        beforeStartTitle.minimumScaleFactor = 0.5
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                //iPhone X
                
                
                
                
            } else {
                //Other iPhones
                questionsTopConstraint.constant = (UIScreen.main.bounds.height / 11) + (UIScreen.main.bounds.height / 3) + 50
                questionTitleConstraint.constant = -((UIScreen.main.bounds.height / 3) + 50)
                self.answer1Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5) + 30)
                self.answer3Constraint.constant = -((2 * UIScreen.main.bounds.width / 5) + 30)
                self.answer2Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5 ) + 30)
                self.answer4Constraint.constant = -((2 * UIScreen.main.bounds.width / 5 ) + 30)
            }
            
        } else {
            //iPad
            
            
            
            
        }
        
        
        readMatchData()
    }
    
    var res : questionsList.Response? = nil;
    func readMatchData() {
        //match Data Json
        PubProc.HandleDataBase.readJson(wsName: "ws_getQuestionData", JSONStr: "{'level':'\(level)','category':'\(category)','last_questions':'','userid':'1'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.res = try JSONDecoder().decode(questionsList.Response.self , from : data!)
                        
                        self.restMatchFunction()
                        
                    } catch {
                        self.readMatchData()
                        print(error)
                    }
                } else {
                    self.readMatchData()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
        
       
    }
    
    
    func restMatchFunction() {
        if musicPlay.musicPlayer?.isPlaying == true {
            musicPlay().playMenuMusic()
        } else {}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.beforeMatchTimer()
        }
    }
    
    func beforeMatchTimer() {

        beforeStartCountDown.text = "3"
        beforeStartTitle.text = "واسه شروع اماده ای؟"
        soundPlay().playBeepSound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.beforeStartCountDown.text = "2"
            soundPlay().playBeepSound()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.beforeStartCountDown.text = "1"
            soundPlay().playBeepSound()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            soundPlay().playWhistleSound()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.startMatch()
        }
    }
    
    func timerHand() {
        let handwatchHeight = ((5 * (2 * (UIScreen.main.bounds.height / 12))) / 6 )
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: handwatchHeight / 2 + 1.5 ,y: UIScreen.main.bounds.height - (handwatchHeight / 2) + 3), radius: CGFloat(45), startAngle: CGFloat(-Double.pi/2), endAngle:CGFloat(Double.pi/5 ), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        //change the fill color
        shapeLayer.fillColor = UIColor.red.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.red.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        circlePath.fill()
        self.view.layer.addSublayer(shapeLayer)
    }
    
    
    var currentQuestion = 0
    var correctAnswer = Int()
    var Score = Int()
    func startMatch() {
        beforeStartView.isHidden = true
        beforeStartCountDown.isHidden = true
        beforeStartTitle.isHidden = true
        scoreLabel.text = "امتیاز شما : \(Score) از ۴"
            DispatchQueue.main.async {
                musicPlay().playQuizeMusic()
            }
        timerHand()
        correctAnswer = (self.res?.response?[currentQuestion].ans_correct_id!)!
        showQuestion(questionTitle: "\((self.res?.response?[currentQuestion].title!)!)", answer1: "\((self.res?.response?[currentQuestion].ans_json?.ans_1!)!)", answer2: "\((self.res?.response?[currentQuestion].ans_json?.ans_2!)!)", answer3: "\((self.res?.response?[currentQuestion].ans_json?.ans_3!)!)", answer4: "\((self.res?.response?[currentQuestion].ans_json?.ans_4!)!)", correctAnswer: (self.res?.response?[currentQuestion].ans_correct_id!)!)
    }
    
    
    func showQuestion(questionTitle : String , answer1 : String , answer2 : String , answer3 : String , answer4 : String , correctAnswer : Int ) {
        self.questionTitle.text = questionTitle
        self.answer1Outlet.setTitle(answer1, for: .normal)
        self.answer2Outlet.setTitle(answer2, for: .normal)
        self.answer3Outlet.setTitle(answer3, for: .normal)
        self.answer4Outlet.setTitle(answer4, for: .normal)
        UIView.animate(withDuration: 0.8) {
            self.questionTitleConstraint.constant = UIScreen.main.bounds.height / 11 + 30
            self.answer1Constraint.constant = UIScreen.main.bounds.width / 10 - 5
            self.answer3Constraint.constant = UIScreen.main.bounds.width / 10 - 5
            self.answer2Constraint.constant = UIScreen.main.bounds.width / 10 - 5
            self.answer4Constraint.constant = UIScreen.main.bounds.width / 10 - 5
            self.view.layoutIfNeeded()
        }
        currentQuestion = currentQuestion + 1
    }
    
    
    func hideQuestion() {
        UIView.animate(withDuration: 0.8) {
            self.questionTitleConstraint.constant = -((UIScreen.main.bounds.height / 3) + 50)
            self.answer1Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5) + 30)
            self.answer3Constraint.constant = -((2 * UIScreen.main.bounds.width / 5) + 30)
            self.answer2Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5 ) + 30)
            self.answer4Constraint.constant = -((2 * UIScreen.main.bounds.width / 5 ) + 30)
            self.view.layoutIfNeeded()
        }
        if currentQuestion < 4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                self.answer1Outlet.setBackgroundImage(publicImages().normalAnswerImage, for: .normal)
                self.answer2Outlet.setBackgroundImage(publicImages().normalAnswerImage, for: .normal)
                self.answer3Outlet.setBackgroundImage(publicImages().normalAnswerImage, for: .normal)
                self.answer4Outlet.setBackgroundImage(publicImages().normalAnswerImage, for: .normal)
                self.correctAnswer = (self.res?.response?[self.currentQuestion].ans_correct_id!)!
                self.showQuestion(questionTitle: "\((self.res?.response?[self.currentQuestion].title!)!)", answer1: "\((self.res?.response?[self.currentQuestion].ans_json?.ans_1!)!)", answer2: "\((self.res?.response?[self.currentQuestion].ans_json?.ans_2!)!)", answer3: "\((self.res?.response?[self.currentQuestion].ans_json?.ans_3!)!)", answer4: "\((self.res?.response?[self.currentQuestion].ans_json?.ans_4!)!)", correctAnswer: (self.res?.response?[self.currentQuestion].ans_correct_id!)!)
            })
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func answer1Action(_ sender: RoundButton) {
        checkAnswer(answerSelectedIndex: 1)
    }
    
    @IBAction func answer2Action(_ sender: RoundButton) {
        checkAnswer(answerSelectedIndex: 2)
    }
    
    @IBAction func answer3Action(_ sender: RoundButton) {
        checkAnswer(answerSelectedIndex: 3)
    }
    
    @IBAction func answer4Action(_ sender: RoundButton) {
        checkAnswer(answerSelectedIndex: 4)
    }
    
    func checkAnswer(answerSelectedIndex : Int) {
        if answerSelectedIndex == correctAnswer {
            soundPlay().playCorrectAnswerSound()
            Score = Score + 1
            balls[currentQuestion - 1] = 1
            ballCheck()
            switch answerSelectedIndex {
            case 1:
                self.answer1Outlet.setBackgroundImage(publicImages().correctAnswerImage, for: .normal)
            case 2:
                self.answer2Outlet.setBackgroundImage(publicImages().correctAnswerImage, for: .normal)
            case 3:
                self.answer3Outlet.setBackgroundImage(publicImages().correctAnswerImage, for: .normal)
            default :
               self.answer4Outlet.setBackgroundImage(publicImages().correctAnswerImage, for: .normal)
            }
        } else {
            soundPlay().playWrongAnswerSound()
            balls[currentQuestion - 1] = 0
            ballCheck()
            switch answerSelectedIndex {
            case 1:
                self.answer1Outlet.setBackgroundImage(publicImages().wrongAnswerImage, for: .normal)
            case 2:
                self.answer2Outlet.setBackgroundImage(publicImages().wrongAnswerImage, for: .normal)
            case 3:
                self.answer3Outlet.setBackgroundImage(publicImages().wrongAnswerImage, for: .normal)
            default :
                self.answer4Outlet.setBackgroundImage(publicImages().wrongAnswerImage, for: .normal)
            }
            
            switch correctAnswer {
            case 1:
                self.answer1Outlet.setBackgroundImage(publicImages().correctAnswerImage, for: .normal)
            case 2:
                self.answer2Outlet.setBackgroundImage(publicImages().correctAnswerImage, for: .normal)
            case 3:
                self.answer3Outlet.setBackgroundImage(publicImages().correctAnswerImage, for: .normal)
            default :
                self.answer4Outlet.setBackgroundImage(publicImages().correctAnswerImage, for: .normal)
            }
        }
        
        scoreLabel.text = "امتیاز شما : \(Score) از ۴"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hideQuestion()
        }
    }
    
    var balls = [2,2,2,2]

    func ballCheck() {
        for i in 0...3 {
        switch balls[i] {
        case 0:
            switch i {
            case 0:
                question1Ball.image = publicImages().redBall
            case 1:
                question2Ball.image = publicImages().redBall
            case 2 :
                question3Ball.image = publicImages().redBall
            default :
                question4Ball.image = publicImages().redBall
            }
        case 1:
            switch i {
            case 0:
                question1Ball.image = publicImages().greenBall
            case 1:
                question2Ball.image = publicImages().greenBall
            case 2 :
                question3Ball.image = publicImages().greenBall
            default :
                question4Ball.image = publicImages().greenBall
            }
        default:
            switch i {
            case 0:
                question1Ball.image = publicImages().emptyImage
            case 1:
                question2Ball.image = publicImages().emptyImage
            case 2 :
                question3Ball.image = publicImages().emptyImage
            default :
                question4Ball.image = publicImages().emptyImage
                    }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
