//
//  loadingViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import SQLite3

class loadingViewController: UIViewController {
    
    @IBOutlet weak var loadingProgress: UIProgressView!
    @IBOutlet weak var loadingProgressLabel: UILabel!
    @IBOutlet weak var ProgressBackGroundView: UIView!
    @IBOutlet weak var mainProgressBackGround: UIView!
    @IBOutlet weak var ballProgress: UIImageView!
    
    var timer : Timer!
    var ballTimer : Timer!
    var currentProgress = Float()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var ballState = 0
    @objc func ballProgressing() {
        if ballState == 0 {
            UIView.animate(withDuration: 0.7, animations: {
                self.ballProgress.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            })
            self.ballState = 1
        } else {
            UIView.animate(withDuration: 0.7, animations: {
                self.ballProgress.transform = CGAffineTransform.identity
            })
            self.ballState = 0
        }
    }
    
    var fonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadFonts = UIFont(name: "DPA_Game", size: 35)!
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")

    @objc func dataBase() {
        if launchedBefore  {
            print("Not first launch.")
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Assets.sqlite")
            var db: OpaquePointer?
            if sqlite3_open(fileURL.path , &db) != SQLITE_OK {
                print("error opening database")
            } else {
                print(fileURL.path)
                print("Ok")
            }
            
        } else {
            print("First launch, setting UserDefault.")
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Assets.sqlite")
            var db: OpaquePointer?
            if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                print("error opening database")
            } else {
                print("Ok")
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBase()
        
        
        //            if let viewController = UIStoryboard(name: "iPhoneX", bundle: nil).instantiateViewController(withIdentifier: "loadingViewController") as? loadingViewController {
        //                if let navigator = navigationController {
        //                    navigator.pushViewController(viewController, animated: true)
        //                }
        //            }
        
        
        
        
        ballTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(ballProgressing), userInfo: nil, repeats: true)
        
        self.mainProgressBackGround.layer.cornerRadius = 5
        self.ProgressBackGroundView.layer.cornerRadius = 3
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(progressing), userInfo: nil, repeats: true)
        self.loadingProgress.progress = 0
        self.loadingProgressLabel.text = "۰٪"
    }
    
    @objc func progressing() {
        if currentProgress > 1.0 {
            timer.invalidate()
            ballTimer.invalidate()
            self.performSegue(withIdentifier: "showMainMenu", sender: self)
        } else {
            currentProgress = currentProgress + 0.01
            self.loadingProgress.progress = currentProgress
            if UIDevice().userInterfaceIdiom == .phone {
                self.loadingProgressLabel.AttributesOutLine(font: fonts , title: "\(Int(currentProgress * 100))%", strokeWidth: -6.0)
            } else {
                self.loadingProgressLabel.AttributesOutLine(font: iPadFonts , title: "\(Int(currentProgress * 100))%", strokeWidth: -6.0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   
}

