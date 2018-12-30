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
    @IBOutlet weak var gradeNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradeTexts = "بخش چالش به زودی راه اندازی خواهد شد!"
        self.gradeTitleForeGround.text = gradeTexts
        let fonts = UIFont(name: "DPA_Game", size: 60)!
        let iPadfonts = UIFont(name: "DPA_Game", size: 80)!
         if UIDevice().userInterfaceIdiom == .phone  {
        self.gradeTitleForeGround.font = fonts
        self.gradeNumber.AttributesOutLine(font: fonts, title: "", strokeWidth: -5.0)
        self.gradeTitle.AttributesOutLine(font: fonts, title: gradeTexts, strokeWidth: 8.0)
         } else {
        self.gradeTitleForeGround.font = iPadfonts
        self.gradeNumber.AttributesOutLine(font: iPadfonts, title: "", strokeWidth: -5.0)
        self.gradeTitle.AttributesOutLine(font: fonts, title: gradeTexts, strokeWidth: 8.0)
        }
        self.gradeTitleForeGround.minimumScaleFactor = 0.1
        self.gradeTitleForeGround.adjustsFontSizeToFitWidth = true
        self.gradeTitle.minimumScaleFactor = 0.1
        self.gradeTitle.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
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
