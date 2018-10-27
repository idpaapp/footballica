//
//  createClanGroupViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/5/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class createClanGroupViewController: UIViewController {

    @IBOutlet weak var createView: createClanGroupView!
    @IBOutlet weak var createViewHeight: NSLayoutConstraint!
    @IBOutlet weak var createViewWidth: NSLayoutConstraint!    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createView.closePage.addTarget(self, action: #selector(closingPage), for: UIControlEvents.touchUpInside)
    }
    
    
    @objc func closingPage() {
        openOrClose(state: "close")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        openOrClose(state: "open")
    }
    
    func openOrClose(state : String) {
        if state == "open" {
            self.createView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        } else {
            self.createView.transform = CGAffineTransform.identity
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.createView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: {(finish) in
            UIView.animate(withDuration: 0.2, animations: {
                if state == "open" {
                    self.createView.transform = CGAffineTransform.identity
                } else {
                    self.createView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
