//
//  connectionView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/11/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

public class connectionView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var noWifiLogo: UIImageView!    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    var noWifiTimer: Timer!
    public func showWarning() {
        noWifiTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(showNoWifi), userInfo: nil, repeats: true)
        if PubProc.showWarning == false {
            PubProc.showWarning = true
            DispatchQueue.main.async {
                self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                UIApplication.shared.keyWindow!.addSubview(self)
                UIApplication.shared.keyWindow!.bringSubview(toFront: self)
                self.layer.zPosition = 5
                self.isOpaque = false
            }
        }
    }
    
    @objc func showNoWifi() {
        //        UIView.animate(withDuration: 1.0, animations: {
        //            self.noWifiLogo.alpha = 0.5
        //        }, completion: { (finish) in
        //            UIView.animate(withDuration: 1.0, animations: {
        //                self.noWifiLogo.alpha = 1.0
        //            })
        //        })
    }
    
    public func hideWarning() {
        if noWifiTimer != nil {
            noWifiTimer.invalidate()
        }
        if PubProc.showWarning == true {
            PubProc.showWarning = false
            DispatchQueue.main.async {
                self.removeFromSuperview()
            }
        }
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("connectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
    
}
