//
//  clanMatchFieldViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import KBImageView
import RealmSwift

class clanMatchFieldViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var delegate : clanMatchFieldViewControllerDelegate!
    
    var realm : Realm!
    
    @IBOutlet weak var bomb: RoundButton!
    
    @IBOutlet weak var freezTimer: RoundButton!
    
    @IBOutlet weak var beforeStartView: UIView!
    
    @IBOutlet weak var beforeStartCountDown: UILabel!
    
    @IBOutlet weak var beforeStartTitle: UILabel!
    
    @IBOutlet weak var beforeStartStackView: UIStackView!
    
    @IBOutlet weak var imageQuestionTitle: UILabel!
    
    @IBOutlet weak var imageQuestion: UIImageView!
    
    @IBOutlet weak var questionTitle: UILabel!
    
    @IBOutlet weak var answer1Outlet: UIButton!
    
    @IBOutlet weak var answer2Outlet: UIButton!
    
    @IBOutlet weak var answer3Outlet: UIButton!
    
    @IBOutlet weak var answer4Outlet: UIButton!
    
    @IBOutlet weak var answer1Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer2Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer3Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var answer4Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var questionsTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var questionTitleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scoreCV: UICollectionView!
    
    @IBOutlet weak var backGroundStadiumImage: KBImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var warQuestions : warQuestions.Response? = nil 
    
    var answers = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scoreCV.register(UINib(nibName: "scoreBallCell", bundle: nil), forCellWithReuseIdentifier: "scoreBallCell")
        
        realm = try? Realm()
        setBackGroundImage()
        for _ in 0...(self.warQuestions?.response.count)! - 1 {
            self.answers.append(0)
        }
        
        DispatchQueue.main.async {
            self.scoreCV.reloadData()
        }
        
        setExclusiveTouches()
        
        self.imageQuestionTitle.text = ""
        
        self.questionTitle.adjustsFontSizeToFitWidth = true
        self.questionTitle.minimumScaleFactor = 0.5
        
        beforeStartCountDown.text = ""
        beforeStartTitle.text = ""
        beforeStartTitle.adjustsFontSizeToFitWidth = true
        beforeStartTitle.minimumScaleFactor = 0.5
        
        setConstraints()
        setButtonsActions()
        checkBombandFreeze()
        countingTime()
        
    }
    
    var time = Float()
    func countingTime() {
        self.time = Float((self.warQuestions?.response.count)! * (loadingViewController.loadGameData?.response?.warQuestionTime!)!)
    }
    
    @objc func checkBombandFreeze() {
        if Int(((login.res?.response?.mainInfo?.bomb)!)!)! > 0 {
        } else {
            disabledBomb()
            self.bomb.isUserInteractionEnabled = false
        }
        if Int(((login.res?.response?.mainInfo?.freeze)!)!)! > 0 {
        } else {
            disabledFreezeTimer()
            self.freezTimer.isUserInteractionEnabled = false
        }
    }
    
    
    @objc func disabledBomb() {
        self.bomb.setImage(publicImages().bomb!.noir(), for: UIControlState.normal)
    }
    
    @objc func disabledFreezeTimer() {
        self.freezTimer.setImage(publicImages().freezeTimer!.noir(), for: UIControlState.normal)
        
    }
    
    @objc func setButtonsActions() {
        self.answer1Outlet.addTarget(self, action: #selector(answer1Action), for: .touchUpInside)
        self.answer2Outlet.addTarget(self, action: #selector(answer2Action), for: .touchUpInside)
        self.answer3Outlet.addTarget(self, action: #selector(answer3Action), for: .touchUpInside)
        self.answer4Outlet.addTarget(self, action: #selector(answer4Action), for: .touchUpInside)
        self.bomb.addTarget(self, action: #selector(bombAction), for: UIControlEvents.touchUpInside)
        self.freezTimer.addTarget(self, action: #selector(freezAction), for: UIControlEvents.touchUpInside)
    }
    
    var isBombUsed = Bool()
    
    @objc func bombAction() {
        self.bomb.isUserInteractionEnabled = false
        disabledBomb()
        self.isBombUsed = true
        if (self.warQuestions?.response[self.currentQuestion].ans_correct_id!)! == 1 ||  (self.warQuestions?.response[self.currentQuestion].ans_correct_id!)! == 4 {
            
            self.answer2Outlet.isUserInteractionEnabled = false
            self.answer3Outlet.isUserInteractionEnabled = false
            self.answer2Outlet.setBackgroundImage(publicImages().wrongAnswerImage, for: .normal)
            self.answer3Outlet.setBackgroundImage(publicImages().wrongAnswerImage, for: .normal)
            
        } else {
            
            self.answer1Outlet.isUserInteractionEnabled = false
            self.answer4Outlet.isUserInteractionEnabled = false
            self.answer1Outlet.setBackgroundImage(publicImages().wrongAnswerImage, for: .normal)
            self.answer4Outlet.setBackgroundImage(publicImages().wrongAnswerImage, for: .normal)
        }
        
        //             PubProc.HandleDataBase.readJson(wsName: "ws_handleCheats", JSONStr: "{'cheat_type':'WAR_BOMB','userid':'\(loadingViewController.userid)'}") { data, error in
        //
        //                if data != nil {
        //
        //                    DispatchQueue.main.async {
        //                        PubProc.cV.hideWarning()
        //                    }
        //
        //                    //                print(data ?? "")
        //
        //
        //                    DispatchQueue.main.async {
        //                        PubProc.wb.hideWaiting()
        //                    }
        //
        //                } else {
        //                    self.bombAction()
        //                    print("Error Connection")
        //                    print(error as Any)
        //                    // handle error
        //                }
        //                }.resume()
        
    }
    
    var isFreez = Bool()
    
    @objc func freezAction() {
        self.freezTimer.isUserInteractionEnabled = false
        disabledFreezeTimer()
        self.isFreez = true
        self.gameTimer.invalidate()
        nukeAllAnimations()
        //            PubProc.HandleDataBase.readJson(wsName: "ws_handleCheats", JSONStr: "{'cheat_type':'WAR_FREEZE','userid':'\(loadingViewController.userid)'}") { data, error in
        //
        //                if data != nil {
        //
        //                    DispatchQueue.main.async {
        //                        PubProc.cV.hideWarning()
        //                    }
        //
        //                    //                print(data ?? "")
        //
        //                    DispatchQueue.main.async {
        //                        PubProc.wb.hideWaiting()
        //                    }
        //
        //                } else {
        //                    self.freezAction()
        //                    print("Error Connection")
        //                    print(error as Any)
        //                    // handle error
        //                }
        //                }.resume()
    }
    
    
    @objc func answer1Action() {
        checkAnswer(answerSelectedIndex: 1)
        DisableEnableInterFace(State : false)
    }
    
    @objc func answer2Action() {
        checkAnswer(answerSelectedIndex: 2)
        DisableEnableInterFace(State : false)
    }
    
    @objc func answer3Action() {
        checkAnswer(answerSelectedIndex: 3)
        DisableEnableInterFace(State : false)
    }
    
    @objc func answer4Action() {
        checkAnswer(answerSelectedIndex: 4)
        DisableEnableInterFace(State : false)
    }
    
    func checkAnswer(answerSelectedIndex : Int) {
        self.currentQuestion = self.currentQuestion + 1
        if answerSelectedIndex == correctAnswer {
            self.answers[self.currentQuestion - 1] = 2
            UIView.animate(withDuration: 0.3) {
                DispatchQueue.main.async {
                    self.scoreCV.reloadData()
                }
            }
            soundPlay().playCorrectAnswerSound()
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
            self.answers[self.currentQuestion - 1] = 1
            UIView.animate(withDuration: 0.3) {
                DispatchQueue.main.async {
                    self.scoreCV.reloadData()
                }
            }
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hideQuestion()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        beforeMatchTimer()
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
            self.restMatchFunction()
        }
    }
    
    func restMatchFunction() {
        if musicPlay.musicPlayer?.isPlaying == true {
            musicPlay().playMenuMusic()
        } else {}
        
    }
    
    var currentQuestion = 0
    var correctAnswer = Int()
    
    func startMatch() {
        UIView.animate(withDuration: 0.5) {
            self.topViewTopConstraint.constant = 0
            self.bottomViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
        beforeStartView.isHidden = true
        beforeStartCountDown.isHidden = true
        beforeStartTitle.isHidden = true
        beforeStartStackView.isHidden = true
        DispatchQueue.main.async {
            musicPlay().playQuizeMusic()
        }
        
        var questionImage = String()
        if (self.warQuestions?.response[self.currentQuestion].q_image!)! != "" {
            questionImage = (self.warQuestions?.response[self.currentQuestion].q_image!)!
        } else {
            questionImage = ""
        }
        showQuestion(questionTitle: "\((self.warQuestions?.response[self.currentQuestion].title!)!)", answer1: "\((self.warQuestions?.response[self.currentQuestion].ans_json?.ans_1!)!)", answer2: "\((self.warQuestions?.response[self.currentQuestion].ans_json?.ans_2!)!)", answer3: "\((self.warQuestions?.response[self.currentQuestion].ans_json?.ans_3!)!)", answer4: "\((self.warQuestions?.response[self.currentQuestion].ans_json?.ans_4!)!)", correctAnswer: (self.warQuestions?.response[self.currentQuestion].ans_correct_id!)!, questionImage: "\(questionImage)")
        
        timerHand()
        self.progressBar.progress = 1
        updateProgressBar(currentTime: Float((self.warQuestions?.response.count)! * (loadingViewController.loadGameData?.response?.warQuestionTime!)!))
    }
    
    @objc func updateProgressBar(currentTime : Float) {
        UIView.animate(withDuration: TimeInterval(currentTime), animations: { () -> Void in
            self.progressBar.setProgress(0, animated: true)
        })
    }
    
    var isStopedAnimations = Bool()
    func nukeAllAnimations() {
        self.isStopedAnimations = true
        self.progressBar.subviews.forEach({$0.layer.removeAllAnimations()})
        
        self.progressBar.progress = 1
    }
    
    var gameTimer : Timer!
    
    func timerHand() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func UpdateTimer() {
        self.time = self.time - 1
        if self.time == 0 {
            self.checkFinishGame = true
        }
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
        
        self.correctAnswer = (self.warQuestions?.response[self.currentQuestion].ans_correct_id!)!
        
        let dataDecoded:NSData = NSData(base64Encoded: questionImage , options: NSData.Base64DecodingOptions(rawValue: 0))!
        self.imageQuestion.image = UIImage(data: dataDecoded as Data)
        UIView.animate(withDuration: 0.8) {
            if !self.isBombUsed {
                self.bomb.isUserInteractionEnabled = true
                self.bomb.isEnabled = true
            }
            if !self.isFreez {
                self.freezTimer.isUserInteractionEnabled = true
            }
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
        if !self.isBombUsed {
            self.bomb.isUserInteractionEnabled = true
        }
        if !self.isFreez {
            self.freezTimer.isUserInteractionEnabled = true
        }
    }
    
    var checkFinishGame = Bool()
    func hideQuestion() {
        if self.isFreez {
            gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        }
        
        if self.isStopedAnimations {
            self.isStopedAnimations = false
            self.updateProgressBar(currentTime: self.time)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.imageQuestionTitle.text = " "
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.currentQuestion == (self.warQuestions?.response.count)! {
                if self.time  <= 0 {
                    if self.checkFinishGame == false {
                        self.checkFinishGame = true
                        self.view.isUserInteractionEnabled = false
                        DispatchQueue.main.async {
                            if musicPlay.musicPlayer?.isPlaying == true {
                                musicPlay().playQuizeMusic()
                            } else {}
                            self.DisableEnableInterFace(State : false)
                            self.performSegue(withIdentifier: "gameOver", sender: self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                self.view.isUserInteractionEnabled = true
                            })
                            soundPlay().playEndGameSound()
                        }
                    }
                } else {
                    if musicPlay.musicPlayer?.isPlaying == true {
                    } else {musicPlay().playQuizeMusic()}
                    self.gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.UpdateTimer), userInfo: nil, repeats: true)
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
        
        if self.currentQuestion < (self.warQuestions?.response.count)! {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                self.answer1Outlet.setBackgroundImage(publicImages().normalAnswerImage, for: .normal)
                self.answer2Outlet.setBackgroundImage(publicImages().normalAnswerImage, for: .normal)
                self.answer3Outlet.setBackgroundImage(publicImages().normalAnswerImage, for: .normal)
                self.answer4Outlet.setBackgroundImage(publicImages().normalAnswerImage, for: .normal)
                self.correctAnswer = (self.warQuestions?.response[self.currentQuestion].ans_correct_id!)!
                var questionImage = String()
                if self.warQuestions?.response[self.currentQuestion].q_image != nil {
                    questionImage = (self.warQuestions?.response[self.currentQuestion].q_image!)!
                } else {
                    questionImage = ""
                }
                
                self.showQuestion(questionTitle: "\((self.warQuestions?.response[self.currentQuestion].title!)!)", answer1: "\((self.warQuestions?.response[self.currentQuestion].ans_json?.ans_1!)!)", answer2: "\((self.warQuestions?.response[self.currentQuestion].ans_json?.ans_2!)!)", answer3: "\((self.warQuestions?.response[self.currentQuestion].ans_json?.ans_3!)!)", answer4: "\((self.warQuestions?.response[self.currentQuestion].ans_json?.ans_4!)!)", correctAnswer: (self.warQuestions?.response[self.currentQuestion].ans_correct_id!)!, questionImage: "\(questionImage)")
            })
        } else {
            if self.checkFinishGame == false {
                self.checkFinishGame = true
                musicPlay().playQuizeMusic()
                self.gameTimer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    musicPlay().playMenuMusic()
                }
                self.delegate?.updateAfterFinishGame()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func DisableEnableInterFace(State : Bool) {
        self.answer1Outlet.isUserInteractionEnabled = State
        self.answer2Outlet.isUserInteractionEnabled = State
        self.answer3Outlet.isUserInteractionEnabled = State
        self.answer4Outlet.isUserInteractionEnabled = State
        if !self.isBombUsed {
            self.bomb.isUserInteractionEnabled = State
        }
        if !self.isFreez {
            self.freezTimer.isUserInteractionEnabled = State
        }
    }
    
    @objc func setExclusiveTouches() {
        self.answer1Outlet.isExclusiveTouch = true
        self.answer2Outlet.isExclusiveTouch = true
        self.answer3Outlet.isExclusiveTouch = true
        self.answer4Outlet.isExclusiveTouch = true
        self.freezTimer.isExclusiveTouch = true
        self.bomb.isExclusiveTouch = true
    }
    
    @objc func setConstraints() {
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
    }
    
    @objc func setBackGroundImage() {
        let realmID = self.realm.objects(tblStadiums.self).filter("img_logo == '\(urls().stadium)\((login.res?.response?.mainInfo?.stadium!)!)'")
        if realmID.count != 0 {
            if realmID.first?.img_base64.count != 0 {
                let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                self.backGroundStadiumImage.image = UIImage(data: dataDecoded as Data)
            } else {
                self.backGroundStadiumImage.image = UIImage(named : "empty_std")
            }
        } else {
            self.backGroundStadiumImage.image = UIImage(named : "empty_std")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.warQuestions?.response.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "scoreBallCell" , for: indexPath) as! scoreBallCell
        
        switch answers[indexPath.row] {
        case 0 :
            cell.ballImage.image = publicImages().grayBall
        case 1 :
            cell.ballImage.image = publicImages().redBall
        case 2 :
            cell.ballImage.image = publicImages().greenBall
        default :
            cell.ballImage.image = UIImage()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / CGFloat((self.warQuestions?.response.count)!) , height: 45)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let VC = segue.destination as? menuAlertViewController {
            VC.alertTitle = "اخطار"
            VC.alertBody = "وقت تمام شد"
            VC.alertAcceptLabel = "تأیید"
            VC.alertState = "clanMatch"
        }
    }
    
}


//var timerCount = -1
//let AlertState = "matchField"
//var startDate = Date()
//var currentDate = Date()
//var startGame = false
//
//@objc func updateWatch() {
//    startGame = true
//    currentDate = Date()
//    time = time + 0.0165
//    timerCount = timerCount + 1
//    watchView.progressTintColor = .init(red: 222/255, green: 100/255, blue: 1/255, alpha: 1.0)
//    watchView.updateProgress(time)
//    watchView.thicknessRatio = 10
//    watchView.roundedCorners = false
//
//    if timerCount > 0 {
//        if timerCount == 41 {
//            thirdSoundPlay().playThirdSound()
//        }
//        if timerCount == 45 {
//            if self.checkFinishGame == false {
//                checkFinishGame = true
//                DispatchQueue.main.async {
//                    musicPlay().playQuizeMusic()
//                    self.view.isUserInteractionEnabled = false
//                    self.DisableEnableInterFace(State : false)
//                    PubProc.isSplash = false
//                    self.gameTimer.invalidate()
//                    self.performSegue(withIdentifier: "gameOver", sender: self)
//                    NotificationCenter.default.post(name: Notification.Name("reloadGameData"), object: nil)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                        self.view.isUserInteractionEnabled = true
//                    })
//                    soundPlay().playEndGameSound()
//                }
//            }
//        }
//        if timerCount > 45 {
//            self.timerLabel.text = "45"
//        } else {
//            self.timerLabel.text = "\(timerCount)"
//        }
//    }
//}
//
//var currentQuestion = 0
//var correctAnswer = Int()
//var Score = Int()
//
//
//
//}
//
//
//var balls = [2,2,2,2]
//let defaults = UserDefaults.standard
//func ballCheck() {
//    for i in 0...3 {
//        switch balls[i] {
//        case 0:
//            switch i {
//            case 0:
//                UIView.transition(with: question1Ball,
//                                  duration: 0.5,
//                                  options: .transitionCrossDissolve,
//                                  animations: { self.question1Ball.image = publicImages().redBall },
//                                  completion: nil)
//            case 1:
//                UIView.transition(with: question2Ball,
//                                  duration: 0.5,
//                                  options: .transitionCrossDissolve,
//                                  animations: { self.question2Ball.image = publicImages().redBall },
//                                  completion: nil)
//            case 2 :
//                UIView.transition(with: question3Ball,
//                                  duration: 0.5,
//                                  options: .transitionCrossDissolve,
//                                  animations: { self.question3Ball.image = publicImages().redBall },
//                                  completion: nil)
//            default :
//                UIView.transition(with: question4Ball,
//                                  duration: 0.3,
//                                  options: .transitionCrossDissolve,
//                                  animations: { self.question4Ball.image = publicImages().redBall },
//                                  completion: nil)
//            }
//        case 1:
//            switch i {
//            case 0:
//                UIView.transition(with: question1Ball,
//                                  duration: 0.5,
//                                  options: .transitionCrossDissolve,
//                                  animations: { self.question1Ball.image = publicImages().greenBall },
//                                  completion: nil)
//            case 1:
//                UIView.transition(with: question2Ball,
//                                  duration: 0.5,
//                                  options: .transitionCrossDissolve,
//                                  animations: { self.question2Ball.image = publicImages().greenBall },
//                                  completion: nil)
//            case 2 :
//                UIView.transition(with: question3Ball,
//                                  duration: 0.5,
//                                  options: .transitionCrossDissolve,
//                                  animations: { self.question3Ball.image = publicImages().greenBall },
//                                  completion: nil)
//            default :
//                UIView.transition(with: question4Ball,
//                                  duration: 0.3,
//                                  options: .transitionCrossDissolve,
//                                  animations: { self.question4Ball.image = publicImages().greenBall },
//                                  completion: nil)
//            }
//        default:
//            switch i {
//            case 0:
//                question1Ball.image = publicImages().emptyImage
//            case 1:
//                question2Ball.image = publicImages().emptyImage
//            case 2 :
//                question3Ball.image = publicImages().emptyImage
//            default :
//                question4Ball.image = publicImages().emptyImage
//            }
//        }
//    }
//    updateGameResault()
//}
//
//
//func updateGameResault() {
//    var storeArray = [Int]()
//    for i in 0...3 {
//        if balls[i] == 2 {
//            storeArray.append(0)
//        } else {
//            storeArray.append(balls[i])
//        }
//    }
//
//    var playerSide = String()
//    var playerReault = Int()
//
//
//
//    playerReault = storeArray.filter{$0 == 1}.count
//
//    let gameArray = "{'mode':'UPDT_GAME_RESULT','is_home':'\(self.isHome)','match_id':\(((matchData?.response?.matchData?.id!)!)),'game_type':\(self.category),'last_questions':'\((self.res?.response?[0].id!)!),\((self.res?.response?[1].id!)!),\((self.res?.response?[2].id!)!),\((self.res?.response?[3].id!)!)','player\(playerSide)_result':\(String(playerReault)),'player\(playerSide)_result_sheet':'{\\'ans_1\\':\\'\(String(storeArray[0]))\\',\\'ans_2\\':\\'\(String(storeArray[1]))\\',\\'ans_3\\':\\'\(String(storeArray[2]))\\',\\'ans_4\\':\\'\(String(storeArray[3]))\\'}'}"
//
//    defaults.set(gameArray, forKey: "gameLeft")
//
//}
