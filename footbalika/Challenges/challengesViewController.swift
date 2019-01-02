//
//  challengesViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import CoreFoundation

class challengesViewController: UIViewController {
    
    @IBOutlet weak var gradeTitleForeGround: UILabel!
    @IBOutlet weak var gradeTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradeTexts = "بخش چالش به زودی راه اندازی خواهد شد!"
        self.gradeTitleForeGround.text = gradeTexts
         if UIDevice().userInterfaceIdiom == .phone  {
        self.gradeTitleForeGround.font = fonts().iPadfonts25
        self.gradeTitle.AttributesOutLine(font: fonts().iPadfonts25, title: gradeTexts, strokeWidth: 8.0)
         } else {
        self.gradeTitleForeGround.font = fonts().large35
        self.gradeTitle.AttributesOutLine(font: fonts().large35, title: gradeTexts, strokeWidth: 8.0)
        }
        
        self.gradeTitleForeGround.setAdjustToFit()
        self.gradeTitle.setAdjustToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let pageIndexDict:[String: Int] = ["button": 1]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
    }

}
