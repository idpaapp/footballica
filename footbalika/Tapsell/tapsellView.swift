//
//  tapsellView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 10/16/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import TapsellSDKv3


class tapsellView: UIView {

 
    @IBOutlet var contentView: UIView!
    
    
    weak var tapsellAd : TapsellAd?
    func tapsellInitialize() {
        let config = TSConfiguration()
        config.setDebugMode(true)
        
        Tapsell.initialize(withAppKey: "ngtsdfapnnfjcmpespmjmiffspaogjdolrspgmnpttkmisjaipbtgjmcbnanaammhlkamm", andConfig: config);
        
        Tapsell.setAdShowFinishedCallback { (ad, completed) in
            
            print(completed);
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tapsellInitialize()
        self.gettingAds()
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
            }, andClosedCallback: { (tapsellAd) in
                print("Close Shod");
                self.dismissing()
            })
        }
    }
    
    @objc func dismissing() {
        self.removeFromSuperview()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    

    private func commonInit() {
        Bundle.main.loadNibNamed("tapsellView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
}
