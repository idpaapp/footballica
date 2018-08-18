//
//  predictOneMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/27/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

class predictOneMatchViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
    }
    

}
