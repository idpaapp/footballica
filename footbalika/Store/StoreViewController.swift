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
    
    var mainShopIndex = Int()
    @objc func rData() {
        let index = loadShop.res?.response?.index(where: { $0.type == 2})
        self.mainShopIndex = index!
        level.text = (login.res?.response?.mainInfo?.level)!
        money.text = (login.res?.response?.mainInfo?.cashs)!
        xp.text = "\((login.res?.response?.mainInfo?.max_points_gain)!)/\((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)"
        coins.text = (login.res?.response?.mainInfo?.coins)!
        xpProgress.progress = Float((login.res?.response?.mainInfo?.max_points_gain)!)! / Float((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        PubProc.isSplash = true
        loadShop().loadingShop(userid: "\(loadingViewController.userid)" , rest: false, completionHandler: {
            login().loging(userid: loadingViewController.userid, rest: false, completionHandler: {
                PubProc.wb.hideWaiting()
                self.xpProgress.progress = 0.0
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.xpProgress.setProgress(Float((login.res?.response?.mainInfo?.max_points_gain)!)! / Float((loadingViewController.loadGameData?.response?.userXps[Int((login.res?.response?.mainInfo?.level)!)! - 1].xp!)!)!, animated: true)
                        self.rData()
                        PubProc.wb.hideWaiting()
                        PubProc.isSplash = false
                    })
                }
            })
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
        if (loadShop.res?.response?.count)! == 1 {
        return (loadShop.res?.response?[self.mainShopIndex].items?.count)!
        } else {
        return (loadShop.res?.response?[self.mainShopIndex].items?.count)! + (loadShop.res?.response?.count)! - 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item >= self.mainShopIndex {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath) as! storeCell
            
        let url = "\(((loadShop.res?.response?[self.mainShopIndex].items?[indexPath.item - self.mainShopIndex].image!)!))"
        let urls = URL(string: url)
        cell.storeImage.kf.setImage(with: urls , options : [.transition(ImageTransition.fade(0.5))])
        
        if UIDevice().userInterfaceIdiom == .phone {
        cell.storeLabel.AttributesOutLine(font: iPhonefonts, title: "\(((loadShop.res?.response?[self.mainShopIndex].items?[indexPath.item - self.mainShopIndex].title!)!))", strokeWidth: -7.0)
        cell.storeLabelForeGround.font = iPhonefonts
        } else {
            cell.storeLabel.AttributesOutLine(font: iPadfonts, title: "\(((loadShop.res?.response?[self.mainShopIndex].items?[indexPath.item - self.mainShopIndex].title!)!))", strokeWidth: -7.0)
            cell.storeLabelForeGround.font = iPadfonts
        }
            
        cell.storeLabelForeGround.text = "\(((loadShop.res?.response?[self.mainShopIndex].items?[indexPath.item - self.mainShopIndex].title!)!))"
        cell.storeSelect.tag = indexPath.item - self.mainShopIndex
        cell.storeSelect.addTarget(self, action: #selector(selectingStore), for: UIControlEvents.touchUpInside)
        return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "packageCell", for: indexPath) as! packageCell
            
            let url = "\(((loadShop.res?.response?[indexPath.item].items?[0].image!)!))"
            let urls = URL(string: url)
            let processor = RoundCornerImageProcessor(cornerRadius: 10)
            cell.packageButton.kf.setBackgroundImage(with: urls , for: UIControlState.normal, options : [.transition(ImageTransition.fade(0.5)) , .processor(processor)])

            cell.packageButton.tag = indexPath.item
            cell.packageButton.addTarget(self, action: #selector(packageSelected), for: UIControlEvents.touchUpInside)
            cell.packageButton.clipsToBounds = true
            cell.packageButton.layer.cornerRadius = 10
            return cell
        }
    }
    
    var selectedPackage = Int()
    @objc func packageSelected(_ sender : UIButton!) {
        self.selectedPackage = sender.tag
        self.performSegue(withIdentifier : "packageItem" , sender : self)
    }
    
    
    @objc func selectingStore(_ sender : UIButton!) {
        selectedShop = sender.tag
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.performSegue(withIdentifier: "shopDetail", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? shopDetailViewController {
            
            if (loadShop.res?.response?[self.mainShopIndex].items?[selectedShop].type)! == "3" {
                vc.myVitrin = true
            } else {
               vc.myVitrin = false
            }
            
            vc.mainShopIndex = self.mainShopIndex
            vc.shopIndex = selectedShop
        }
        
        if let vc = segue.destination as? showItemViewController {
            vc.mainTitle = ((loadShop.res?.response?[self.selectedPackage].items?[0].title!)!)
            vc.mainImage = ((loadShop.res?.response?[self.selectedPackage].items?[0].image!)!)
            vc.price = ((loadShop.res?.response?[self.selectedPackage].items?[0].price!)!)
            vc.myVitrin = true
            vc.priceType = ((loadShop.res?.response?[self.selectedPackage].items?[0].price_type!)!)
            vc.isPackage = true
        }
        
        
        
    }
    
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item >= self.mainShopIndex {
            if UIDevice().userInterfaceIdiom == .phone  {
                if UIScreen.main.nativeBounds.height == 2436 {
                    //iPhone X
                    return CGSize(width: UIScreen.main.bounds.width / 3 - 17 , height: 130)
                } else {
                    //Normal iPhone
                    return CGSize(width: UIScreen.main.bounds.width / 3 - 17 , height: 130)
                }
            } else {
                //iPad
                return CGSize(width: (UIScreen.main.bounds.width  - ((UIScreen.main.bounds.width / 5) + 40)) / 3 , height: 230)
            }
        } else {
            if UIDevice().userInterfaceIdiom == .phone  {
                if UIScreen.main.nativeBounds.height == 2436 {
                    //iPhone X
                    return CGSize(width: UIScreen.main.bounds.width - 30 , height: 130)
                } else {
                    //Normal iPhone
                    return CGSize(width: UIScreen.main.bounds.width - 30 , height: 130)
                }
            } else {
                //iPad
                return CGSize(width: (UIScreen.main.bounds.width  - ((UIScreen.main.bounds.width / 5) + 40)) , height: 230)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func openCoinOrMoney(Title : String) {
        for i in 0...(loadShop.res?.response?[self.mainShopIndex].items?.count)! - 1 {
            if ((loadShop.res?.response?[self.mainShopIndex].items?[i].title!)!).contains(Title) {
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
    }
}
