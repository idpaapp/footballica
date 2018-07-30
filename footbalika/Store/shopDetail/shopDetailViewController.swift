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
    var cellCount = CGFloat()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellCount = 10
        
        if dismissButton != nil {
            dismissButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                shopDetailWidth.constant = UIScreen.main.bounds.width - 10
                var height = 53 + ((CGFloat(ceil(Double(cellCount/3))) * 130) + (CGFloat(ceil(Double(cellCount/3))) * 10))
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
                height = 53 + ((CGFloat(ceil(Double(cellCount/3))) * 130) + (CGFloat(ceil(Double(cellCount/3))) * 10))
                } else {
                height = 53 + ((CGFloat(ceil(Double(cellCount/3))) * 110) + (CGFloat(ceil(Double(cellCount/3))) * 10))
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
             var height = 53 + ((CGFloat(ceil(Double(cellCount/3))) * 230) + (CGFloat(ceil(Double(cellCount/3))) * 10))
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
        return Int(cellCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopDetailCell", for: indexPath) as! shopDetailCell
        
        cell.shopDetailPrice.text = "Test"
        cell.shopDetailTitle.text = "Test"
        cell.shopDetailPriceForeGround.text = "Test"
        cell.shopDetailTitleForeGround.text = "Test"
        cell.shopDetailImage.image = UIImage(named: "avatar")
        cell.selectShopDetail.addTarget(self, action: #selector(showItem), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    @objc func showItem(_ sender : UIButton!) {
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
