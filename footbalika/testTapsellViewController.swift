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
    
    @IBOutlet weak var loadingContainer: UIView!
    weak var tapsellAd : TapsellAd?
    func tapsellInitialize() {
        let config = TSConfiguration()
        config.setDebugMode(true)
        
        Tapsell.initialize(withAppKey: "ngtsdfapnnfjcmpespmjmiffspaogjdolrspgmnpttkmisjaipbtgjmcbnanaammhlkamm", andConfig: config);
        
        Tapsell.setAdShowFinishedCallback { (ad, completed) in
            
            print(completed);
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tapsellInitialize()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
//            self.gettingAds()
//        }

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
            showOptions.setBackDisabled(false)
            showOptions.setShowDialoge(true)
            self.tapsellAd?.show(with: showOptions, andOpenedCallback: { (tapsellAd) in
                DispatchQueue.main.async {
                    PubProc.wb.hideWaiting()
                }
                self.view.isUserInteractionEnabled = true
                print("Open Shod");
            }, andClosedCallback: { (tapsellAd) in
                print("Close Shod");
                musicPlay().playMenuMusic()
                self.dismissing()
            })
        }
    }
    
    @objc func dismissing() {
        self.view.isUserInteractionEnabled = true
        self.dismiss(animated: false, completion: nil)
    }

}
