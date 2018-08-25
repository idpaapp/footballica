//
//  giftsAndChargesViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/4/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import Kingfisher

class giftsAndChargesViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let giftMenu = gift()
    var pageState = String()
    let gameChargeMenu = gameCharges()
    
    @objc func addGiftMenu() {
        
        self.giftMenu.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.giftMenu.menuWidth.constant = self.giftMenu.giftWidth
        self.giftMenu.menuHeight.constant = self.giftMenu.giftHeight
        self.giftMenu.center = centerScreen().centerScreens
        self.giftMenu.menuTableView.register(UINib(nibName: "menuCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        UIApplication.shared.keyWindow!.addSubview(self.giftMenu)
        UIApplication.shared.keyWindow!.bringSubview(toFront: self.giftMenu)
        self.view.bringSubview(toFront: self.giftMenu)
        self.giftMenu.closeButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        self.giftMenu.dismissBack.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        self.giftMenu.awakeFromNib()
    }
    
    @objc func addGameChargeMenu() {
        
        self.gameChargeMenu.awakeFromNib()
        self.gameChargeMenu.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.gameChargeMenu.menuWidth.constant = self.gameChargeMenu.gameChargesWidth
        self.gameChargeMenu.menuHeight.constant = self.gameChargeMenu.gameChargesHeight
        self.gameChargeMenu.center = centerScreen().centerScreens
        self.gameChargeMenu.menuTableView.register(UINib(nibName: "menuCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        UIApplication.shared.keyWindow!.addSubview(self.gameChargeMenu)
        UIApplication.shared.keyWindow!.bringSubview(toFront: self.gameChargeMenu)
        self.view.bringSubview(toFront: self.gameChargeMenu)
        
        self.gameChargeMenu.closeButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        self.gameChargeMenu.dismissBack.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
        gameChargeCount = self.gameChargeMenu.gameChargesImages.count
    }
    
    @objc func dismissing() {
    self.giftMenu.removeFromSuperview()
    self.gameChargeMenu.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
         if pageState == "gifts" {
        addGiftMenu()
         } else {
        addGameChargeMenu()
        }
    }
    
    var gameChargeCount = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        giftMenu.menuTableView.dataSource = self
        giftMenu.menuTableView.delegate = self
        gameChargeMenu.menuTableView.dataSource = self
        gameChargeMenu.menuTableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageState == "gifts" {
        return 6
        } else {
        return gameChargeCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if pageState == "gifts" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as!  menuCell
        
        cell.menuImage.image = UIImage(named: "\(self.giftMenu.giftsImages[indexPath.row])")
        cell.menuLeftImage.image = UIImage(named: "ic_coin")
        switch indexPath.row {
        case 0:
            cell.menuLeftView.isHidden = true
        default:
            cell.menuLeftView.isHidden = false
        }
        cell.menuLeftLabel.text = self.giftMenu.giftsNumbers[indexPath.row]
        cell.menuLabel.text = self.giftMenu.giftsTitles[indexPath.row]
        cell.selectMenu.tag = indexPath.row
        cell.selectMenu.addTarget(self, action: #selector(selectedMenu), for: UIControlEvents.touchUpInside)
        return cell
            
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as!  menuCell
            
            let url = "\(self.gameChargeMenu.gameChargesImages[indexPath.row])"
            let urls = URL(string : url)
            cell.menuImage.kf.setImage(with: urls ,options:[.transition(ImageTransition.fade(0.5))])
            
            switch self.gameChargeMenu.gameChargesPriceType[indexPath.row]{
            case "2":
                cell.menuLeftImage.image = UIImage(named: "ic_coin")
            default :
                cell.menuLeftImage.image = UIImage(named: "money")
            }
        
            cell.menuLeftLabel.text = self.gameChargeMenu.gameChargesNumbers[indexPath.row]
            cell.menuLabel.text = self.gameChargeMenu.gameChargesTitles[indexPath.row]
            cell.selectMenu.tag = indexPath.row
            cell.selectMenu.addTarget(self, action: #selector(selectedMenu), for: UIControlEvents.touchUpInside)
            return cell
            
            
            
        }
    }
    
    var chargeRes : String? = nil;
    var alertTitle = String()
    var alertBody = String()
    var alertAcceptLabel = String()
    
    @objc func chargeGame(id : Int) {
        PubProc.HandleDataBase.readJson(wsName: "ws_setExtraGames", JSONStr: "{'charge_id' : '\(id)' , 'userid':'\(loadingViewController.userid)'}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    
                        self.chargeRes = String(data: data!, encoding: String.Encoding.utf8) as String?

                    
                    if ((self.chargeRes)!).contains("TRANSACTION_COMPELETE") {
                        self.alertTitle = "فوتبالیکا"
                        self.alertBody = "تراکنش با موفقیت انجام شد!"
                        self.alertAcceptLabel = "تأیید"
                        self.performSegue(withIdentifier: "giftAlert", sender: self)
                    } else {
                        self.alertTitle = "اخطار"
                        self.alertBody = "تراکنش با موفقیت انجام نشد!"
                        self.alertAcceptLabel = "تأیید"
                        self.performSegue(withIdentifier: "giftAlert", sender: self)
                    }
                    
                        DispatchQueue.main.async {
                            PubProc.wb.hideWaiting()
                            PubProc.cV.hideWarning()
                        }
                        
                    
                } else {
                    self.chargeGame(id : id)
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if let vc = segue.destination as? menuAlertViewController {
            vc.alertTitle = self.alertTitle
            vc.alertBody = self.alertBody
            vc.alertAcceptLabel = self.alertAcceptLabel
        }
    }
    
    @objc func selectedMenu(_ sender : UIButton!) {
        if pageState == "gifts" {
            
        } else {
//        print((loadingViewController.loadGameData?.response?.gameCharge[sender.tag].id!)!)
        let id = Int((loadingViewController.loadGameData?.response?.gameCharge[sender.tag].id!)!)
        self.chargeGame(id : id!)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if pageState == "gifts" {
        return 80
        } else {
        return 100
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
