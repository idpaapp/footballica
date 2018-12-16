//
//  testTapsellViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/18/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//
import UIKit
import TapsellSDKv3

public class testTapsellViewController: UIViewController {
    
    weak var tapsellAd : TapsellAd?
    
    func tapsellInitialize(){
        
        let config = TSConfiguration()
        config.setDebugMode(true)
        
        Tapsell.initialize(withAppKey: "ngtsdfapnnfjcmpespmjmiffspaogjdolrspgmnpttkmisjaipbtgjmcbnanaammhlkamm", andConfig: config);
        
        Tapsell.setAdShowFinishedCallback { (ad, completed) in
            
            print(completed);
        }
    }
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tapsellInitialize()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("showADS"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.gettingAds()
    }

    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
//            self.gettingAds()
//        })
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
        DispatchQueue.main.async {
        if(self.tapsellAd != nil)
        {
            let showOptions = TSAdShowOptions()
            showOptions.setOrientation(OrientationUnlocked)
            showOptions.setBackDisabled(false)
            showOptions.setShowDialoge(true)
            self.tapsellAd?.show(with: showOptions, andOpenedCallback: { (tapsellAd) in
                print("Open Shod");
            }, andClosedCallback: { (tapsellAd) in
                print("Close Shod");
            })
        
        }
        }
    }
    
    @objc func dismissing() {
        self.dismiss(animated: true, completion: nil)
    }
}
