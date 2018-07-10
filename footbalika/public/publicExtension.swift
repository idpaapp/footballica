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

public class centerScreen {
    public var centerScreens = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
}

public class fonts {
    public var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    public var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    public var iPhonefonts18 = UIFont(name: "DPA_Game", size: 18)!
    public var iPadfonts25 = UIFont(name: "DPA_Game", size: 25)!

}

extension UILabel {
    public func AttributesOutLine(font : UIFont , title : String , strokeWidth : Double) {
        let strokeTextAttributes: [NSAttributedStringKey: Any] = [.strokeColor: UIColor.black, .foregroundColor: UIColor.white, .strokeWidth : strokeWidth , .strikethroughColor : UIColor.white , .font: font]
        self.attributedText = NSMutableAttributedString(string: title , attributes: strokeTextAttributes)
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
        }
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
        }
        
    }
    
    public func playQuizeMusic() {
        
        if playMenuMusics == true {
        guard let url = Bundle.main.url(forResource: "quize", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            musicPlay.musicPlayer = try AVAudioPlayer(contentsOf: url)
            guard let playerQuize = musicPlay.musicPlayer else { return }
            playerQuize.numberOfLoops = 0
            playerQuize.prepareToPlay()
            playerQuize.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
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
