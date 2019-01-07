//
//  noInternetViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 9/20/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class noInternetViewController: UIViewController {
    
    @IBOutlet weak var restartApplication: RoundButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        restartApplication.addTarget(self, action: #selector(restartingApp), for: UIControlEvents.touchDown)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
        DispatchQueue.main.async {
            PubProc.wb.hideWaiting()
            PubProc.cV.hideWarning()
        }
    }
    
    @objc func restartingApp() {
        //        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        PubProc.isSplash = true
        PubProc.countRetry = 0
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "iPhoneX", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "testTapsellViewController")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = viewController
            } else {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "testTapsellViewController")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = viewController
            }
        } else {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "iPad", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "testTapsellViewController")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = viewController     
        }
    }
}
