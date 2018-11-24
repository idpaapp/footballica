//
//  clanMatchFieldViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/29/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import KBImageView
import RealmSwift

class clanMatchFieldViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    
    var realm : Realm!
    
    
    @IBOutlet weak var scoreCV: UICollectionView!
    
    
    @IBOutlet weak var backGroundStadiumImage: KBImageView!
    
    var warQuestions : warQuestions.Response? = nil 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scoreCV.register(UINib(nibName: "scoreBallCell", bundle: nil), forCellWithReuseIdentifier: "scoreBallCell")
        
        realm = try? Realm()
        setBackGroundImage()
        
     }
    
    
    @objc func setBackGroundImage() {
        let realmID = self.realm.objects(tblStadiums.self).filter("img_logo == '\(urls().stadium)\((login.res?.response?.mainInfo?.stadium!)!)'")
        if realmID.count != 0 {
            if realmID.first?.img_base64.count != 0 {
                let dataDecoded:NSData = NSData(base64Encoded: (realmID.first?.img_base64)!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                self.backGroundStadiumImage.image = UIImage(data: dataDecoded as Data)
            } else {
                self.backGroundStadiumImage.image = UIImage(named : "empty_std")
            }
        } else {
            self.backGroundStadiumImage.image = UIImage(named : "empty_std")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.warQuestions?.response.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "scoreBallCell" , for: indexPath) as! scoreBallCell
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / CGFloat((self.warQuestions?.response.count)!) , height: 45)
    }

    
}
