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

extension UILabel {
    public func AttributesOutLine(font : UIFont , title : String , strokeWidth : Double) {
        let strokeTextAttributes: [NSAttributedStringKey: Any] = [.strokeColor: UIColor.black, .foregroundColor: UIColor.white, .strokeWidth : strokeWidth , .strikethroughColor : UIColor.white , .font: font]
        self.attributedText = NSMutableAttributedString(string: title , attributes: strokeTextAttributes)
    }
}

struct soundPlay {
    static var player = AVAudioPlayer()
    public func playClick() {
        let playgameSounds = UserDefaults.standard.bool(forKey: "gameSounds")
        if playgameSounds == true {
        // play a click sound on your player
        guard let url = Bundle.main.url(forResource: "click", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            soundPlay.player = try AVAudioPlayer(contentsOf: url)
            let player = soundPlay.player
            player.numberOfLoops = 0
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
        }
    }
}

struct musicPlay {
    static var musicPlayer: AVAudioPlayer?
    
    public func playMusic() {
        
        if musicPlay.musicPlayer?.isPlaying == true {
            
            musicPlay.musicPlayer?.stop()
            
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
