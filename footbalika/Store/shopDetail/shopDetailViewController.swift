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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        if (loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].image_path)!.contains("coin") || (loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].image_path)!.contains("money") {
            title = (loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].qty)!
        } else {
            title = "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].title)!)"
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                //iPhone X
                cell.shopDetailPrice.AttributesOutLine(font: fonts().iPadfonts, title: "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].price)!)", strokeWidth: -5.0)
                cell.shopDetailTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(title)", strokeWidth: -5.0)
                cell.shopDetailPriceForeGround.font = fonts().iPadfonts
                cell.shopDetailTitleForeGround.font = fonts().iPadfonts
            } else {
                //other iPhones
                cell.shopDetailPrice.AttributesOutLine(font: fonts().iPadfonts, title: "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].price)!)", strokeWidth: -5.0)
                cell.shopDetailTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(title)", strokeWidth: -5.0)
                 cell.shopDetailPriceForeGround.font = fonts().iPadfonts
                cell.shopDetailTitleForeGround.font = fonts().iPadfonts
            }
            
        } else {
            //iPad
            cell.shopDetailPrice.AttributesOutLine(font: fonts().iPadfonts, title: "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].price)!)", strokeWidth: -5.0)
            cell.shopDetailTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(title)", strokeWidth: -5.0)
            cell.shopDetailPriceForeGround.font = fonts().iPadfonts
            cell.shopDetailTitleForeGround.font = fonts().iPadfonts
        }
        
        cell.shopDetailPriceForeGround.text = "\((loadShop.res?.response?[1].items?[shopIndex].package_awards?[indexPath.item].price)!)"
        cell.shopDetailTitleForeGround.text = "\(title)"
        let dataDecoded:NSData = NSData(base64Encoded: images[indexPath.row], options: NSData.Base64DecodingOptions(rawValue: 0))!
        cell.shopDetailImage.image = UIImage(data: dataDecoded as Data)
        cell.selectShopDetail.tag = indexPath.item
        cell.selectShopDetail.addTarget(self, action: #selector(showItem), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    var selectedItem = Int()
    @objc func showItem(_ sender : UIButton!) {
        selectedItem = sender.tag
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.performSegue(withIdentifier: "showShopItem", sender: self)
        }
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
            if (loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].image_path)!.contains("coin") ||  (loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].image_path)!.contains("money") {
                vc.subTitle = (loadShop.res?.response?[1].items?[shopIndex].package_awards?[selectedItem].qty)!
            }
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
