//
//  publicExtension.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Kingfisher
import RealmSwift


public class scrollToPage {
    public func scrollPageViewController(index : Int) {
        let pageIndexDict:[String: Int] = ["pageIndex": index]
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
    }
    
    public func menuButtonChanged(index : Int) {
        let pageIndexDict:[String: Int] = ["button": index]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
    }
}

public class centerScreen {
    public var centerScreens = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
}

public class publicColors {
    public var placeHolderColor = UIColor.init(red: 202/255, green: 202/255, blue: 202/255, alpha: 1.0)
    public var textFieldTintTextColor = UIColor.init(red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
    public var currentUserTitleChatColor = #colorLiteral(red: 0.8235294118, green: 0.2549019608, blue: 0.2078431373, alpha: 1)
    public var otherUserTitleChatColor = #colorLiteral(red: 0.4, green: 0.7960784314, blue: 0.6, alpha: 1)
    public var endGroupGameColor = #colorLiteral(red: 0.6156862745, green: 0.4039215686, blue: 0.7803921569, alpha: 1)
    public var cancelGroupGameColor = #colorLiteral(red: 1, green: 0.2901960784, blue: 0.01176470588, alpha: 1)
    public var startGroupGameColor = #colorLiteral(red: 0.2705882353, green: 0.01568627451, blue: 0.4666666667, alpha: 1)
    public var goodNewsColor = #colorLiteral(red: 0.3828445673, green: 0.8042317033, blue: 0.5987154245, alpha: 1)
    public var badNewsColor = #colorLiteral(red: 0.8323555589, green: 0.2498360276, blue: 0.1824916899, alpha: 1)
    public var textColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
    public var warProgressTopColor = #colorLiteral(red: 0.09019607843, green: 0.968627451, blue: 0.9647058824, alpha: 1)
    public var warProgressMiddleColor = #colorLiteral(red: 0.05882352941, green: 0.6941176471, blue: 0.9803921569, alpha: 1)
    public var warProgressBottomColor = #colorLiteral(red: 0.07450980392, green: 0.6745098039, blue: 0.9411764706, alpha: 1)
}

public class publicImages {
    public var correctAnswerImage = UIImage(named: "green_answer_btn")
    public var wrongAnswerImage = UIImage(named: "red_answer_btn")
    public var normalAnswerImage = UIImage(named: "answer_btn")
    public var redBall = UIImage(named: "ic_red_ball")
    public var greenBall = UIImage(named: "ic_green_ball")
    public var grayBall = UIImage(named: "ic_gray_ball")
    public var radioButtonFill = UIImage(named : "radioButtonFill")
    public var radioButtonEmpty = UIImage(named : "radioButtonEmpty")
    public var emptyImage = UIImage()
    public var coin = UIImage(named: "ic_coin")
    public var money = UIImage(named: "money")
    public var inactiveLargeButton = UIImage(named: "inactive_tab_btn")
    public var activeButton = UIImage(named: "green_btn_large")
    public var ic_timer = UIImage(named: "ic_timer")
    public var dark_btn_large = UIImage(named: "dark_btn_large")
    public var action_back_large_btn = UIImage(named: "action_back_large_btn")
    public var label_back_dark = UIImage(named: "label_back_dark")
    public var accept_btn = UIImage(named: "accept_btn")
    public var bomb = UIImage(named: "bomb")
    public var freezeTimer = UIImage(named: "freeze_timer")
}

public class fonts {
    public var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    public var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    public var iPhonefonts18 = UIFont(name: "DPA_Game", size: 18)!
    public var iPadfonts25 = UIFont(name: "DPA_Game", size: 25)!
    public var large35 = UIFont(name: "DPA_Game", size: 35)!
    public var large200 = UIFont(name: "DPA_Game", size: 200)!
}

public class colors {
    public var lightBrownBackGroundColor = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
    public var notEnoughColor = UIColor.init(red: 251/255, green: 31/255, blue: 102/255, alpha: 1.0)
    public var selectedTab = UIColor.init(red: 239/255, green: 236/255, blue: 221/255, alpha: 1.0)
}

extension UIButton {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func bouncing() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.7, delay: 0, options: .allowUserInteraction, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { (finish) in
                
            })
        })
    }
    
    func setImageWithKingFisher(url : String) {
        let urls = URL(string : url)
        let resource = ImageResource(downloadURL: urls!, cacheKey: url)
        self.kf.setImage(with: resource, for: .normal ,options:[.transition(ImageTransition.fade(0.5))])
    }
}


extension UIImageView {
    func upAndDown(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 1.4
        animation.repeatCount = 0
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y - 10))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y + 10))
        self.layer.add(animation, forKey: "position")
    }
}

extension UILabel {
    func AttributesOutLine(font : UIFont , title : String , strokeWidth : Double) {
        let strokeTextAttributes: [NSAttributedStringKey: Any] = [.strokeColor: UIColor.black, .foregroundColor: UIColor.white, .strokeWidth : strokeWidth , .strikethroughColor : UIColor.white , .font: font]
        self.attributedText = NSMutableAttributedString(string: title , attributes: strokeTextAttributes)
    }
    
    func setLabelHide(isHide : Bool) {
        self.isHidden = isHide
    }
}

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
    
}

struct soundPlay {
    static var player : AVAudioPlayer?
    let playgameSounds = UserDefaults.standard.bool(forKey: "gameSounds")
    public func playClick() {
        if playgameSounds == true {
            // play a click sound on your player
            guard let url = Bundle.main.url(forResource: "click", withExtension: "mp3") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                soundPlay.player = try AVAudioPlayer(contentsOf: url)
                guard let player = soundPlay.player else { return }
                player.numberOfLoops = 0
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        } else {}
    }
    
    public func playWhistleSound() {
        if playgameSounds == true {
            guard let url = Bundle.main.url(forResource: "whistle", withExtension: "mp3") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                soundPlay.player = try AVAudioPlayer(contentsOf: url)
                guard let player = soundPlay.player else { return }
                player.numberOfLoops = 0
                player.prepareToPlay()
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    public func playBuyItem() {
        if playgameSounds == true {
            guard let url = Bundle.main.url(forResource: "buy_item", withExtension: "mp3") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                soundPlay.player = try AVAudioPlayer(contentsOf: url)
                guard let player = soundPlay.player else { return }
                player.numberOfLoops = 0
                player.prepareToPlay()
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func playBeepSound() {
        if playgameSounds == true {
            guard let url = Bundle.main.url(forResource: "beep", withExtension: "mp3") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                soundPlay.player = try AVAudioPlayer(contentsOf: url)
                guard let player = soundPlay.player else { return }
                player.numberOfLoops = 0
                player.prepareToPlay()
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func playCorrectAnswerSound() {
        if playgameSounds == true {
            guard let url = Bundle.main.url(forResource: "correctAnswer", withExtension: "mp3") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                soundPlay.player = try AVAudioPlayer(contentsOf: url)
                guard let player = soundPlay.player else { return }
                player.numberOfLoops = 0
                player.prepareToPlay()
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func playWrongAnswerSound() {
        if playgameSounds == true {
            guard let url = Bundle.main.url(forResource: "wrong_answer", withExtension: "wav") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                soundPlay.player = try AVAudioPlayer(contentsOf: url)
                guard let player = soundPlay.player else { return }
                player.numberOfLoops = 0
                player.prepareToPlay()
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func playEndGameSound() {
        if playgameSounds == true {
            if soundPlay.player?.isPlaying == true {
                soundPlay.player?.stop()
            } else {
                
                guard let url = Bundle.main.url(forResource: "referee_whistle_end", withExtension: "mp3") else { return }
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    soundPlay.player = try AVAudioPlayer(contentsOf: url)
                    guard let player = soundPlay.player else { return }
                    player.numberOfLoops = 0
                    player.play()
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
        } else {
            thirdSoundPlay.thirdPlayer?.stop()
        }
    }
}

struct musicPlay {
    static var musicPlayer: AVAudioPlayer?
    let playMenuMusics = UserDefaults.standard.bool(forKey: "menuMusic")
    
    public func playMenuMusic() {
        if playMenuMusics == true {
            if musicPlay.musicPlayer?.isPlaying == true {
                if #available(iOS 10.0, *) {
                    if playMenuMusics != false {
                        musicPlay.musicPlayer?.setVolume(0, fadeDuration: 2)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            musicPlay.musicPlayer?.stop()
                        }
                    } else {
                        musicPlay.musicPlayer?.stop()
                    }
                } else {
                    musicPlay.musicPlayer?.stop()
                }
            } else {
                
                guard let url = Bundle.main.url(forResource: "menu", withExtension: "mp3") else { return }
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    musicPlay.musicPlayer = try AVAudioPlayer(contentsOf: url)
                    guard let player = musicPlay.musicPlayer else { return }
                    player.numberOfLoops = -1
                    player.play()
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
        } else {
            musicPlay.musicPlayer?.stop()
        }
        
    }
    
    public func playQuizeMusic() {
        
        if playMenuMusics == true {
            guard let url = Bundle.main.url(forResource: "quize", withExtension: "mp3") else { return }
            
            if musicPlay.musicPlayer?.isPlaying == true {
                musicPlay.musicPlayer?.stop()
            } else {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    musicPlay.musicPlayer = try AVAudioPlayer(contentsOf: url)
                    guard let playerQuize = musicPlay.musicPlayer else { return }
                    playerQuize.numberOfLoops = -1
                    playerQuize.prepareToPlay()
                    playerQuize.play()
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct thirdSoundPlay {
    static var thirdPlayer: AVAudioPlayer?
    let playGameSounds = UserDefaults.standard.bool(forKey: "gameSounds")
    public func playThirdSound() {
        if playGameSounds == true {
            if thirdSoundPlay.thirdPlayer?.isPlaying == true {
                thirdSoundPlay.thirdPlayer?.stop()
            } else {
                
                guard let url = Bundle.main.url(forResource: "last_ticking", withExtension: "mp3") else { return }
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    thirdSoundPlay.thirdPlayer = try AVAudioPlayer(contentsOf: url)
                    guard let player = thirdSoundPlay.thirdPlayer else { return }
                    player.numberOfLoops = 0
                    player.play()
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
        } else {
            thirdSoundPlay.thirdPlayer?.stop()
        }
        
    }
    
    public func playCollectItemSound() {
        if playGameSounds == true {
            if thirdSoundPlay.thirdPlayer?.isPlaying == true {
                thirdSoundPlay.thirdPlayer?.stop()
            } else {
                
                guard let url = Bundle.main.url(forResource: "collectItem", withExtension: "mp3") else { return }
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    thirdSoundPlay.thirdPlayer = try AVAudioPlayer(contentsOf: url)
                    guard let player = thirdSoundPlay.thirdPlayer else { return }
                    player.numberOfLoops = 0
                    player.play()
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
        } else {
            thirdSoundPlay.thirdPlayer?.stop()
        }
        
    }
    
}


public extension String {
    public var replacedArabicCharactersToPersian: String {
        var str = self
        let map = ["ي" : "ی",
                   "ك" : "ک" ,
                   "ر" : "ر" ,
                   
                   "ا" : "ا"
        ]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
}


public extension UITextField {
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        switch padding {
            
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
            
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}


extension String {
    var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["۰": "0",
                   "۱": "1",
                   "۲": "2",
                   "۳": "3",
                   "۴": "4",
                   "۵": "5",
                   "۶": "6",
                   "۷": "7",
                   "۸": "8",
                   "۹": "9",
                   "٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
}


extension UIView {
    
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    func makeCircular() {
        self.layer.cornerRadius = 0.5 * bounds.size.height
        self.clipsToBounds = true
        self.layoutIfNeeded()
    }
    
    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
    
    func closeOrOpenViewWithAnimation(State : String , time : Double , max : CGFloat , min : CGFloat) {
        if State == "open" {
            self.transform = CGAffineTransform.identity.scaledBy(x: min, y: min)
        } else {
            self.transform = CGAffineTransform.identity
        }
        UIView.animate(withDuration: time, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: max, y: max)
        }, completion: {(finish) in
            UIView.animate(withDuration: time, animations: {
                if State == "open" {
                    self.transform = CGAffineTransform.identity
                } else {
                    self.transform = CGAffineTransform.identity.scaledBy(x: min, y: min)
                }
            })
        })
    }
}


extension UIImageView {
    @objc func addUIImageShadow(color : UIColor , offset : CGSize , opacity : Float ,Radius : CGFloat ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = Radius
    }
    
    @objc func animatingImageView(Radius : CGFloat , circleCenter : CGPoint) {
        
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: CGFloat(Radius), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        // create a new CAKeyframeAnimation that animates the objects position
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        // set the animations path to our bezier curve
        anim.path = circlePath.cgPath
        anim.repeatCount = Float.infinity
        anim.duration = 5.0
        
        // we add the animation to the squares 'layer' property
        self.layer.add(anim, forKey: "animate position along path")
        
    }
    
    @objc func setImageWithKingFisher(url : String) {
        let urls = URL(string : url)
        let resource = ImageResource(downloadURL: urls!, cacheKey: url)
        self.kf.setImage(with: resource ,options:[.transition(ImageTransition.fade(0.5))])
    }
    
    @objc func setImageWithRealmPath(url : String) {
        var realm : Realm!
        realm = try? Realm()
        let realmID = realm.objects(tblShop.self).filter("image_path == '\(url)'")
        if realmID.count != 0 {
            let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
            self.image = UIImage(data: dataDecoded as Data)
        } else {
            self.image = UIImage()
        }
    }
    
    @objc func setImageWithRealmId(id : Int) {
        var realm : Realm!
        realm = try? Realm()
        let realmID = realm.objects(tblShop.self).filter("id == \(id)")
        if realmID.count != 0 {
            let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
            self.image = UIImage(data: dataDecoded as Data)
        } else {
            self.image = UIImage()
        }
    }
}

extension UILabel {
    func setLabelBackGroundImage(image : UIImage) {
        self.backgroundColor = UIColor(patternImage: image)
    }
}

extension UIImage {
    func noir() -> UIImage {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
        currentFilter!.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!, scale: scale, orientation: imageOrientation)
        return processedImage
    }
}
