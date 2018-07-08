//
//  selectCategoryViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/17/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import RealmSwift

class selectCategoryViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {


    @IBOutlet weak var selectCategoryTV: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "selectCategoryCell", for: indexPath) as! selectCategoryCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (((3 * (UIScreen.main.bounds.height / 5)) - 40 ) / 3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
