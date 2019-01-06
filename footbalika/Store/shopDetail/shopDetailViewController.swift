//
//  shopDetailViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import RealmSwift

class shopDetailViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var shopDetailsCV: UICollectionView!
    @IBOutlet weak var shopDetailHeight: NSLayoutConstraint!
    @IBOutlet weak var shopDetailWidth: NSLayoutConstraint!
    @IBOutlet weak var dismissButton: RoundButton!

    var shopIndex = Int()
    var myVitrin = Bool()
    var mainShopIndex = Int()
    var realm : Realm!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var chooseRes : String? = nil ;
    
    @objc func chooseItem() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_handleCoins", JSONStr: "{'item_id' : '\((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].id)!)' , 'userid' : '\(matchViewController.userid)' , 'trans_id' : '0'}") { data, error in
            DispatchQueue.main.async {
                
                
                if data != nil {
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    
                    //                      print(data ?? "")
                    
                    self.chooseRes = String(data: data!, encoding: String.Encoding.utf8) as String?
                    
                    if ((self.chooseRes)!).contains("TRANSACTION_COMPELETE") {
                        DispatchQueue.main.async {
                            login().loging(userid : "\(matchViewController.userid)", rest: false, completionHandler: {
                                
                                self.performSegue(withIdentifier: "showItem", sender: self)
                                self.view.isUserInteractionEnabled = true
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    if self.myVitrin {
                                        PubProc.wb.hideWaiting()
                                    } else {
                                        DispatchQueue.main.async{
                                            loadShop().loadingShop(userid: "\(matchViewController.userid)" , rest: false, completionHandler: {
                                                NotificationCenter.default.post(name: Notification.Name("refreshUserData"), object: nil, userInfo: nil)
                                                print(((loadShop.res?.response?[self.mainShopIndex].items?[self.shopIndex].title!)!))
                                                if  ((loadShop.res?.response?[self.mainShopIndex].items?[self.shopIndex].title!)!) != "سکه" || ((loadShop.res?.response?[self.mainShopIndex].items?[self.shopIndex].title!)!) != "پول"  {
                                                    self.shopDetailsCV.reloadData()
                                                    PubProc.wb.hideWaiting()
                                                    self.sizingPage()
                                                }
                                            })
                                        }
                                    }
//                                })
                            })
                            
//                            if self.myVitrin {
//
//                            } else {
//                                DispatchQueue.main.async{
//                                    loadShop().loadingShop(userid: "\(loadingViewController.userid)" , rest: false, completionHandler: {
//                                        NotificationCenter.default.post(name: Notification.Name("refreshUserData"), object: nil, userInfo: nil)
//                                        print(((loadShop.res?.response?[1].items?[self.shopIndex].title!)!))
//                                        if  ((loadShop.res?.response?[1].items?[self.shopIndex].title!)!) != "سکه" || ((loadShop.res?.response?[1].items?[self.shopIndex].title!)!) != "پول"  {
//                                        self.shopDetailsCV.reloadData()
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                                                PubProc.wb.hideWaiting()
//                                            })
//                                        self.sizingPage()
//                                        }
//                                    })
//                                }
//                            }
                        }
                    } else  if ((self.chooseRes)!).contains("NOT_ENOUGH_RESOURCE") {
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
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                            PubProc.cV.hideWarning()
                        }
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "noInternetViewController")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = viewController
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.chooseItem()
                        })
                    }
                    self.view.isUserInteractionEnabled = true
                    print("Error Connection")
                    print(error as Any)
                    PubProc.wb.hideWaiting()
                    // handle error
                }
            }
            }.resume()
    }
    
    var intCash = Int()
    var intCoin = Int()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        intCash = Int((login.res?.response?.mainInfo?.cashs)!)!
        intCoin = Int((login.res?.response?.mainInfo?.coins)!)!
    }
    
    @objc func buyOrChoose() {
        self.view.isUserInteractionEnabled = false
        chooseItem()
    }
    
    @objc func openWbsite() {
        
//        let urls = PubProc.HandleString.ReplaceQoutedToDbQouted(str: "http://volcan.ir/adelica/api.v2/zarrin/request.php?json={'itemid':'\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].id)!)','userid':'\(loadingViewController.userid)'}")
//        if let url = URL(string: urls) {
//            let svc = SFSafariViewController(url: url)
//            self.present(svc, animated: true, completion: nil)
//            svc.delegate = self
//        }
        
        StoreViewController.packageShowAfterWeb = "{'userid' : '\(matchViewController.userid)' , 'item_id' : '\((loadShop.res?.response?[self.mainShopIndex].items?[self.shopIndex].package_awards?[self.selectedItem].id)!)' ,  'item_type' : 'COIN'}"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            let url : NSString = PubProc.HandleString.ReplaceQoutedToDbQouted(str: "http://volcan.ir/adelica/api.v2/zarrin/request.php?json={'itemid':'\((loadShop.res?.response?[self.mainShopIndex].items?[self.shopIndex].package_awards?[self.selectedItem].id)!)','userid':'\(matchViewController.userid)'}") as NSString
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
    
    
    @objc func sizingPage() {
        
        intCash = Int((login.res?.response?.mainInfo?.cashs)!)!
        intCoin = Int((login.res?.response?.mainInfo?.coins)!)!
        
        var roundCellCount = ceil(CGFloat((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?.count)!)/3)
        if roundCellCount == 0 {
            roundCellCount = 2
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                shopDetailWidth.constant = UIScreen.main.bounds.width - 10
                var height = 53 + ((roundCellCount * 130) + (roundCellCount * 10))
                if height >= (UIScreen.main.bounds.height - 70) {
                    height = UIScreen.main.bounds.height - 70
                    self.shopDetailsCV.isScrollEnabled = true
                } else {
                    self.shopDetailsCV.isScrollEnabled = false
                }
                shopDetailHeight.constant = height
                
            } else {
                
                shopDetailWidth.constant = UIScreen.main.bounds.width - 10
                var height = CGFloat()
                if UIScreen.main.bounds.height > 568 {
                    height = 53 + ((roundCellCount * 130) + (roundCellCount * 10))
                } else {
                    height = 53 + ((roundCellCount * 110) + (roundCellCount * 10))
                }
                if height >= (UIScreen.main.bounds.height - 10) {
                    height = UIScreen.main.bounds.height - 10
                    self.shopDetailsCV.isScrollEnabled = true
                } else {
                    self.shopDetailsCV.isScrollEnabled = false
                }
                shopDetailHeight.constant = height
            }
            
        } else {
            shopDetailWidth.constant = UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 5)
            
            let width = UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 5)
            if  width > 614.4 {
                shopDetailWidth.constant = 614.4
            } else {
                shopDetailWidth.constant = width
            }
            
            var height = 60 + ((roundCellCount * 230) + (roundCellCount * 10))
            if height >= (UIScreen.main.bounds.height - 50) {
                height = UIScreen.main.bounds.height - 50
                self.shopDetailsCV.isScrollEnabled = true
            } else {
                self.shopDetailsCV.isScrollEnabled = false
            }
            shopDetailHeight.constant = height
        }
    }
    
    @objc func showBoughtItem() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_verifyPurchase", JSONStr: "\(StoreViewController.packageShowAfterWeb)") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                      print(data ?? "")
                    
                    let trans = String(data: data!, encoding: String.Encoding.utf8) as String?
                    
                    
                    print(trans!)
                    DispatchQueue.main.async {
                        PubProc.cV.hideWarning()
                    }
                    StoreViewController.packageShowAfterWeb = ""
                    if ((trans)!).contains("TRANSACTION_OK") {
                        login().loging(userid : "\(matchViewController.userid)", rest: false, completionHandler: {
                            loadShop().loadingShop(userid: "\(matchViewController.userid)" , rest: false, completionHandler: {
                                self.performSegue(withIdentifier: "showItem", sender: self)
                            })
                        })
                    } else {}
                    DispatchQueue.main.async {
                        PubProc.wb.hideWaiting()
                    }
                    PubProc.countRetry = 0
                } else {
                    PubProc.countRetry = PubProc.countRetry + 1
                    if PubProc.countRetry == 10 {
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                            PubProc.cV.hideWarning()
                        }
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "noInternetViewController")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = viewController
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.showBoughtItem()
                        })
                    }
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         realm = try? Realm()
        
        NotificationCenter.default.addObserver(self, selector: #selector(buyOrChoose), name: Notification.Name("buyOrChoose"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(openWbsite), name: Notification.Name("openBuyWebsite"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showBoughtItem), name: Notification.Name("showingBoughtItem"), object: nil)
        
        if dismissButton != nil {
            dismissButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        }
        
        sizingPage()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopDetailCell", for: indexPath) as! shopDetailCell
        
        var title = String()
        var price = String()
        
        if (loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[indexPath.item].price_type)! == "0"  {
            if myVitrin {
               price = "استفاده"
            } else {
            price = "مجانی"
            }
        } else  if (loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[indexPath.item].price_type)! == "1"  {
            if myVitrin {
                price = "استفاده"
            } else {
            price = "\((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[indexPath.item].price)!) تومان"
            }
        } else {
            if myVitrin {
                price = "استفاده"
            } else {
            price = "\((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[indexPath.item].price)!)"
            }
        }
        
        if (loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[indexPath.item].type)! == "2" || (loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[indexPath.item].type)! == "1" {
            title = "\((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[indexPath.item].qty)!)"
        } else {
            title = "\((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[indexPath.item].title)!)"
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                //iPhone X
                cell.shopDetailPrice.AttributesOutLine(font: fonts().iPadfonts, title: "\(price)", strokeWidth: 8.0)
                cell.shopDetailTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(title)", strokeWidth: 8.0)
                cell.shopDetailPriceForeGround.font = fonts().iPadfonts
                cell.shopDetailTitleForeGround.font = fonts().iPadfonts
            } else {
                //other iPhones
                cell.shopDetailPrice.AttributesOutLine(font: fonts().iPadfonts, title: "\(price)", strokeWidth: 8.0)
                cell.shopDetailTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(title)", strokeWidth: 8.0)
                 cell.shopDetailPriceForeGround.font = fonts().iPadfonts
                cell.shopDetailTitleForeGround.font = fonts().iPadfonts
            }
            
        } else {
            //iPad
            cell.shopDetailPrice.AttributesOutLine(font: fonts().iPadfonts, title: "\(price)", strokeWidth: 8.0)
            cell.shopDetailTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(title)", strokeWidth: 8.0)
            cell.shopDetailPriceForeGround.font = fonts().iPadfonts
            cell.shopDetailTitleForeGround.font = fonts().iPadfonts
        }
        
        cell.shopDetailPriceForeGround.text = "\(price)"
        cell.shopDetailTitleForeGround.text = "\(title)"
        let intID = Int((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[indexPath.item].id!)!)
        cell.shopDetailImage.setImageWithRealmId(id: intID!)
        cell.selectShopDetail.tag = indexPath.item
        cell.selectShopDetail.addTarget(self, action: #selector(showItem), for: UIControlEvents.touchUpInside)
        
        switch "\((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[indexPath.item].price_type)!)" {
        case "1":
            cell.shopDetailTypeImage.image = UIImage()
            cell.shopDetailTypeImage.isHidden = true
            cell.shopDetailTypeImage.transform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
            self.view.layoutIfNeeded()
        case "2":
            if myVitrin {
                cell.shopDetailTypeImage.image = UIImage()
                cell.shopDetailTypeImage.isHidden = true
                self.view.layoutIfNeeded()
            } else {
            cell.shopDetailTypeImage.image = UIImage(named: "ic_coin")
            cell.shopDetailTypeImage.isHidden = false
                let intPrice = Int(price)
                if intPrice! > intCoin {
                    cell.shopDetailPrice.textColor = UIColor.init(red: 251/255, green: 31/255, blue: 102/255, alpha: 1.0)
                    cell.shopDetailPriceForeGround.textColor = UIColor.init(red: 251/255, green: 31/255, blue: 102/255, alpha: 1.0)
                    } else {
                    cell.shopDetailPrice.textColor = UIColor.white
                    cell.shopDetailPriceForeGround.textColor = UIColor.white
                }
            self.view.layoutIfNeeded()
            }
        case "3":
            if myVitrin {
                cell.shopDetailTypeImage.image = UIImage()
                cell.shopDetailTypeImage.isHidden = true
                self.view.layoutIfNeeded()
            } else {
            cell.shopDetailTypeImage.image = UIImage(named: "money")
            cell.shopDetailTypeImage.isHidden = false
                let intPrice = Int(price)
                
                if intPrice! > intCash {
                    cell.shopDetailPrice.textColor = UIColor.init(red: 251/255, green: 31/255, blue: 102/255, alpha: 1.0)
                    cell.shopDetailPriceForeGround.textColor = UIColor.init(red: 251/255, green: 31/255, blue: 102/255, alpha: 1.0)
                } else {
                    cell.shopDetailPrice.textColor = UIColor.white
                    cell.shopDetailPriceForeGround.textColor = UIColor.white
                }
            self.view.layoutIfNeeded()
            }
        default:
            cell.shopDetailTypeImage.image = UIImage()
            cell.shopDetailTypeImage.isHidden = true
            self.view.layoutIfNeeded()
        }
        
        return cell
    }
    
    var selectedItem = Int()
    var notEnough = String()
    @objc func showItem(_ sender : UIButton!) {
        selectedItem = sender.tag
        var showAlert = false
        let priceInt = Int((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].price)!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.myVitrin == false {
                if  ((loadShop.res?.response?[self.mainShopIndex].items?[self.shopIndex].package_awards?[self.selectedItem].price_type)!) == "2" ||  ((loadShop.res?.response?[self.mainShopIndex].items?[self.shopIndex].package_awards?[self.selectedItem].price_type)!) == "3" {
                    if  ((loadShop.res?.response?[self.mainShopIndex].items?[self.self.shopIndex].package_awards?[self.selectedItem].price_type)!) == "2" {
                    
                        if priceInt! > self.intCoin {
                        showAlert = true
                        self.notEnough = "شما به مقدار کافی سکه ندارید!"
                        self.performSegue(withIdentifier: "shopAlert", sender: self)
                    }
                    
                } else {
                    
                        if priceInt! > self.intCash {
                        showAlert = true
                        self.notEnough = "شما به مقدار کافی پول ندارید!"
                        self.performSegue(withIdentifier: "shopAlert", sender: self)
                    }
                }
            }
            }
        }
    
        if showAlert == false {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.performSegue(withIdentifier: "showShopItem", sender: self)
            }
        }
    }
    
    @objc func showMySelectedVitrin() {
            self.performSegue(withIdentifier: "showItem", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice().userInterfaceIdiom == .phone  {
            if UIScreen.main.nativeBounds.height == 2436 {
                //iPhone X
                return CGSize(width: shopDetailWidth.constant / 3 - 20 , height: 130)
            } else {
                if UIScreen.main.bounds.height > 568 {
                    return CGSize(width: shopDetailWidth.constant / 3 - 20 , height: 130)
                } else {
                    return CGSize(width: shopDetailWidth.constant / 3 - 20 , height: 110)
                }
            }
        } else {
            return CGSize(width: shopDetailWidth.constant / 3 - 20 , height: 230)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? showItemViewController {
            vc.mainTitle = "\((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].title)!)"
            let intID = Int((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].id!)!)
            let realmID = self.realm.objects(tblShop.self).filter("id == \(intID!)")
            vc.mainImage = (realmID.first?.img_base64)!
            if (loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].type)! == "2" || (loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].type)! == "1" {
                vc.subTitle = (loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].qty)!
            }
            vc.myVitrin = self.myVitrin
            
            if (loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].price_type)! == "0"  {
                    vc.price = "مجانی"
            } else  if (loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].price_type)! == "1"  {
                    vc.price = "\((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].price)!) تومان"
            } else {
                    vc.price = "\((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].price)!)"
            }
            
             vc.priceType = "\((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].price_type)!)"
        }
        
        if let vc = segue.destination as? ItemViewController {
            let intID = Int((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].id!)!)
            let realmID = self.realm.objects(tblShop.self).filter("id == \(intID!)")
            vc.ImageItem = (realmID.first?.img_base64)!
            vc.TitleItem = "\((loadShop.res?.response?[self.mainShopIndex].items?[shopIndex].package_awards?[selectedItem].title)!)"
            vc.isShopItem = true
        }
        
        if let vc = segue.destination as?  menuAlertViewController {
            vc.alertTitle = "اخطار"
            vc.alertBody = "\(self.notEnough)"
            vc.alertAcceptLabel = "تأیید"
        }
        
        if let vc = segue.destination as? helpViewController {
            vc.desc = ["\(self.helpDescTitle)"]
            vc.acceptTitle = ["\(self.helpAcceptTitle)"]
            vc.state = "SHOP_HELP"
        }
        
    }
    
    
    var helpDescTitle = String()
    var helpAcceptTitle = String()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissShopDetail(_ sender: RoundButton) {
        dismissing()
    }
    
   @objc func  dismissing() {
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showShopHelp(_ sender: RoundButton) {
        showingHelp()
    }
    
    @objc func showingHelp() {
        
        getHelp().gettingHelp(mode: "SHOP_HELP", completionHandler: {
            if helpViewController.helpRes?.response?[self.shopIndex].desc_text != nil {
                self.helpDescTitle = (helpViewController.helpRes?.response?[self.shopIndex].desc_text!)!
            } else {
                self.helpDescTitle = ""
            }
            
            if helpViewController.helpRes?.response?[self.shopIndex].key_title != nil {
                self.helpAcceptTitle = (helpViewController.helpRes?.response?[self.shopIndex].key_title!)!
            } else {
                self.helpAcceptTitle = ""
            }
            self.performSegue(withIdentifier: "helping", sender: self)
        })
    }
    
}
