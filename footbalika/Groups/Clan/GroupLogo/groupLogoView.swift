//
//  groupLogoView.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 8/6/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit

class groupLogoView: UIView , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "logoCell", for: indexPath) as! logoCell
        
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.contentView.frame.width / 3 - 20, height: self.contentView.frame.width / 3 - 20)
        return size
    }
    

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var closeButton: RoundButton!
    
    @IBOutlet weak var logoCV: UICollectionView!
    
    var cellCount = 10
    override func awakeFromNib() {
        super.awakeFromNib()
        self.logoCV.delegate = self
        self.logoCV.dataSource = self
        self.logoCV.register(UINib(nibName: "logoCell", bundle: nil), forCellWithReuseIdentifier: "logoCell")
        self.logoCV.layer.backgroundColor = UIColor.clear.cgColor
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
        Bundle.main.loadNibNamed("groupLogoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }

}
