//
//  mainMatchFieldViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import RPCircularProgress
import KBImageView
import Kingfisher

class mainMatchFieldViewController: UIViewController  {

    
    
    var matchData : matchDetails.Response? = nil;

    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var backGroundStadium: KBImageView!
    
    @IBOutlet weak var imageQuestionTitle: UILabel!
    
    @IBOutlet weak var imageQuestion: UIImageView!
    
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var watchTimerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var watchView: RPCircularProgress!
    
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
    
    @objc func UpdateTimer(notification: Notification){
        if startGame == true {
        let calendar = NSCalendar.current
        var compos:Set<Calendar.Component> = Set<Calendar.Component>()
        compos.insert(.second)
        compos.insert(.minute)
        let difference = calendar.dateComponents(compos, from: startDate, to: currentDate)
            
//        print("diff in minute=\(difference.minute!)") // difference in minute
//        print("diff in seconds=\(difference.second!)") // difference in seconds
            
        if difference.second! > 0 {
            for _ in 0...difference.second! - 1 {
            time = time + 0.0165
            timerCount = timerCount + 1
            }
       
        } else if difference.second! < 0 {
            if self.checkFinishGame == false {
            DispatchQueue.main.async {
                musicPlay().playQuizeMusic()
                self.view.isUserInteractionEnabled = false
                self.performSegue(withIdentifier: "gameOver", sender: self)
                NotificationCenter.default.post(name: Notification.Name("reloadGameData"), object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.view.isUserInteractionEnabled = true
                })
                soundPlay().playEndGameSound()
                self.checkFinishGame = true
                self.gameTimer.invalidate()
                self.watchView.updateProgress(75)
                self.timerLabel.text = "45"
          
                }
              }
            }
         if timerCount >= 45 && checkFinishGame == false {
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.async {
                musicPlay().playQuizeMusic()
                self.performSegue(withIdentifier: "gameOver", sender: self)
                NotificationCenter.default.post(name: Notification.Name("reloadGameData"), object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.view.isUserInteractionEnabled = true
                })
                soundPlay().playEndGameSound()
                self.checkFinishGame = true
            }
        }
        startDate = Date()
        }
    }

    
    var checkFinishGame = false
    var stadiumUrl = urls()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        backGroundStadium.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)

        let url = "\(stadiumUrl.stadium)anfield.jpg"
        let urls = URL(string: url)
        backGroundStadium.kf.setImage(with: urls)
//        print(url)
        backGroundStadium.timer.tolerance = 0.1
        
        
        self.questionTitle.adjustsFontSizeToFitWidth = true
        self.questionTitle.minimumScaleFactor = 0.5
        
        self.imageQuestionTitle.text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateTimer(notification:)), name: Notification.Name("updateTimer"), object: nil)

        lastVC.dismiss(animated: true, completion: nil)
        question1Ball.image = publicImages().emptyImage
        question2Ball.image = publicImages().emptyImage
        question3Ball.image = publicImages().emptyImage
        question4Ball.image = publicImages().emptyImage

        self.timerLabel.text = ""
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.bounds.width == 320 {
                //4 inch iPhones or smaller
                watchTimerConstraint.constant = 6
            } else {
                if UIScreen.main.nativeBounds.height == 2436 {
                    //iPhonex
                    watchTimerConstraint.constant = 8
                } else {
                    // other iPhones
                    watchTimerConstraint.constant = 7
                }
            }
        } else {
            //iPad
            watchTimerConstraint.constant = 11
        }
        
        scoreLabel.text = ""
        beforeStartCountDown.text = ""
        beforeStartTitle.text = ""
        beforeStartTitle.adjustsFontSizeToFitWidth = true
        beforeStartTitle.minimumScaleFactor = 0.5
        
        if UIDevice().userInterfaceIdiom == .phone {
            topViewTopConstraint.constant = -300
            bottomViewBottomConstraint.constant = 300
            if UIScreen.main.nativeBounds.height == 2436 {
                
                //iPhone X
                questionsTopConstraint.constant = 450
                questionTitleConstraint.constant = -((UIScreen.main.bounds.height / 3) + 50)
                self.answer1Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5) + 30)
                self.answer3Constraint.constant = -((2 * UIScreen.main.bounds.width / 5) + 30)
                self.answer2Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5 ) + 30)
                self.answer4Constraint.constant = -((2 * UIScreen.main.bounds.width / 5 ) + 30)
                
            } else {
                
                //Other iPhones
//                questionsTopConstraint.constant = (UIScreen.main.bounds.height / 3) + 50
                questionsTopConstraint.constant = (UIScreen.main.bounds.height / 3) + (UIScreen.main.bounds.height / 11) + 50
                questionTitleConstraint.constant = -((UIScreen.main.bounds.height / 3) + 50)
                self.answer1Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5) + 30)
                self.answer3Constraint.constant = -((2 * UIScreen.main.bounds.width / 5) + 30)
                self.answer2Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5 ) + 30)
                self.answer4Constraint.constant = -((2 * UIScreen.main.bounds.width / 5 ) + 30)
            }
            
        } else {
            topViewTopConstraint.constant = -600
            bottomViewBottomConstraint.constant = 600
            //iPad
            questionsTopConstraint.constant = (UIScreen.main.bounds.height / 8) + 430
            questionTitleConstraint.constant = -((UIScreen.main.bounds.height / 3) + 50)
            self.answer1Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5) + 30)
            self.answer3Constraint.constant = -((2 * UIScreen.main.bounds.width / 5) + 30)
            self.answer2Constraint.constant =  -((2 * UIScreen.main.bounds.width / 5 ) + 30)
            self.answer4Constraint.constant = -((2 * UIScreen.main.bounds.width / 5 ) + 30)
        }
        
        
        readMatchData()
    }
    
    var res : questionsList.Response? = nil;
    
    func readMatchData() {
        //match Data Json
        PubProc.HandleDataBase.readJson(wsName: "ws_getQuestionData", JSONStr: "{'level':'\(level)','category':'\(category)','last_questions':'','userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    do {
                        
                        self.res = try JSONDecoder().decode(questionsList.Response.self , from : data!)
                        
                        print("questionsIDs = Q1:\((self.res?.response?[0].id!)!) - Q2:\((self.res?.response?[1].id!)!) - Q3:\((self.res?.response?[2].id!)!) - Q4:\((self.res?.response?[3].id!)!)")
                        
                        DispatchQueue.main.async {
                            self.restMatchFunction()
                        }
                        
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
        updateGameResault()
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
    
    var timerCount = -1
    let AlertState = "matchField"
    var startDate = Date()
    var currentDate = Date()
    var startGame = false
    
    
    @objc func updateWatch() {
        startGame = true
        currentDate = Date()
        time = time + 0.0165
        timerCount = timerCount + 1
        watchView.progressTintColor = .init(red: 222/255, green: 100/255, blue: 1/255, alpha: 1.0)
        watchView.updateProgress(time)
        watchView.thicknessRatio = 10
        watchView.roundedCorners = false
        
        if timerCount > 0 {
            if timerCount == 41 {
                thirdSoundPlay().playThirdSound()
            }
        if timerCount == 45 {
             if self.checkFinishGame == false {
            checkFinishGame = true
            DispatchQueue.main.async {
                musicPlay().playQuizeMusic()
                self.view.isUserInteractionEnabled = false
                self.performSegue(withIdentifier: "gameOver", sender: self)
                NotificationCenter.default.post(name: Notification.Name("reloadGameData"), object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.view.isUserInteractionEnabled = true
                })
                soundPlay().playEndGameSound()
                }
            }
        }
            if timerCount > 45 {
                self.timerLabel.text = "45"
            } else {
            self.timerLabel.text = "\(timerCount)"
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let VC = segue.destination as? menuAlertViewController {
            self.watchView.updateProgress(75)
            self.timerLabel.text = "45"
            VC.alertTitle = "اخطار"
            VC.alertBody = "وقت تمام شد"
            VC.alertAcceptLabel = "تأیید"
            VC.alertState = AlertState
            VC.matchField = self
        }
    }
    
    
    var time : CGFloat = 0
    var gameTimer : Timer!
    
    func timerHand() {
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateWatch), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 50) {
            self.gameTimer.invalidate()
        }
    }

    
    var currentQuestion = 0
    var correctAnswer = Int()
    var Score = Int()
    
    func startMatch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 45) {
            if self.checkFinishGame == false {
                self.gameTimer.invalidate()
                self.checkFinishGame = true
                DispatchQueue.main.async {
                    musicPlay().playQuizeMusic()
                    self.view.isUserInteractionEnabled = false
                    self.performSegue(withIdentifier: "gameOver", sender: self)
                    NotificationCenter.default.post(name: Notification.Name("reloadGameData"), object: nil)
                    soundPlay().playEndGameSound()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.view.isUserInteractionEnabled = true
                    })
                }
            }
        }
        startDate = Date()
        UIView.animate(withDuration: 0.5) {
            self.topViewTopConstraint.constant = 0
            self.bottomViewBottomConstraint.constant = 0
        }
        
        beforeStartView.isHidden = true
        beforeStartCountDown.isHidden = true
        beforeStartTitle.isHidden = true
        scoreLabel.text = "امتیاز شما : \(Score) از ۴"
            DispatchQueue.main.async {
                musicPlay().playQuizeMusic()
            }
        timerHand()
        
        correctAnswer = (self.res?.response?[currentQuestion].ans_correct_id!)!
        var questionImage = String()
        if self.res?.response?[currentQuestion].q_image != nil {
           questionImage = (self.res?.response?[currentQuestion].q_image!)!
        } else {
            questionImage = ""
        }
        showQuestion(questionTitle: "\((self.res?.response?[currentQuestion].title!)!)", answer1: "\((self.res?.response?[currentQuestion].ans_json?.ans_1!)!)", answer2: "\((self.res?.response?[currentQuestion].ans_json?.ans_2!)!)", answer3: "\((self.res?.response?[currentQuestion].ans_json?.ans_3!)!)", answer4: "\((self.res?.response?[currentQuestion].ans_json?.ans_4!)!)", correctAnswer: (self.res?.response?[currentQuestion].ans_correct_id!)!, questionImage: "\(questionImage)")
    }
    
    func showQuestion(questionTitle : String , answer1 : String , answer2 : String , answer3 : String , answer4 : String , correctAnswer : Int , questionImage : String) {
        if questionImage != "" {
            self.questionTitle.text = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.imageQuestionTitle.text = questionTitle
            }
            self.imageQuestionTitle.isHidden = false
        } else {
            self.questionTitle.text = questionTitle
            self.imageQuestionTitle.text = ""
            self.imageQuestionTitle.isHidden = true
        }
        
        DisableEnableInterFace(State : true)
        
        self.answer1Outlet.setTitle(answer1, for: .normal)
        self.answer2Outlet.setTitle(answer2, for: .normal)
        self.answer3Outlet.setTitle(answer3, for: .normal)
        self.answer4Outlet.setTitle(answer4, for: .normal)
        
        self.answer1Outlet.titleLabel?.adjustsFontSizeToFitWidth = true
        self.answer2Outlet.titleLabel?.adjustsFontSizeToFitWidth = true
        self.answer3Outlet.titleLabel?.adjustsFontSizeToFitWidth = true
        self.answer4Outlet.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.answer1Outlet.titleLabel?.minimumScaleFactor = 0.5
        self.answer2Outlet.titleLabel?.minimumScaleFactor = 0.5
        self.answer3Outlet.titleLabel?.minimumScaleFactor = 0.5
        self.answer4Outlet.titleLabel?.minimumScaleFactor = 0.5
        
        
        let dataDecoded:NSData = NSData(base64Encoded: questionImage , options: NSData.Base64DecodingOptions(rawValue: 0))!
        self.imageQuestion.image = UIImage(data: dataDecoded as Data)
        UIView.animate(withDuration: 0.8) {
            if UIDevice().userInterfaceIdiom == .phone {
                if UIScreen.main.nativeBounds.height == 2436 {
                    //iPhone X
                    self.questionTitleConstraint.constant = UIScreen.main.bounds.height / 8 + 70
                    self.answer1Constraint.constant = UIScreen.main.bounds.width / 10 - 5
                    self.answer3Constraint.constant = UIScreen.main.bounds.width / 10 - 5
                    self.answer2Constraint.constant = UIScreen.main.bounds.width / 10 - 5
                    self.answer4Constraint.constant = UIScreen.main.bounds.width / 10 - 5
                    self.view.layoutIfNeeded()
                    
                } else {
                    
                    //Other iPhones
                    self.questionTitleConstraint.constant = UIScreen.main.bounds.height / 11 + 35
                    self.answer1Constraint.constant = UIScreen.main.bounds.width / 10 - 5
                    self.answer3Constraint.constant = UIScreen.main.bounds.width / 10 - 5
                    self.answer2Constraint.constant = UIScreen.main.bounds.width / 10 - 5
                    self.answer4Constraint.constant = UIScreen.main.bounds.width / 10 - 5
                    self.view.layoutIfNeeded()
                    
                    
                }
            } else {
                
                //iPad
                
                self.questionTitleConstraint.constant = UIScreen.main.bounds.height / 8 + 80
                self.answer1Constraint.constant = UIScreen.main.bounds.width / 2 - 190
                self.answer3Constraint.constant = UIScreen.main.bounds.width / 2 - 190
                self.answer2Constraint.constant = UIScreen.main.bounds.width / 2 - 190
                self.answer4Constraint.constant = UIScreen.main.bounds.width / 2 - 190
                self.view.layoutIfNeeded()
                
            }

        }
        currentQuestion = currentQuestion + 1
    }
    
    func hideQuestion() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        self.imageQuestionTitle.text = " "
        }
        let doubleCheckTimer : CGFloat = time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.currentQuestion < 3 &&  doubleCheckTimer == self.time {
                    self.time = self.time + 0.0165
                    self.timerCount = self.timerCount + 1
                if self.timerCount >= 45 {
                    if self.checkFinishGame == false {
                    self.checkFinishGame = true
                    self.view.isUserInteractionEnabled = false
                    DispatchQueue.main.async {
                        if musicPlay.musicPlayer?.isPlaying == true {
                            musicPlay().playQuizeMusic()
                        } else {}
                        self.performSegue(withIdentifier: "gameOver", sender: self)
                        NotificationCenter.default.post(name: Notification.Name("reloadGameData"), object: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            self.view.isUserInteractionEnabled = true
                        })
                        soundPlay().playEndGameSound()
                        }
                    }
                } else {
                    if musicPlay.musicPlayer?.isPlaying == true {
                    } else {musicPlay().playQuizeMusic()}
                self.gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateWatch), userInfo: nil, repeats: true)
                }
            }
        }
        
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
                var questionImage = String()
                if self.res?.response?[self.currentQuestion].q_image != nil {
                    questionImage = (self.res?.response?[self.currentQuestion].q_image!)!
                } else {
                    questionImage = ""
                }
                
                self.showQuestion(questionTitle: "\((self.res?.response?[self.currentQuestion].title!)!)", answer1: "\((self.res?.response?[self.currentQuestion].ans_json?.ans_1!)!)", answer2: "\((self.res?.response?[self.currentQuestion].ans_json?.ans_2!)!)", answer3: "\((self.res?.response?[self.currentQuestion].ans_json?.ans_3!)!)", answer4: "\((self.res?.response?[self.currentQuestion].ans_json?.ans_4!)!)", correctAnswer: (self.res?.response?[self.currentQuestion].ans_correct_id!)!, questionImage: "\(questionImage)")
            })
        } else {
            if self.checkFinishGame == false {
            self.checkFinishGame = true
            musicPlay().playQuizeMusic()
            self.gameTimer.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                musicPlay().playMenuMusic()
            }
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("reloadGameData"), object: nil)
        }
        }
    }
    
    
    @objc func DisableEnableInterFace(State : Bool) {
        self.answer1Outlet.isUserInteractionEnabled = State
        self.answer2Outlet.isUserInteractionEnabled = State
        self.answer3Outlet.isUserInteractionEnabled = State
        self.answer4Outlet.isUserInteractionEnabled = State
    }
    
    
    @IBAction func answer1Action(_ sender: RoundButton) {
        checkAnswer(answerSelectedIndex: 1)
        DisableEnableInterFace(State : false)
    }
    
    @IBAction func answer2Action(_ sender: RoundButton) {
        checkAnswer(answerSelectedIndex: 2)
        DisableEnableInterFace(State : false)
    }
    
    @IBAction func answer3Action(_ sender: RoundButton) {
        checkAnswer(answerSelectedIndex: 3)
        DisableEnableInterFace(State : false)
    }
    
    @IBAction func answer4Action(_ sender: RoundButton) {
        checkAnswer(answerSelectedIndex: 4)
        DisableEnableInterFace(State : false)
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
    let defaults = UserDefaults.standard
    func ballCheck() {
        for i in 0...3 {
        switch balls[i] {
        case 0:
            switch i {
            case 0:
                UIView.transition(with: question1Ball,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { self.question1Ball.image = publicImages().redBall },
                                  completion: nil)
            case 1:
                UIView.transition(with: question2Ball,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { self.question2Ball.image = publicImages().redBall },
                                  completion: nil)
            case 2 :
                UIView.transition(with: question3Ball,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { self.question3Ball.image = publicImages().redBall },
                                  completion: nil)
            default :
                UIView.transition(with: question4Ball,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: { self.question4Ball.image = publicImages().redBall },
                                  completion: nil)
            }
        case 1:
            switch i {
            case 0:
                UIView.transition(with: question1Ball,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { self.question1Ball.image = publicImages().greenBall },
                                  completion: nil)
            case 1:
                UIView.transition(with: question2Ball,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { self.question2Ball.image = publicImages().greenBall },
                                  completion: nil)
            case 2 :
                UIView.transition(with: question3Ball,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { self.question3Ball.image = publicImages().greenBall },
                                  completion: nil)
            default :
                UIView.transition(with: question4Ball,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: { self.question4Ball.image = publicImages().greenBall },
                                  completion: nil)
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
        updateGameResault()
    }
    
    
    
    func updateGameResault() {
        var storeArray = [Int]()
        for i in 0...3 {
            if balls[i] == 2 {
                storeArray.append(0)
            } else {
                storeArray.append(balls[i])
            }
        }
        
        var playerSide = String()
        var playerReault = Int()
        
        if ((matchData?.response?.isYourTurn!)!) == true {
            playerSide = "1"
        } else {
            playerSide = "2"
        }
        
        playerReault = storeArray.filter{$0 == 1}.count
        
        let gameArray = "{'mode':'UPDT_GAME_RESULT','is_home':'\(((matchData?.response?.isYourTurn!)!))','match_id':\(((matchData?.response?.matchData?.id!)!)),'game_type':\(self.category),'last_questions':'\((self.res?.response?[0].id!)!),\((self.res?.response?[1].id!)!),\((self.res?.response?[2].id!)!),\((self.res?.response?[3].id!)!)','player\(playerSide)_result':\(playerReault),'player\(playerSide)_result_sheet':'{\\'ans_1\\':\(storeArray[0]),\\'ans_2\\':\(storeArray[1]),\\'ans_3\\':\(storeArray[2]),\\'ans_4\\':\(storeArray[3])}'}"
        
        
        
        defaults.set(gameArray, forKey: "gameLeft")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
