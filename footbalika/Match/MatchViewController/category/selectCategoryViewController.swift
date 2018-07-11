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

    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var mainTitleForeGround: UILabel!
    @IBOutlet weak var selectCategoryTV: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var images = [String]()
    var titles = [String]()
    var ids = [Int]()
    var selectedcategoryId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if titles.count != 3 {
            images = Array(self.images.prefix(3))
            titles = Array(self.titles.prefix(3))
            ids = Array(self.ids.prefix(3))
        } else {
        
        }
        if UIDevice().userInterfaceIdiom == .phone {
            mainTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "انتخاب دسته بندی سؤالات", strokeWidth: -6.0)
            mainTitleForeGround.font = fonts().iPhonefonts
        } else {
            mainTitle.AttributesOutLine(font: fonts().iPadfonts, title: "انتخاب دسته بندی سؤالات", strokeWidth: -6.0)
            mainTitleForeGround.font = fonts().iPadfonts
        }
        mainTitleForeGround.text = "انتخاب دسته بندی سؤالات"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "selectCategoryCell", for: indexPath) as! selectCategoryCell
        
        if UIDevice().userInterfaceIdiom == .phone {
        cell.questionTitle.AttributesOutLine(font: fonts().iPhonefonts, title: "\(titles[indexPath.row])", strokeWidth: -6.0)
        cell.questionForeGroundTitle.font = fonts().iPhonefonts
        } else {
        cell.questionTitle.AttributesOutLine(font: fonts().iPadfonts, title: "\(titles[indexPath.row])", strokeWidth: -6.0)
            cell.questionForeGroundTitle.font = fonts().iPadfonts
        }
        cell.questionForeGroundTitle.text = titles[indexPath.row]
        let dataDecoded:NSData = NSData(base64Encoded: images[indexPath.row], options: NSData.Base64DecodingOptions(rawValue: 0))!
        cell.questionImage.image = UIImage(data: dataDecoded as Data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedcategoryId = ids[indexPath.row]
        self.performSegue(withIdentifier: "matchTime", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                return (((5 * (UIScreen.main.bounds.height / 11)) - 65 ) / 3)
            } else {
                return (((5 * (UIScreen.main.bounds.height / 9)) - 65 ) / 3)
            }
        } else {
        return (440 / 3)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! mainMatchFieldViewController
        vc.level = "11"
        vc.category = String(selectedcategoryId)
        vc.last_questions = ""
        vc.userid = "1"
        vc.lastVC = self
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
