//
//  menuAlert2ButtonsViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/12/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class menuAlert2ButtonsViewController: UIViewController {
        
        let showAlert = menuAlert2Buttons()
        var alertTitle = String()
        var alertBody = String()
        var alertAcceptLabel = String()
        var state = String()
        var jsonStr = String()
    
        override var prefersStatusBarHidden: Bool {
            return true
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.showAlert.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            UIApplication.shared.keyWindow!.addSubview(self.showAlert)
            UIApplication.shared.keyWindow!.bringSubview(toFront: self.showAlert)
            self.view.bringSubview(toFront: self.showAlert)
            if UIDevice().userInterfaceIdiom == .phone {
                self.showAlert.wholeViewHeight.constant = 202
                self.showAlert.wholeViewWidth.constant = 240
            } else {
                self.showAlert.wholeViewHeight.constant = 250
                self.showAlert.wholeViewWidth.constant = 300
            }
            self.showAlert.wholeView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.2, animations: {
                self.showAlert.wholeView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.showAlert.wholeView.transform = CGAffineTransform.identity
                })
            })
            
            self.showAlert.closeButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
            self.showAlert.cancelButton.addTarget(self, action: #selector(dismissing), for: UIControlEvents.touchUpInside)
            self.showAlert.acceptButton.addTarget(self, action: #selector(accepting), for: UIControlEvents.touchUpInside)
            self.showAlert.isOpaque = false
            if UIDevice().userInterfaceIdiom == .phone {
                self.showAlert.topLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(self.alertTitle)", strokeWidth: -6.0)
                self.showAlert.topForeGroundLabel.text = "\(self.alertTitle)"
                self.showAlert.topForeGroundLabel.font = fonts().iPhonefonts
                self.showAlert.mainTitle.font = UIFont(name: "DPA_Game", size: 13)!
                self.showAlert.mainTitle.text = "\(self.alertBody)"

            } else {
                self.showAlert.topLabel.AttributesOutLine(font: fonts().iPhonefonts, title: "\(self.alertTitle)", strokeWidth: -6.0)
                self.showAlert.topForeGroundLabel.text = "\(self.alertTitle)"
                self.showAlert.topForeGroundLabel.font = fonts().iPhonefonts
                self.showAlert.mainTitle.font = UIFont(name: "DPA_Game", size: 13)!
                self.showAlert.mainTitle.text = "\(self.alertBody)"
            }
        }
    
    
    var predictionResponse : Response? = nil
    
    struct Response : Decodable {
        let status : String?
    }
    
    @objc func accepting() {
        switch state {
        case "prediction":
            print(jsonStr)
                    PubProc.HandleDataBase.readJson(wsName: "ws_handlePredictions", JSONStr: jsonStr) { data, error in
                        DispatchQueue.main.async {
            
            
                            if data != nil {
            
                                //                print(data ?? "")
                                
                                do {
                                    
                                    self.predictionResponse = try JSONDecoder().decode(Response.self , from : data!)

                                    print((self.predictionResponse?.status!)!)
                                    if ((self.predictionResponse?.status!)!) == "OK" {
                                        PubProc.wb.hideWaiting()
                                        self.dismissing()
                                        NotificationCenter.default.post(name: Notification.Name("refreshPrediction"), object: nil, userInfo: nil)
                                    } else {
                                        print("this has finished!")
                                        self.performSegue(withIdentifier: "notMore", sender: self)
                                    }
            
                                } catch {
                                    self.accepting()
                                    print(error)
                                }
                            } else {
                                self.accepting()
                                print("Error Connection")
                                print(error as Any)
                                // handle error
                            }
                        }
                    }.resume()
            
        default:
            print("otherStates")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! menuAlertViewController
        vc.alertState = ""
        vc.alertBody = "زمان پیش بینی این بازی تمام شده است"
        vc.alertTitle = "فوتبالیکا"
        vc.alertAcceptLabel = "تأیید"
    }
        
        @objc func dismissing() {
            UIView.animate(withDuration: 0.2, animations: {
                self.showAlert.wholeView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.showAlert.wholeView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                }, completion : { (finish) in
                    self.showAlert.removeFromSuperview()
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
}
