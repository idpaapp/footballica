//
//  groupDetailViewController.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/1/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class groupDetailViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clanDetailCell", for: indexPath) as! clanDetailCell
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: UIScreen.main.bounds.width / 5 - 12 , height: 90)
        
      return size
        
    }
    

    @IBOutlet weak var clanCup: UILabel!
    
    @IBOutlet weak var clanImage: UIImageView!
    
    @IBOutlet weak var groupDetailsCV: UICollectionView!
    
    @IBOutlet weak var clanName: UILabel!
    
    @IBOutlet weak var groupTitle: UILabel!
    
    @IBOutlet weak var groupTitleForeGround: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.groupDetailsCV.register(UINib(nibName: "clanDetailCell", bundle: nil), forCellWithReuseIdentifier: "clanDetailCell")
        
        self.clanCup.backgroundColor = UIColor(patternImage: UIImage(named: "label_back_dark")!)
       
        self.clanCup.text = "2575"
        self.groupTitle.AttributesOutLine(font: fonts().iPadfonts, title: "گروه", strokeWidth: -7.0)
        self.groupTitleForeGround.font = fonts().iPadfonts
        self.groupTitleForeGround.text = "گروه"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closingGroupDetails(_ sender: RoundButton) {
        self.dismiss(animated : true , completion : nil)
    }


}
