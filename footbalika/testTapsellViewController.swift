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
    
    @IBOutlet weak var getAds: UIButton!
    
    @IBOutlet weak var showAds: UIButton!
    
    weak var tapsellAd : TapsellAd?
    
    func tapsellInitialize(){
        
        let config = TSConfiguration()
        config.setDebugMode(true)
        
        Tapsell.initialize(withAppKey: "ngtsdfapnnfjcmpespmjmiffspaogjdolrspgmnpttkmisjaipbtgjmcbnanaammhlkamm", andConfig: config);
        
        Tapsell.setAdShowFinishedCallback { (ad, completed) in
            
            print(completed);
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapsellInitialize();
        self.getAds.layer.cornerRadius = 10
        self.showAds.layer.cornerRadius = 10
        self.getAds.addTarget(self, action: #selector(gettingAds), for: UIControl.Event.touchUpInside)
        self.showAds.addTarget(self, action: #selector(showingAds), for: UIControl.Event.touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.gettingAds()
        })
    }
    
    @objc func gettingAds() {
        print("clock")
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
    
    @objc func showingAds() {
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
    
    @objc func dismissing() {
        self.dismiss(animated: true, completion: nil)
    }
}
