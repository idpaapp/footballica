//
//  shopDetailViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 5/7/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class shopDetailViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var shopDetailsCV: UICollectionView!
    @IBOutlet weak var shopDetailHeight: NSLayoutConstraint!
    @IBOutlet weak var shopDetailWidth: NSLayoutConstraint!
    @IBOutlet weak var dismissButton: RoundButton!

    var images = [String]()
    var ids = [Int]()
    var shopIndex = Int()
    var myVitrin = Bool()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    var chooseRes : String? = nil ;
    
    @objc func chooseItem() {
        
        PubProc.HandleDataBase.readJson(wsName: "ws_handleCoins", JSONStr: "{'item_id' : '\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].id)!)' , 'userid' : '1' , 'trans_id' : '0'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                      print(data ?? "")
                    
                    self.chooseRes = String(data: data!, encoding: String.Encoding.utf8) as String?

                    if ((self.chooseRes)!).contains("TRANSACTION_COMPELETE") {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "showItem", sender: self)
                            self.view.isUserInteractionEnabled = true
                        }
                    } else {
                        
                    }
                    
                    
                    
                } else {
                    self.chooseItem()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
        
        
        
        
        
        
    }
    
    @objc func buyOrChoose() {
        self.view.isUserInteractionEnabled = false
        chooseItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(buyOrChoose), name: Notification.Name("buyOrChoose"), object: nil)

        
        if dismissButton != nil {
            dismissButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        }
        let roundCellCount = ceil(CGFloat(images.count)/3)
        
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
             var height = 53 + ((roundCellCount * 230) + (roundCellCount * 10))
            if height >= (UIScreen.main.bounds.height - 50) {
                height = UIScreen.main.bounds.height - 50
                self.shopDetailsCV.isScrollEnabled = true
            } else {
                self.shopDetailsCV.isScrollEnabled = false
            }
            shopDetailHeight.constant = height
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopDetailCell", for: indexPath) as! shopDetailCell
        
        var title = String()
        var price = String()
        
        if (loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].price_type)! == "0"  {
            if myVitrin {
               price = "استفاده"
            } else {
            price = "مجانی"
            }
        } else  if (loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].price_type)! == "1"  {
            if myVitrin {
                price = "استفاده"
            } else {
            price = "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].price)!) تومان"
            }
        } else {
            if myVitrin {
                price = "استفاده"
            } else {
            price = "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].price)!)"
            }
        }
        
        if (loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].type)! == "2" || (loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].type)! == "1" {
            title = "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].qty)!)"
        } else {
            title = "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].title)!)"
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                //iPhone X
                cell.shopDetailPrice.AttributesOutLine(font: fonts().iPadfonts, title: "\(price)", strokeWidth: -7.0)
                cell.shopDetailTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(title)", strokeWidth: -5.0)
                cell.shopDetailPriceForeGround.font = fonts().iPadfonts
                cell.shopDetailTitleForeGround.font = fonts().iPadfonts
            } else {
                //other iPhones
                cell.shopDetailPrice.AttributesOutLine(font: fonts().iPadfonts, title: "\(price)", strokeWidth: -7.0)
                cell.shopDetailTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(title)", strokeWidth: -5.0)
                 cell.shopDetailPriceForeGround.font = fonts().iPadfonts
                cell.shopDetailTitleForeGround.font = fonts().iPadfonts
            }
            
        } else {
            //iPad
            cell.shopDetailPrice.AttributesOutLine(font: fonts().iPadfonts, title: "\(price)", strokeWidth: -7.0)
            cell.shopDetailTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(title)", strokeWidth: -5.0)
            cell.shopDetailPriceForeGround.font = fonts().iPadfonts
            cell.shopDetailTitleForeGround.font = fonts().iPadfonts
        }
        
        cell.shopDetailPriceForeGround.text = "\(price)"
        cell.shopDetailTitleForeGround.text = "\(title)"
        let dataDecoded:NSData = NSData(base64Encoded: images[indexPath.row], options: NSData.Base64DecodingOptions(rawValue: 0))!
        cell.shopDetailImage.image = UIImage(data: dataDecoded as Data)
        cell.selectShopDetail.tag = indexPath.item
        cell.selectShopDetail.addTarget(self, action: #selector(showItem), for: UIControlEvents.touchUpInside)
        
        switch "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].price_type)!)" {
        case "1":
            cell.shopDetailTypeImage.image = UIImage()
            cell.shopDetailTypeImage.isHidden = true
            self.view.layoutIfNeeded()
        case "2":
            if myVitrin {
                cell.shopDetailTypeImage.image = UIImage()
                cell.shopDetailTypeImage.isHidden = true
                self.view.layoutIfNeeded()
            } else {
            cell.shopDetailTypeImage.image = UIImage(named: "ic_coin")
            cell.shopDetailTypeImage.isHidden = false
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
    @objc func showItem(_ sender : UIButton!) {
        selectedItem = sender.tag
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.performSegue(withIdentifier: "showShopItem", sender: self)
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
            vc.mainTitle = "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].title)!)"
            vc.mainImage = images[selectedItem]
            if (loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].type)! == "2" || (loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].type)! == "1" {
                vc.subTitle = (loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].qty)!
            }
            vc.myVitrin = self.myVitrin
            
            if (loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].price_type)! == "0"  {
                    vc.price = "مجانی"
            } else  if (loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].price_type)! == "1"  {
                    vc.price = "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].price)!) تومان"
            } else {
                    vc.price = "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].price)!)"
            }
            
             vc.priceType = "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].price_type)!)"            
        }
        
        
        if let vc = segue.destination as? ItemViewController {
            vc.ImageItem = images[selectedItem]
            vc.TitleItem = "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].title)!)"
        }
        
    }
    
    
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
    
    
}
