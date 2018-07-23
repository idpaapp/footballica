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

    @IBOutlet weak var topMainCategoryView: DesignableView!
    @IBOutlet weak var mainCategoryView: DesignableView!
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
    var catState = String()
    var matchData : matchDetails.Response? = nil;

   var defaults = UserDefaults.standard
    var lastID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.catState == "NoCat" {
            self.topMainCategoryView.isHidden = true
            self.mainCategoryView.isHidden = true
        } else {
        lastID = defaults.string(forKey: "lastMatchId") ?? String()
        
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if self.catState == "NoCat" {
            goingToMatch()
        }
    }
    
    func goingToMatch() {
        self.performSegue(withIdentifier: "matchTime", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.catState == "NoCat" {
            return 0
        } else {
        return 3
        }
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
        self.topMainCategoryView.isHidden = true
        self.mainCategoryView.isHidden = true
        if lastID.count < 6 {
          lastID.append("\(ids[indexPath.row]),")
          defaults.set(lastID, forKey: "lastMatchId")
        } else {
          lastID = ""
          defaults.set("", forKey: "lastMatchId")
        }
        insertNewGame()
    }
    
    var updateRes : String? = nil;

    @objc func insertNewGame() {
        PubProc.HandleDataBase.readJson(wsName: "ws_UpdateGameResult", JSONStr: "{'mode': 'INS_NEW_GAME' , 'match_id' : \(((matchData?.response?.matchData?.id!)!)) , 'game_type' : \(String(selectedcategoryId))}") { data, error in
            DispatchQueue.main.async {
                
                if data != nil {
                    
                    //                print(data ?? "")
                    
                    self.updateRes = String(data: data!, encoding: String.Encoding.utf8) as String?
                    if ((self.updateRes)!) != "" {
                        self.performSegue(withIdentifier: "matchTime", sender: self)
                    } else {
                        self.insertNewGame()
                    }
                    
                } else {
                    self.insertNewGame()
                    print("Error Connection")
                    print(error as Any)
                    // handle error
                }
            }
            }.resume()
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
        vc.matchData = self.matchData
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
