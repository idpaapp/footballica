//
//  StoreViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

class StoreViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
   

    @IBOutlet weak var storeCV: UICollectionView!
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var xp: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var xpProgress: UIProgressView!
    @IBOutlet weak var xpProgressBackGround: UIView!
    @IBOutlet weak var storeLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var storeRightConstraint: NSLayoutConstraint!
    
    var selectedShop = Int()
    
    @objc func openCoinsOrMoney(notification: Notification){
        self.view.isUserInteractionEnabled = true
        if let text = notification.userInfo?["title"] as? String {
           openCoinOrMoney(Title: text)
        }
    }
    
    @objc func rData() {
        level.text = (login.res?.response?.mainInfo?.level)!
        money.text = (login.res?.response?.mainInfo?.cashs)!
        xp.text = "\((login.res?.response?.mainInfo?.max_points_gain)!)/\((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)"
        coins.text = (login.res?.response?.mainInfo?.coins)!
        xpProgress.progress = Float((login.res?.response?.mainInfo?.max_points_gain)!)! / Float((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        rData()
        PubProc.wb.showWaiting()
        loadShop().loadingShop(userid: "\(loadingViewController.userid)" , rest: false, completionHandler: {
        PubProc.wb.hideWaiting()
        })
    }
    
    @objc func refreshData(notification : Notification) {
        rData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if storeLeftConstraint != nil {
            storeLeftConstraint.constant = UIScreen.main.bounds.width / 10
        }
        
        if storeRightConstraint != nil {
            storeRightConstraint.constant = UIScreen.main.bounds.width / 10
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData(notification:)), name: Notification.Name("refreshUserData"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openCoinsOrMoney(notification:)), name: Notification.Name("openCoinsOrMoney"), object: nil)

        
        self.storeCV.allowsMultipleSelection = false
        self.xpProgressBackGround.layer.cornerRadius = 3
        xp.minimumScaleFactor = 0.5
        xp.adjustsFontSizeToFitWidth = true
    }

    var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (loadShop.res?.response?[1].items?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath) as! storeCell
        
        
        let url = "\(((loadShop.res?.response?[1].items?[indexPath.item].image!)!))"
        let urls = URL(string: url)
        cell.storeImage.kf.setImage(with: urls , options : [.transition(ImageTransition.fade(0.5))])
        
        
        if UIDevice().userInterfaceIdiom == .phone {
        cell.storeLabel.AttributesOutLine(font: iPhonefonts, title: "\(((loadShop.res?.response?[1].items?[indexPath.item].title!)!))", strokeWidth: -7.0)
        cell.storeLabelForeGround.font = iPhonefonts
        } else {
            cell.storeLabel.AttributesOutLine(font: iPadfonts, title: "\(((loadShop.res?.response?[1].items?[indexPath.item].title!)!))", strokeWidth: -7.0)
            cell.storeLabelForeGround.font = iPadfonts
        }
        cell.storeLabelForeGround.text = "\(((loadShop.res?.response?[1].items?[indexPath.item].title!)!))"
        cell.storeSelect.tag = indexPath.item
        cell.storeSelect.addTarget(self, action: #selector(selectingStore), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    @objc func selectingStore(_ sender : UIButton!) {
        selectedShop = sender.tag
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.performSegue(withIdentifier: "shopDetail", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? shopDetailViewController {
            
            if (loadShop.res?.response?[1].items?[selectedShop].type)! == "3" {
                vc.myVitrin = true
            } else {
               vc.myVitrin = false
            }
            
            vc.shopIndex = selectedShop
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
                return CGSize(width: (UIScreen.main.bounds.width  - ((UIScreen.main.bounds.width / 5) + 40)) / 3 , height: 230)
            }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func openCoinOrMoney(Title : String) {
        for i in 0...(loadShop.res?.response?[1].items?.count)! - 1 {
            if ((loadShop.res?.response?[1].items?[i].title!)!).contains(Title) {
                selectedShop = i
                break
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.performSegue(withIdentifier: "shopDetail", sender: self)
        }
        
    }
    
    @IBAction func addMoney(_ sender: RoundButton) {
        openCoinOrMoney(Title: "پول")
    }
    
    @IBAction func addCoin(_ sender: RoundButton) {
        openCoinOrMoney(Title: "سکه")
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
