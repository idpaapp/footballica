//
//  StoreViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import RealmSwift

class StoreViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
   

    @IBOutlet weak var storeCV: UICollectionView!
    
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var xp: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var xpProgress: UIProgressView!
    @IBOutlet weak var xpProgressBackGround: UIView!
    
    var realm : Realm!
    var tblShopArray : Results<tblShop> {
        get {
            realm = try! Realm()
            return realm.objects(tblShop.self)
        }
    }
    
    
    var storeImages = [String]()
    var storeID = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let counts = self.tblShopArray.count
        for i in 0...counts - 1 {
            storeID.append(tblShopArray[i].id)
            storeImages.append(tblShopArray[i].img_base64)
            if i == counts - 1  {
                self.storeCV.reloadData()
            }
            
        }
        
        
        level.text = (login.res?.response?.mainInfo?.level)!
        money.text = (login.res?.response?.mainInfo?.cashs)!
        xp.text = "\((login.res?.response?.mainInfo?.max_points_gain)!)/\((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)"
        coins.text = (login.res?.response?.mainInfo?.coins)!
        xpProgress.progress = Float((login.res?.response?.mainInfo?.max_points_gain)!)! / Float((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)!
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

        let dataDecoded:NSData = NSData(base64Encoded: storeImages[indexPath.row], options: NSData.Base64DecodingOptions(rawValue: 0))!
        cell.storeImage.image = UIImage(data: dataDecoded as Data)
        
        if UIDevice().userInterfaceIdiom == .phone {
        cell.storeLabel.AttributesOutLine(font: iPhonefonts, title: "\(((loadShop.res?.response?[1].items?[indexPath.item].title!)!))", strokeWidth: -4.0)
        cell.storeLabelForeGround.font = iPhonefonts
        } else {
            cell.storeLabel.AttributesOutLine(font: iPadfonts, title: "\(((loadShop.res?.response?[1].items?[indexPath.item].title!)!))", strokeWidth: -4.0)
            cell.storeLabelForeGround.font = iPadfonts
        }
        cell.storeLabelForeGround.text = "\(((loadShop.res?.response?[1].items?[indexPath.item].title!)!))"
        cell.storeSelect.tag = indexPath.item
        cell.storeSelect.addTarget(self, action: #selector(selectingStore), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    @objc func selectingStore(_ sender : UIButton!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.performSegue(withIdentifier: "shopDetail", sender: self)
        }
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
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let pageIndexDict:[String: Int] = ["button": 4]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
        
        self.xpProgress.progress = 0.0
        DispatchQueue.main.async {

            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.xpProgress.setProgress(Float((login.res?.response?.mainInfo?.max_points_gain)!)! / Float((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)!, animated: true)

            })
        }
    }
}
