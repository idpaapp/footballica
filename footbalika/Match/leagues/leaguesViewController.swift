//
//  leaguesViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/2/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class leaguesViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var leageTV: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.leageTV.isHidden = false
        self.leageTV.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            self.leageTV.alpha = 1.0
        }
        let leagueRow = (loadingViewController.loadGameData?.response?.gameLeagues.count)! - 1 - Int((login.res?.response?.mainInfo?.league_id)!)!
        let index = IndexPath(row: leagueRow, section: 0)
        self.leageTV.scrollToRow(at: index, at: UITableViewScrollPosition.middle, animated: false)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leageTV.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (loadingViewController.loadGameData?.response?.gameLeagues.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath) as! leagueCell
        
        cell.leagueImage.setImageWithKingFisher(url: "\((loadingViewController.loadGameData?.response?.gameLeagues[(loadingViewController.loadGameData?.response?.gameLeagues.count)! - 1 - indexPath.row].img_logo!)!)")
        
        if UIDevice().userInterfaceIdiom == .phone {
        cell.leagueTitle.AttributesOutLine(font: fonts.init().iPhonefonts, title: "\(((loadingViewController.loadGameData?.response?.gameLeagues[(loadingViewController.loadGameData?.response?.gameLeagues.count)! - 1 - indexPath.row].min_cup!)!)) +", strokeWidth: -5.0)
        } else {
        cell.leagueTitle.AttributesOutLine(font: fonts.init().iPadfonts, title: "\(((loadingViewController.loadGameData?.response?.gameLeagues[(loadingViewController.loadGameData?.response?.gameLeagues.count)! - 1 - indexPath.row].min_cup!)!)) +", strokeWidth: -5.0)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
        return 250
        } else {
        return 500
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        view.backgroundColor = .clear
        return view
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: RoundButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
