//
//  mainPageViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import AVFoundation

class mainPageViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var menuTitles = ["لیست بازی ها" ,
                      "جام حذفی" ,
                      "مسابقه" ,
                      "گروه ها" ,
                      "فروشگاه"]
    
    
    var menuImages = ["log" , "challenges" , "ball" , "groups" , "shop"]
    
    @IBOutlet weak var menuButtonsCV: UICollectionView!
    
    @objc func scrollFunction(notification: Notification){
        if let index = notification.userInfo?["button"] as? Int {
            selectedItem = index
            self.menuButtonsCV.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.centeredVertically)
            self.menuButtonsCV.collectionViewLayout.invalidateLayout()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    var rotateTimer : Timer!
    
    let playMenuMusic = UserDefaults.standard.bool(forKey: "menuMusic")
    let playingMusic = musicPlay()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if playMenuMusic == true {
            playingMusic.playMusic()
        } else {
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollFunction(notification:)), name: Notification.Name("selectButtonPage"), object: nil)
        
        self.menuButtonsCV.selectItem(at: IndexPath(item: 2, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.centeredVertically)
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuButtonCell", for: indexPath) as! menuButtonCell
        cell.menuTitle.text = menuTitles[indexPath.item]
        cell.menuImage.image = UIImage(named : "\(menuImages[indexPath.item])")
        cell.menuIndex = indexPath.item
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let playgameSounds = UserDefaults.standard.bool(forKey: "gameSounds")
    let playingSound = soundPlay()
    var selectedItem = 2
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.isUserInteractionEnabled = false
        selectedItem = indexPath.item
        let pageIndexDict:[String: Int] = ["pageIndex": selectedItem]
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
        UIView.animate(withDuration: 0.5) {
            self.menuButtonsCV.collectionViewLayout.invalidateLayout()
            //            self.menuButtonsCV.layoutIfNeeded()
            //            self.menuButtonsCV.layoutAttributesForItem(at: indexPath)
        }
        if playgameSounds == true {
            playingSound.playClick()
        } else {}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.view.isUserInteractionEnabled = true
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == selectedItem {
            if UIDevice().userInterfaceIdiom == .phone  {
            if UIScreen.main.nativeBounds.height == 2436 {
                //iPhone X
                return CGSize(width: UIScreen.main.bounds.width / 3.4 , height: 130)
                 } else {
                  return CGSize(width: UIScreen.main.bounds.width / 3.4 , height: 100)
                  }
              } else {
                return CGSize(width: UIScreen.main.bounds.width / 3.4 , height: 150)
              }
        } else {
            if UIDevice().userInterfaceIdiom == .phone  {
                if UIScreen.main.nativeBounds.height == 2436 {
                //iPhone X
                return CGSize(width: UIScreen.main.bounds.width / 5.7  , height: 130)
                } else {
                 return CGSize(width: UIScreen.main.bounds.width / 5.7  , height: 100)
                }
            } else {
                return CGSize(width: UIScreen.main.bounds.width / 5.7 , height: 150)
            }
        }
    }
}




