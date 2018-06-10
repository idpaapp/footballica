//
//  startMatchViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/19/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class startMatchViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {


    @IBOutlet weak var startMatchTV: UITableView!
    
    var iPhonefonts = UIFont(name: "DPA_Game", size: 20)!
    var iPadfonts = UIFont(name: "DPA_Game", size: 30)!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "startMatchCell", for: indexPath) as! startMatchCell
        if UIDevice().userInterfaceIdiom == .phone {
        cell.matchResult.AttributesOutLine(font: iPhonefonts, title: "4 - 4 ", strokeWidth: -3.0)
        cell.matchTitle.AttributesOutLine(font: iPhonefonts, title: "تاریخچه", strokeWidth: -3.0)
        } else {
        cell.matchResult.AttributesOutLine(font: iPadfonts, title: "4 - 4 ", strokeWidth: -3.0)
        cell.matchTitle.AttributesOutLine(font: iPadfonts, title: "تاریخچه", strokeWidth: -3.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
