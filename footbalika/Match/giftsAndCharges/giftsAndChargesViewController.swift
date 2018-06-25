//
//  giftsAndChargesViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/4/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class giftsAndChargesViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    let menu = menuView()
    
    var giftsImages = ["ic_gift",
                       "invite_friend",
                       "ic_avatar_large",
                       "google_plus",
                       "ic_bug",
                       "ic_comment"]
    
    
    var giftsTitles = ["وارد کردن کد هدیه",
                       "دعوت دوستان",
                       "تکمیل ثبت نام",
                       "اتصال به حساب گوگل",
                       "گزارش مشکل",
                       "انتقاد و پیشنهاد"]
    
    var giftsNumbers = ["",
                        "\((loadingViewController.loadGameData?.response?.giftRewards?.invite_friend!)!)",
                        "\((loadingViewController.loadGameData?.response?.giftRewards?.sign_up!)!)",
                        "\((loadingViewController.loadGameData?.response?.giftRewards?.google_sign_in!)!)",
                        "\((loadingViewController.loadGameData?.response?.giftRewards?.report_bug!)!)",
                        "\((loadingViewController.loadGameData?.response?.giftRewards?.comment!)!)"]
    
    @objc func addMenu() {
        
        self.menu.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.menu.menuWidth.constant = 310
        self.menu.menuHeight.constant = 525
        self.menu.center = centerScreen().centerScreens
        self.menu.menuTableView.register(UINib(nibName: "menuCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        UIApplication.shared.keyWindow!.addSubview(self.menu)
        UIApplication.shared.keyWindow!.bringSubview(toFront: self.menu)
        self.view.bringSubview(toFront: self.menu)
        self.menu.isOpaque = false
        self.menu.closeButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        self.menu.dismissBack.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        if UIDevice().userInterfaceIdiom == .phone {
        self.menu.topTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "جوایز", strokeWidth: -4.0)
        } else {
        self.menu.topTitle.AttributesOutLine(font: fonts().iPadfonts, title: "جوایز", strokeWidth: -4.0)
        }
    }
    
    @objc func dismissing() {
    self.menu.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addMenu()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.menuTableView.dataSource = self
        menu.menuTableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as!  menuCell
        
        cell.menuImage.image = UIImage(named: "\(giftsImages[indexPath.row])")
        cell.menuLeftImage.image = UIImage(named: "ic_coin")
        switch indexPath.row {
        case 0:
            cell.menuLeftView.isHidden = true
        default:
            cell.menuLeftView.isHidden = false
        }
        cell.menuLeftLabel.text = giftsNumbers[indexPath.row]
        cell.menuLabel.text = giftsTitles[indexPath.row]
        cell.selectMenu.tag = indexPath.row
        cell.selectMenu.addTarget(self, action: #selector(selectedMenu), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    @objc func selectedMenu(_ sender : UIButton!) {
        print(sender.tag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
