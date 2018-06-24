//
//  StoreViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
   

    @IBOutlet weak var storeCV: UICollectionView!
    
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var xp: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var xpProgress: UIProgressView!
    @IBOutlet weak var xpProgressBackGround: UIView!
    
    
    var storeImages = ["coin" , "money" , "ball" , "avatar"]
    var storeTitles = ["سکه" , "پول" , "استادیوم" , "آواتار"]
    override func viewDidLoad() {
        super.viewDidLoad()
        level.text = (login.res?.response?.mainInfo?.level)!
        money.text = (login.res?.response?.mainInfo?.cashs)!
        xp.text = "\((login.res?.response?.mainInfo?.max_points_gain)!)/\((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)"
        coins.text = (login.res?.response?.mainInfo?.coins)!
        xpProgress.progress = Float((login.res?.response?.mainInfo?.max_points_gain)!)! / Float((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)!
        self.xp.alpha = 0.0
        self.xpProgressBackGround.layer.cornerRadius = 3
        xp.minimumScaleFactor = 0.5
        xp.adjustsFontSizeToFitWidth = true
    }

    var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath) as! storeCell
        
        cell.storeImage.image = UIImage(named : "\(storeImages[indexPath.item])")
        if UIDevice().userInterfaceIdiom == .phone {
        cell.storeLabel.AttributesOutLine(font: iPhonefonts, title: "\(storeTitles[indexPath.item])", strokeWidth: -4.0)
        cell.storeLabelForeGround.font = iPhonefonts
        } else {
            cell.storeLabel.AttributesOutLine(font: iPadfonts, title: "\(storeTitles[indexPath.item])", strokeWidth: -4.0)
            cell.storeLabelForeGround.font = iPadfonts
        }
        cell.storeLabelForeGround.text = "\(storeTitles[indexPath.item])"
        
        return cell
    }
    
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if UIDevice().userInterfaceIdiom == .phone  {
                if UIScreen.main.nativeBounds.height == 2436 {
                    //iPhone X
                    return CGSize(width: UIScreen.main.bounds.width / 3 - 20 , height: 130)
                } else {
                    return CGSize(width: UIScreen.main.bounds.width / 3 - 20 , height: 130)
                }
            } else {
                return CGSize(width: UIScreen.main.bounds.width / 3 - 20 , height: 250)
            }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.xp.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let pageIndexDict:[String: Int] = ["button": 4]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
        
        self.xpProgress.progress = 0.0
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.xp.alpha = 1.0
            })
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.xpProgress.setProgress(Float((login.res?.response?.mainInfo?.max_points_gain)!)! / Float((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)!, animated: true)

            })
        }
    }
}
