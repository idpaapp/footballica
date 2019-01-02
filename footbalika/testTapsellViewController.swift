//
//  testTapsellViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/18/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//
import UIKit
import TapsellSDKv3

class testTapsellViewController: UIViewController {
    
    weak var tapsellAd : TapsellAd?
    func tapsellInitialize() {
        let config = TSConfiguration()
        config.setDebugMode(true)
        
        Tapsell.initialize(withAppKey: "ngtsdfapnnfjcmpespmjmiffspaogjdolrspgmnpttkmisjaipbtgjmcbnanaammhlkamm", andConfig: config);
        
        Tapsell.setAdShowFinishedCallback { (ad, completed) in
            
            print(completed);
            matchViewController.allowShowAds = false
            //            if !self.isAdShowed {
            //            self.gettingAds()
            //            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var isAdShowed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tapsellInitialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if matchViewController.allowShowAds {
            self.view.backgroundColor = .white
            self.gettingAds()
        } else {
            self.view.backgroundColor = .clear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.changeRootVC()
                self.dismissing()
            }
        }
    }
    
    @objc func gettingAds() {
        DispatchQueue.main.async {
            let requestOptions = TSAdRequestOptions()
            requestOptions.setCacheType(CacheTypeCached)
            
            Tapsell.requestAd(forZone: "5c0668e9b9fe410001f46d66", andOptions: requestOptions, onAdAvailable:{ (tapsellAd) in
                
                NSLog("Ad Available")
                self.tapsellAd = tapsellAd
                self.showingAds()
                
            }, onNoAdAvailable: {
                NSLog("No Ad Available")
                self.dismissing()
                
            }, onError: { (error) in
                NSLog("onError:"+error!)
                self.dismissing()
                
            }, onExpiring: { (ad) in
                NSLog("Expiring")
                self.dismissing()
            })
        }
    }
    
    @objc func showingAds() {
        if(self.tapsellAd != nil)
        {
            let showOptions = TSAdShowOptions()
            showOptions.setOrientation(OrientationUnlocked)
            showOptions.setBackDisabled(true)
            showOptions.setShowDialoge(true)
            self.tapsellAd?.show(with: showOptions, andOpenedCallback: { (tapsellAd) in
                print("Open Shod");
                matchViewController.allowShowAds = false
            }, andClosedCallback: { (tapsellAd) in
                print("Close Shod");
                self.dismissing()
            })
        }
    }
    
    @objc func dismissing() {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        self.changeRootVC()
    }
    
    func changeRootVC() {
        matchViewController.allowShowAds = false
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "mainPageViewController") as! mainPageViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
}
