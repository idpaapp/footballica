//
//  StoreViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

protocol ShopTutorialDelegate {
     func shopTutorialSelect()
     func goToGroupsPage()
}

protocol ItemViewControllerDelegate {
     func continueHelp()
}

class StoreViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , ShopTutorialDelegate , ItemViewControllerDelegate {
    
    func continueHelp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tutorialState = "goToGroups"
            self.performSegue(withIdentifier: "shopTutorials", sender: self)
        }
    }
    
        
    func shopTutorialSelect() {
        self.storeCV.reloadData()
    }
    
    func goToGroupsPage() {
        scrollToPage().scrollPageViewController(index: 3)
        scrollToPage().menuButtonChanged(index: 3)
    }
    
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
        self.rData()
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
    
    var tutorialState = String()
    @objc func showShopTutorial(notification : Notification) {
        getHelp().gettingHelp(mode: "SHOP", completionHandler: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.tutorialState = "shopTutorial"
                self.performSegue(withIdentifier: "shopTutorials", sender: self)
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if storeLeftConstraint != nil {
            storeLeftConstraint.constant = UIScreen.main.bounds.width / 10
        }
        
        if storeRightConstraint != nil {
            storeRightConstraint.constant = UIScreen.main.bounds.width / 10
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showShopTutorial(notification:)), name: Notification.Name("showShopTutorial"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData(notification:)), name: Notification.Name("refreshUserData"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openCoinsOrMoney(notification:)), name: Notification.Name("openCoinsOrMoney"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showBoughtItem), name: Notification.Name("showingBoughtItem"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(choosePackage), name: Notification.Name("packageSelected"), object: nil)

        self.storeCV.allowsMultipleSelection = false
        self.xpProgressBackGround.layer.cornerRadius = 3
        xp.minimumScaleFactor = 0.5
        xp.adjustsFontSizeToFitWidth = true
    }

    var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    var bouncingObject = UIButton()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (loadShop.res?.response?.count)! == 1 {
        return (loadShop.res?.response?[self.mainShopIndex].items?.count)!
        } else {
//            print((loadShop.res?.response?[self.mainShopIndex].items?.count)! + (loadShop.res?.response?.count)! - 1)
        return (loadShop.res?.response?[self.mainShopIndex].items?.count)! + (loadShop.res?.response?.count)! - 1
//        return (loadShop.res?.response?[self.mainShopIndex].items?.count)! + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.item)
        if indexPath.item >= self.mainShopIndex {
//        if indexPath.item > 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath) as! storeCell
        cell.storeImage.setImageWithKingFisher(url: "\(((loadShop.res?.response?[self.mainShopIndex].items?[indexPath.item - self.mainShopIndex].image!)!))")
        
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
            if matchViewController.isTutorial {
                cell.storeSelect.isUserInteractionEnabled = false
            } else {
                cell.storeSelect.isUserInteractionEnabled = true
            }
        return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "packageCell", for: indexPath) as! packageCell
            print(indexPath.item)
            let url = "\(((loadShop.res?.response?[0].items?[0].image!)!))"
            let urls = URL(string: url)
            let resource = ImageResource(downloadURL: urls!, cacheKey: url)
            let processor = RoundCornerImageProcessor(cornerRadius: 10)
            cell.packageButton.kf.setBackgroundImage(with: resource , for: UIControlState.normal, options : [.transition(ImageTransition.fade(0.5)) , .processor(processor)])

            cell.packageButton.tag = indexPath.item
            cell.packageButton.addTarget(self, action: #selector(packageSelected), for: UIControlEvents.touchUpInside)
            cell.packageButton.clipsToBounds = true
            cell.packageButton.layer.cornerRadius = 10
            cell.index = 0
            return cell
        }
    }
        
    var selectedPackage = Int()
    @objc func packageSelected(_ sender : UIButton!) {
        self.selectedPackage = sender.tag
        self.performSegue(withIdentifier : "packageItem" , sender : self)
    }
    
    static var packageShowAfterWeb = String()
    
    @objc func choosePackage() {
        
        if (loadShop.res?.response?[self.selectedPackage].items?[0].price_type!)! == "0" || (loadShop.res?.response?[self.selectedPackage].items?[0].price_type!)! == "2" || (loadShop.res?.response?[self.selectedPackage].items?[0].price_type!)! == "3" {
        PubProc.HandleDataBase.readJson(wsName: "ws_handlePackages", JSONStr: "{'package_id' : '\((loadShop.res?.response?[self.selectedPackage].items?[0].id!)!)' , 'userid' : '\(loadingViewController.userid)' , 'trans_id' : '0'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                      print(data ?? "")
                    
                    let chooseRes = String(data: data!, encoding: String.Encoding.utf8) as String?
                    
                    print((chooseRes)!)
                    
                    if ((chooseRes)!).contains("TRANSACTION_COMPELETE") {
                        DispatchQueue.main.async {
                            login().loging(userid : "\(loadingViewController.userid)", rest: false, completionHandler: {
                                
                                self.performSegue(withIdentifier: "showItem", sender: self)
                                self.view.isUserInteractionEnabled = true
                                //                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    DispatchQueue.main.async{
                                        loadShop().loadingShop(userid: "\(loadingViewController.userid)" , rest: false, completionHandler: {
                                            NotificationCenter.default.post(name: Notification.Name("refreshUserData"), object: nil, userInfo: nil)
//                                            print(((loadShop.res?.response?[self.selectedPackage].items?[0].title!)!))
                                            self.rData()
                                            if  ((loadShop.res?.response?[self.selectedPackage].items?[0].title!)!) != "سکه" || ((loadShop.res?.response?[self.selectedPackage].items?[0].title!)!) != "پول"  {
                                                self.storeCV.reloadData()
                                                PubProc.wb.hideWaiting()
                                            }
                                        })
                                    }
                                //                                })
                            })
                        }
                    } else  if ((chooseRes)!).contains("NOT_ENOUGH_RESOURCE") {
                        self.view.isUserInteractionEnabled = true
                        self.notEnough = "شما به اندازه ی کافی پول یا سکه ندارید"
                        self.performSegue(withIdentifier: "shopAlert", sender: self)
                        PubProc.wb.hideWaiting()
                    } else {
                        self.view.isUserInteractionEnabled = true
                        self.notEnough = "تراکنش نا موفق بود!"
                        self.performSegue(withIdentifier: "shopAlert", sender: self)
                        PubProc.wb.hideWaiting()
                    }
                } else {
                    self.choosePackage()
                    self.view.isUserInteractionEnabled = true
                    print("Error Connection")
                    print(error as Any)
                    PubProc.wb.hideWaiting()
                    // handle error
                }
            }
            }.resume()
            
        } else {
            
            StoreViewController.packageShowAfterWeb = "{'userid' : '\(loadingViewController.userid)' , 'item_id' : '\((loadShop.res?.response?[self.selectedPackage].items?[0].id!)!)' 'item_type' : 'package'}"
            let url : NSString = PubProc.HandleString.ReplaceQoutedToDbQouted(str: "http://volcan.ir/adelica/api.v2/zarrin/request.php?json={'package_id':'\((loadShop.res?.response?[self.selectedPackage].items?[0].id!)!)','userid':'\(loadingViewController.userid)'}") as NSString
            let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            let searchURL : NSURL = NSURL(string: urlStr as String)!
            print(searchURL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(searchURL as URL, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string: "\(urlStr)")!)
            }
        }
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
        
        if let vc = segue.destination as? ItemViewController {
            vc.TitleItem = (loadShop.res?.response?[self.selectedPackage].items?[0].title!)!
            vc.ImageItem = (loadShop.res?.response?[self.selectedPackage].items?[0].image!)!
            vc.isPackage = true
            vc.delegate = self
        }
        
        if let vc = segue.destination as? menuAlertViewController {
            vc.alertTitle = "اخطار"
            vc.alertBody = "\(self.notEnough)"
            vc.alertAcceptLabel = "تأیید"
        }
        
        if let vc = segue.destination as? helpViewController {
            vc.shopDelegate = self
            vc.state = self.tutorialState
        }
    }
    
    var notEnough = String()
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var packageScreenSize = CGSize()
        if UIDevice().userInterfaceIdiom == .phone  {
            if UIScreen.main.nativeBounds.height == 2436 {
                //iphone X
                packageScreenSize = CGSize(width: UIScreen.main.bounds.width - 30 , height: 0.57 * (UIScreen.main.bounds.width - 30))
            } else {
                //Normal iPhone
                packageScreenSize = CGSize(width: UIScreen.main.bounds.width - 30 , height: 0.57 * (UIScreen.main.bounds.width - 30))
            }
        } else {
            //iPad
            packageScreenSize = CGSize(width: (UIScreen.main.bounds.width  - ((UIScreen.main.bounds.width / 5) + 40)) , height: 0.57 * (UIScreen.main.bounds.width  - ((UIScreen.main.bounds.width / 5) + 40)))
        }
        
        if indexPath.item >= self.mainShopIndex  {
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
                return CGSize(width: (UIScreen.main.bounds.width  - ((UIScreen.main.bounds.width / 5) + 40)) / 3  + 3, height: 230)
            }
        } else {
            return packageScreenSize
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
        if matchViewController.isTutorial {
            
        } else {
            openCoinOrMoney(Title: "پول")
        }
    }
    
    @IBAction func addCoin(_ sender: RoundButton) {
        if matchViewController.isTutorial {
            
        } else {
            openCoinOrMoney(Title: "سکه")
        }
        
    }
    
    @objc func showBoughtItem() {
        login().loging(userid : "\(loadingViewController.userid)", rest: false, completionHandler: {
            loadShop().loadingShop(userid: "\(loadingViewController.userid)" , rest: false, completionHandler: {
                StoreViewController.packageShowAfterWeb = ""
                self.performSegue(withIdentifier: "showItem", sender: self)
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let pageIndexDict:[String: Int] = ["button": 4]
        NotificationCenter.default.post(name: Notification.Name("selectButtonPage"), object: nil, userInfo: pageIndexDict)
        NotificationCenter.default.post(name: Notification.Name("scrollToPage"), object: nil, userInfo: pageIndexDict)
    }
}
